_       = require "underscore"
config  = require "config"
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
	throw new Error "pass in key and secret plz" unless key and secret
	key     = encodeRFC1738 key
	console.log('key', key)
	secret  = encodeRFC1738 secret
	console.log('secret', secret)
	encoded = Buffer.from("#{key}:#{secret}").toString "base64"
	opts    =
		method:  "POST"
		url:     "https://api.twitter.com/oauth2/token"
		headers:
			"Authorization": "Basic #{encoded}"
			"Content-Type":  "application/x-www-form-urlencoded"
		body: "grant_type=client_credentials"
	console.log('opts', opts)

	request opts

get_twitter_bearer_token process.env.TWITTER_API_KEY, process.env.TWITTER_API_SECRET
	.then (res, body) ->
		console.log('res', res)
		console.log('body', body)
	.catch (error) ->
		console.error "oops", error





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
