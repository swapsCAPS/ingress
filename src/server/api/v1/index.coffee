_       = require "underscore"
config  = require "config"
request = require "request-promise"
express = require "express"
Promise = require "bluebird"
router  = express.Router()
app     = express()

{ encodeRFC1738, get_twitter_bearer_token } = require "../../lib/utils"

{ StatusCodeError } = require "request-promise/errors"

twitter_request = (token, opts) ->
	new Promise (resolve) ->
		throw new Error "No token" unless token
		resolve _.extend {}, opts, headers: "Authorization": "Bearer #{token}"
	.then (opts) ->
		request opts

router.get "/trending/:woeid", (req, res, next) ->
	return next new Error "No woeid specified..." unless req.params.woeid

	twitter_request req.app.get("twitter_bearer_token"),
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
