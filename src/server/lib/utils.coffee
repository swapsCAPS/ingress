request = require "request-promise"

encodeRFC1738 = (str) ->
	encodeURIComponent(str)
		.replace(/!/g, '%21')
		.replace(/'/g, '%27')
		.replace(/\(/g, '%28')
		.replace(/\)/g, '%29')
		.replace(/\*/g, '%2A')

get_twitter_bearer_token = (key, secret) ->
	throw new Error "pass in key and secret plz" unless key and secret
	key     = encodeRFC1738 key
	secret  = encodeRFC1738 secret
	encoded = Buffer.from("#{key}:#{secret}").toString "base64"
	request
		method:  "POST"
		url:     "https://api.twitter.com/oauth2/token"
		json:    true
		headers:
			"Authorization": "Basic #{encoded}"
			"Content-Type":  "application/x-www-form-urlencoded"
		body: "grant_type=client_credentials"

module.exports = {
	encodeRFC1738
	get_twitter_bearer_token
}
