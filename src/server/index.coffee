express = require "express"
webpack = require "webpack"
path    = require "path"
webpackDevMiddleware = require 'webpack-dev-middleware'
log     = require "winston"

webpackConfig = require "../../webpack.config"

compiler = webpack webpackConfig

app = express()

if process.env.NODE_ENV is "development"
	log.info "Using dev middleware : )"
	app.use webpackDevMiddleware compiler, publicPath: webpackConfig.output.publicPath
	app.use require('webpack-hot-middleware') compiler

app.use express.static path.join __dirname + "/public"

app.use "/api/v1", require "./api/v1"


app.listen 3000, ->
	console.log "listening"
