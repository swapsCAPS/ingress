import React, { Component }    from 'react'
import _                       from "underscore"
import ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import ReactTransitionGroup from 'react-addons-transition-group'

import globalStyle from "./globalStyle.coffee"
import "./Table.scss"
{ colors } = globalStyle

export default ({ trending, className, setHovered }) ->
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
					_(trending).map ({ name, url, tweet_volume, hovered }, index) ->
						<tr key="table-trending-#{index}">
							<td className="table-td">
								<a
									className="table-link"
									target = "_blank"
									href   = "#{url}"
								>{ name }</a>
							</td>
							<td>{ tweet_volume }</td>
						</tr>

				}
			</tbody>
		</table>
	</div>
