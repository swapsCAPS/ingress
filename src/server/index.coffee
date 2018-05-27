_       = require "underscore"
config  = require "config"
express = require "express"
webpack = require "webpack"
path    = require "path"
webpackDevMiddleware = require 'webpack-dev-middleware'
global.Promise = require "bluebird"
log     = require("./lib/log")()

process.on "unhandledRejection", (e) -> throw e

webpackConfig = require "../../webpack.config"

{ get_twitter_bearer_token, twitter_request } = require "./lib/utils"

compiler = webpack webpackConfig

app = express()

if process.env.NODE_ENV is "development"
	log.info "Using dev middleware : )"
	app.use webpackDevMiddleware compiler, publicPath: webpackConfig.output.publicPath
	app.use require('webpack-hot-middleware') compiler

app.use express.static path.join __dirname + "/public"

app.use "/api/v1", require "./api/v1"

get_twitter_bearer_token config.apis.twitter.key, config.apis.twitter.secret
	.then (token) ->
		app.set "twitter_bearer_token", token
		token

	.then (token) ->

		twitter_request token,
			method: "GET"
			url:    "https://api.twitter.com/1.1/trends/available"
			json:   true
		.timeout 5000

	.then (woeids) ->
		woeids = _.chain woeids
			.map    (d) ->
				_(d).pick [ "country", "countryCode", "name", "woeid" ]
			.groupBy "country"
			.value()
		app.set "woeids", woeids

	.then ->
		new Promise (resolve) ->
			app.listen 3000, (error) ->
				throw error if error
				log.info "listening"
				resolve()
	.catch (error) ->
		throw new Error "Error starting! #{error.message}"
