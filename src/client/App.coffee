import React, { Component } from 'react'
import _ from "underscore"
import fetch from "isomorphic-fetch"

import ErrorUl from "./ErrorUl.coffee"

class App extends Component
	addError: (error) ->
		console.error "Oops!", error

		@setState ({ errors }) ->
			errors: errors.concat error

		setTimeout =>
			@setState ({errors}) ->
				errors: _(errors).filter (e) -> e isnt error
		, 5000

	constructor: ->
		super()
		@state =
			trending: []
			errors:   []

	componentDidMount: ->
		fetch "/api/v1/trending/1"
			.then (response) ->
				response.json()
			.then (trending) =>
				@setState { trending }
			.catch @addError.bind(@)

			# return <table></table> unless @state.trending?.length
	render: ->
		<div>
			<ErrorUl
				errors = { @state.errors }
			/>
			<table>
				<thead>
					<tr>
						{
							[ "Name", "Amount" ].map (th) ->
								<th key="table-trending-#{th}">{ th }</th>
						}
					</tr>
				</thead>
				<tbody>
					{
						_(@state.trending).map ({ name, url, tweet_volume }, index) ->
							<tr key="table-trending-#{index}">
								<td><a target="_blank" href="#{url}">{ name }</a></td>
								<td>{ tweet_volume }</td>
							</tr>

					}
				</tbody>
			</table>
		</div>

export default App
