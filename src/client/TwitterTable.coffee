import React, { Component } from 'react'
import _ from "underscore"

export default ({ trending }) ->
	<div>
		Twitter
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
					_(trending).map ({ name, url, tweet_volume }, index) ->
						<tr key="table-trending-#{index}">
							<td><a target="_blank" href="#{url}">{ name }</a></td>
							<td>{ tweet_volume }</td>
						</tr>

				}
			</tbody>
		</table>
	</div>
