import { getTrending } from "./utils"

test "getTrending caught without woeid", ->
	expect.assertions 1
	getTrending().catch (error) ->
		expect(error.message).toBe "No woeid passed"

