_       = require "underscore"
config  = require "config"
request = require "request-promise"
express = require "express"
Promise = require "bluebird"
router  = express.Router()

{ encodeRFC1738, get_twitter_bearer_token } = require "../../lib/utils"

{ StatusCodeError } = require "request-promise/errors"

token = null

twitter_request = (opts) ->
	new Promise (resolve, reject) ->
		throw new Error "No token" unless token
		opts = _.extend {}, opts, headers: "Authorization": "Bearer #{token}"
		request opts

router.get "/trending/:woeid", (req, res, next) ->
	return next new Error "No woeid specified..." unless req.params.woeid

	get_twitter_bearer_token process.env.TWITTER_API_KEY, process.env.TWITTER_API_SECRET
		.then (res) ->
			{ token_type, access_token } = res
			throw new Error "Unexpected token_type! '#{token_type}'" unless token_type is "bearer"
			token = access_token
			token

		.then (token) ->
			twitter_request
				method: "GET"
				url:    "https://api.twitter.com/1.1/trends/place.json?id=#{req.params.woeid}"
				json:   true

		.then (result) ->
			{ trends } = _.first result
			trends.sort (p, n) -> n.tweet_volume - p.tweet_volume
			res.json _.map trends, (trend, index) ->
				_(trend).pick [ "name", "url", "tweet_volume" ]

		.catch StatusCodeError, (error) ->
			next new Error "Ouch #{error.statusCode} #{error.message}"

		.catch (error) ->
			next error

module.exports = router
