_       = require "underscore"
config  = require "config"
request = require "request-promise"
Promise = require "bluebird"

get_bearer_token = ->
	url  = "https://api.twitter.com/oauth2/token"

	opts = {
		url
		json: true
		body:
			grant_type: process.env.TWITTER_ACCESS_TOKEN
	}

	request.post opts

get_bearer_token()
	.then console.log


# requests = config.apis.map (api) ->
	# [ "base_url", "endpoint", "key" ].map (k) ->
		# throw new Error "No #{k} defined" if _.isEmpty api[k]

	# { protocol, base_url, endpoint, key } = api
	# protocol = protocol or "https"

	# url  = "#{protocol}://#{base_url}/#{endpoint}"

	# opts = {
		# url
		# json: true
	# }

	# request opts


# Promise.all [get_bearer_token].concat requests
	# .then (results) ->
		# console.log "results", results
	# .catch (error) ->
		# console.log "error", error
		# throw error
