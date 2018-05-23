import React, { Component } from 'react'
import _ from "underscore"

style =
	td: maxWidth: "170px"
	a:
		display:      "inline-block"
		textOverflow: "ellipsis"
		maxWidth:      "100%"
		whiteSpace:   "nowrap"
		overflow:     "hidden"

export default ({ trending, className }) ->
	<div className={className}>
		<h4>Twitter</h4>
		<table className="table table-sm">
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
							<td style={ style.td }>
								<a style={ style.a } target="_blank" href="#{url}">{ name }</a>
							</td>
							<td>{ tweet_volume }</td>
						</tr>

				}
			</tbody>
		</table>
	</div>
