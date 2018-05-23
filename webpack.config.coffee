HtmlWebpackPlugin = require 'html-webpack-plugin'
webpack           = require 'webpack'

config =
	entry:
		app: [ './src/client/index.coffee', 'webpack-hot-middleware/client' ],

	mode: process.env.NODE_ENV

	output:
		filename:   "bundle.js"
		path:       "#{__dirname}/dist"
		publicPath: "/"

	module:
		rules: [
			{
				test: /\.(png|svg|jpg|gif)$/
				use:  [
					'file-loader'
				]
			}
			{
				test: /\.scss$/
				use: [
					'style-loader'
					'css-loader'
					'sass-loader'
				]
			}
			{
				test: /\.coffee$/
				use: [
					{
						loader: 'coffee-loader'
						options:
							transpile:
								presets: ['env', 'react']
					}
				]
			}
			{
				test: /\.js$/
				exclude: /(node_modules|bower_components)/
				use:
					loader: 'babel-loader'
					options:
						presets: ['env', 'react']
						plugins: [ 'react-hot-loader/babel' ],
			}
		]

	plugins: [
		new HtmlWebpackPlugin
			title:    "Ingress!"
			template: './src/client/index.html'
			inject:   'body'
		new webpack.NamedModulesPlugin()
		new webpack.HotModuleReplacementPlugin()
	]

	node:
		console: true
		fs:      "empty"
		net:     "empty"
		tls:     "empty"

module.exports = config
