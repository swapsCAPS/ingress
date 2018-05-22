import React, { Component } from 'react'
import _ from "underscore"

createSearchUrl = (title) ->

	base = "https://www.google.com/search?ie=utf-8&oe=utf-8&aq=t&q="
	arr = title.split ", "
	arr = arr.map (t) -> t.replace " ", "+"
	query = arr.join ", "
	"#{base}#{query}"

export default ({ trending }) ->
	<div>
		Google
		<table>
			<thead>
				<tr>
					{
						[ "Name" ].map (th) ->
							<th key="table-trending-#{th}">{ th }</th>
					}
				</tr>
					</thead>
			<tbody>
				{
					_(trending).map (t, index) ->
						url = createSearchUrl t.title
						<tr key="table-google-trending-#{index}">
							<td><a target="_blank" href="#{url}">{ t.title }</a></td>
						</tr>

				}
			</tbody>
		</table>
	</div>

# https://www.google.com/search?q=Primary+election%2C+Voter+turnout%2C+Voting%2C+Georgia&ie=utf-8&oe=utf-8&aq=t
