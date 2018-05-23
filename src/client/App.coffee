import React, { Component } from 'react'
import _ from "underscore"
import fetch from "isomorphic-fetch"

import ErrorUl from "./ErrorUl.coffee"
import TwitterTable from "./TwitterTable.coffee"
import GoogleTable from "./GoogleTable.coffee"

class App extends Component
	addError: (error) ->
		@setState ({ errors }) ->
			errors: errors.concat error

		setTimeout =>
			@setState ({errors}) ->
				errors: _(errors).filter (e) -> e isnt error
		, 30000

	constructor: ->
		super()
		@state =
			trending:
				google:  []
				twitter: []
			errors: []
			woeids: []
			selectedWoeid: null

	fetchTrending: (path) ->
		type = path.split("/")[0]

		new Promise (resolve) =>
			throw new Error "Could not get type from path: '#{path}'" unless type
			resolve()

		.then ->
			fetch "/api/v1/trending/#{path}"

		.then (response) =>
			if response.status >= 400
				return response.json().then (error) =>
					error.meta = path
					@addError error

			response.json()

		.then (response) =>
			@setState ({ trending }) ->
				trending: _.extend {}, trending, [type]: response

		.catch (error) =>
			error.meta = path
			@addError error

	componentDidMount: ->
		@fetchTrending "google/US"
		@fetchTrending "twitter/1"

		fetch "/api/v1/woeids"
			.then (response) ->
				response.json()
			.then (woeids) =>
				@setState { woeids }
			.catch @addError.bind @

	onCountryClick: (countryCode, id) ->
		Promise.all [
			@fetchTrending "google/#{countryCode}"
			@fetchTrending "twitter/#{id}"
		]
		.then =>
			@setState ({ woeids }) ->
				woeids: _(woeids).map (woeid) ->
					woeid.isSelected = woeid.woeid is id
					woeid

	render: ->
		<div className="container">
			<div className="row">
				{
					_(@state.woeids).map ({ name, countryCode, woeid, isSelected }, i) =>
						style =
							cursor: "pointer"
							color:  "333"
						style.color = "lightBlue" if isSelected
						<span
							style   = { style }
							title   = "#{woeid} #{countryCode}"
							key     = "#{woeid}#{isSelected}"
							onClick = {
								=>
									return if isSelected
									@onCountryClick countryCode, woeid
							}
						>
							<span>{ name }</span>
							<span> </span>
						</span>
				}
			</div>
			<ErrorUl
				className = "row"
				errors = { @state.errors }
			/>
			<div className="row">
				<TwitterTable
					className = "col-sm-4"
					trending = { @state.trending.twitter }
				/>
				<GoogleTable
					className = "col-sm-8"
					trending  = { @state.trending.google }
				/>
			</div>
		</div>

export default App
