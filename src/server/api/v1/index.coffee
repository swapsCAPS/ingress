Promise                 = require "bluebird"
_                       = require "underscore"
config                  = require "config"
express                 = require "express"
jsonstream2             = require "jsonstream2"
log                     = require("../../lib/log")()
pump                    = require "pump"
request                 = require "request"
requestP                = require "request-promise"
router                  = express.Router()
{ Transform, Writable } = require "stream"

{ encodeRFC1738, get_twitter_bearer_token, twitter_request } = require "../../lib/utils"

{ StatusCodeError } = require "request-promise/errors"

router.get "/woeids", (req, res, next) ->
	res.json req.app.get "woeids"

router.get "/trending/google/:geo?", (req, res, next) ->
	return next new Error "No geo specified..." unless req.params.geo

	httpReqStream = request
		url: "https://trends.google.com/trends/api/stories/latest"
		qs:
			hl:   "nl"
			tz:   0
			cat:  "all"
			fi:   0
			fs:   0
			geo:  req.params.geo.toUpperCase()
			ri:   300
			rs:   30
			sort: 0

	httpReqStream.once "response", (response) ->
		if response.statusCode >= 400
			httpReqStream.emit "error", new Error "#{response.statusCode} #{response.statusMessage}"

	lastChunk = null
	pump [
		httpReqStream

		new Transform
			objectMode:   false
			transform:    (chunk, enc, cb) =>
				lastChunk = chunk
				nextLine = chunk.toString().split('\n')[1]
				return cb null, nextLine if nextLine
				cb null, chunk

		jsonstream2.parse [ "storySummaries", "trendingStories" ]

		new Writable
			objectMode: true
			write:      (trends, enc, cb) ->
				res.json _(trends).map (trend) -> _(trend).pick [ "title" ]
				cb()

	], (error) ->
		if error
			log.error "Last chunk", lastChunk.toString() if lastChunk
			next new Error "Error getting Google trends: #{error.message}"

router.get "/trending/twitter/:woeid", (req, res, next) ->
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

router.use (error, req, res, next) ->
	log.error "#{req.path} #{error.message}"
	res.status(500).json message: error.message

module.exports = router
