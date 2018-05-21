_       = require "underscore"
request = require "request-promise"
Promise = require "bluebird"

encodeRFC1738 = (str) ->
	encodeURIComponent(str)
		.replace(/!/g, '%21')
		.replace(/'/g, '%27')
		.replace(/\(/g, '%28')
		.replace(/\)/g, '%29')
		.replace(/\*/g, '%2A')

get_twitter_bearer_token = (key, secret) ->
	new Promise (resolve) ->
		throw new Error "pass in key and secret plz" unless key and secret
		key     = encodeRFC1738 key
		secret  = encodeRFC1738 secret
		resolve Buffer.from("#{key}:#{secret}").toString "base64"
	.then (encoded) ->
		request
			method:  "POST"
			url:     "https://api.twitter.com/oauth2/token"
			json:    true
			headers:
				"Authorization": "Basic #{encoded}"
				"Content-Type":  "application/x-www-form-urlencoded"
			body: "grant_type=client_credentials"
	.then (response) ->
		{ token_type, access_token } = response
		if token_type isnt "bearer" or _.isEmpty access_token
			throw new Error "invalid response"
		access_token
	.timeout 5000, "Getting bearer token timed out"

module.exports = {
	encodeRFC1738
	get_twitter_bearer_token
}
