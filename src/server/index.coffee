_       = require "underscore"
config  = require "config"
express = require "express"
webpack = require "webpack"
path    = require "path"
webpackDevMiddleware = require 'webpack-dev-middleware'
log     = require "winston"
global.Promise = require "bluebird"

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

app.use (error, req, res, next) ->
	log.error error
	res.status(500).json message: error.message

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
		console.log "woeds",
			_.chain woeids
				.map (d) -> d.placeType.name
				.uniq()
				.sortBy "name"
				.value()
		app.set "woeids",
			_.chain woeids
				.filter (d) -> d.placeType.name is "Country"
				.map    (d) -> _(d).pick [ "countryCode", "name", "woeid" ]
				.sortBy "name"
				.value()

	.then ->
		new Promise (resolve) ->
			app.listen 3000, (error) ->
				throw error if error
				log.info "listening"
				resolve()
	.catch (error) ->
		throw new Error "Error starting! #{error.message}"
