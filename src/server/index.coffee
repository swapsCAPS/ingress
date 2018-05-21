_       = require "underscore"
config  = require "config"
express = require "express"
webpack = require "webpack"
path    = require "path"
webpackDevMiddleware = require 'webpack-dev-middleware'
log     = require "winston"
Promise = require "bluebird"

webpackConfig = require "../../webpack.config"

{ get_twitter_bearer_token } = require "./lib/utils"

compiler = webpack webpackConfig

app = express()

if process.env.NODE_ENV is "development"
	log.info "Using dev middleware : )"
	app.use webpackDevMiddleware compiler, publicPath: webpackConfig.output.publicPath
	app.use require('webpack-hot-middleware') compiler

app.use express.static path.join __dirname + "/public"

app.use "/api/v1", require "./api/v1"

app.use (error, req, res, next) ->
	console.log "oh sjit"
	log.error error
	res.sendStatus 500

get_twitter_bearer_token config.apis.twitter.key, config.apis.twitter.secret
	.then (token) ->
		app.set "twitter_bearer_token", token
		new Promise (resolve) ->
			app.listen 3000, (error) ->
				throw error if error
				log.info "listening"
				resolve()
	.catch (error) ->
		throw new Error "Error starting! #{error.message}"
