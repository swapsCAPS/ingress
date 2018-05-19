module.exports =
	apis: [
		{
			name: "twitter trending"
			key:  process.env.TWITTER_ACCESS_TOKEN
			base_url: "www.twitter.com"
			endpoint: "/trending"
		}
	]
