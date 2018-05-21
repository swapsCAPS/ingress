import { get_twitter_bearer_token } from "./utils"
import config from "config"

test "get twitter bearer token without key and secret", ->
	expect.assertions 1
	get_twitter_bearer_token().catch (error) ->
		expect(error.message).toBe "pass in key and secret plz"

test "get twitter bearer token with key and secret", ->
	expect.assertions 1
	get_twitter_bearer_token config.apis.twitter.key, config.apis.twitter.secret
		.then (result) -> expect(typeof result).toBe "string"


