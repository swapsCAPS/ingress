import React, { Component } from 'react'
import _                    from "underscore"
import fetch                from "isomorphic-fetch"
import Select               from "react-select"
import ErrorUl              from "./ErrorUl.coffee"
import TwitterTable         from "./TwitterTable.coffee"
import GoogleTable          from "./GoogleTable.coffee"

import "./Select.scss"

# TODO
# - Fix google language
# - Fix google title
# - Get google trend amounts
# - Save to db (time series like...)
# - more apis. youtube? facebook? reddit? (crawling)
# - get available countries from google and cross check?
# - styling (dropdown?)
# - debounce
# - Ensure server does not make too many calls
# - more things

class App extends Component
	constructor: ->
		super()
		@ownState = {}
		@state =
			trending:
				google:  []
				twitter: []
			# errors: [ { message: "yolo!" }, {message: "sjit maaaaaaaaaaan!"} ]
			errors: []
			woeids: {}
			selectedCountry: null
			selectedTown:    null



		@throttledGetAllTrends = _.debounce @getAllTrends, 2500


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
			response = _(response).map (r) -> _.extend {}, r, hovered: false
			@setState ({ trending }) ->
				trending: _.extend {}, trending, [type]: response

		.catch (error) =>
			error.meta = path
			@addError error

	setHovered: (state, type, index) ->
		console.log "arguments", arguments
		@setState ({ trending }) ->
			trending[type][index].hovered = state
			{ trending }

	componentDidMount: ->
		@fetchTrending "google/US"
		@fetchTrending "twitter/1"

		fetch "/api/v1/woeids"
			.then (response) ->
				response.json()
			.then (groupedWoeids) =>
				@ownState.groupedWoeids = groupedWoeids
			.catch @addError.bind @

	onCountrySelect: (e) ->
		console.log('e', e)
		console.log _(@ownState.groupedWoeids[e.label]).find name: e.label
		towns = @ownState.groupedWoeids[e.label]
		@setState
			selectedCountry: e.label
			towns:           towns
			selectedTown:    _(towns).find name: e.label
		, @throttledGetAllTrends.bind @

	onTownSelect: (e) ->
		towns        = @ownState.groupedWoeids[@state.selectedCountry]
		console.log "towns", towns
		selectedTown = _(towns).find woeid: e.value
		console.log "selectedTown", selectedTown
		@setState { selectedTown }, @throttledGetAllTrends.bind @

	getAllTrends: ->
		{ countryCode, woeid } = @state.selectedTown
		console.log "Getting all trends for", @state.selectedTown
		Promise.all [
			@fetchTrending "google/#{countryCode}"
			@fetchTrending "twitter/#{woeid}"
		]

	addError: (error) ->
		return
		@setState ({ errors }) ->
			errors: errors.concat error

		setTimeout =>
			@removeError error
		, 30000

	removeError: (error) ->
		@setState ({errors}) ->
			errors: _(errors).filter (e) -> e isnt error

	render: ->
		countries = _(@ownState.groupedWoeids).keys().sort()
		<div
			className = "container"
		>
			<ErrorUl
				errors      = { @state.errors }
				removeError = { @removeError.bind @ }
			/>
			<div
				className="row mt-5"
			>
				<div className="col-4">
					<Select
						placeholder = "Countries"
						onChange    = { @onCountrySelect.bind @ }
						value       = { @state.selectedCountry }
						options     = { countries.map (c) -> { value: c, label: c } }

					/>
				</div>
				<div className="col-8">
					<Select
						placeholder = "Zoom in"
						onChange    = { @onTownSelect.bind @ }
						value       = { @state.selectedTown?.woeid }
						options     = { @state.towns?.map (c) -> value: c.woeid, label: c.name }

					/>
				</div>
			</div>
			<div className="row mt-5">
				<TwitterTable
					className  = "col-sm-4"
					trending   = { @state.trending.twitter }
					setHovered = { @setHovered.bind @ }
				/>
				<GoogleTable
					className = "col-sm-8"
					trending  = { @state.trending.google }
				/>
			</div>
		</div>

export default App
