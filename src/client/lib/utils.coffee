import fetch from "isomorphic-fetch"

export getTrending = (woeid) ->
	new Promise (resolve, reject) ->
		throw reject new Error "No woeid passed" unless woeid
		fetch("/api/v1/trending/#{woeid}").then (res) -> res.json()
