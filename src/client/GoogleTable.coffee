import React, { Component } from 'react'
import _ from "underscore"

import "./Table.scss"

createSearchUrl = (title) ->
	base = "https://www.google.com/search?ie=utf-8&oe=utf-8&aq=t&q="
	arr = title.split ", "
	arr = arr.map (t) -> t.replace " ", "+"
	query = arr.join ", "
	"#{base}#{query}"

export default ({ trending, className }) ->
	<div className={className}>
		<h4>Google</h4>
		<table className="table table-sm">
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
							<td className="table-td">
								<a
									className = "table-link"
									target    = "_blank"
									href      = "#{url}"
								>{ t.title }</a>
							</td>
						</tr>

				}
			</tbody>
		</table>
	</div>
