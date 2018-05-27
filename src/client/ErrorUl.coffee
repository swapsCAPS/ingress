import React, { Component } from 'react'
import _ from "underscore"

import globalStyle from "./globalStyle.coffee"

{ colors } = globalStyle

style =
	component:
		position: "absolute"
		zIndex:   "1000"
		marginLeft: "-15px"

	single:
		cursor:         "pointer"
		height:         "48px"
		background:     colors.cafe.dressRed
		color:          colors.cafe.star
		marginBottom:   "16px"
		borderRadius:   "4px"
		padding:        "0 8px"
		display:        "flex"
		flexDirection:  "column"
		justifyContent: "center"
		boxShadow:      "2px 2px 5px #{colors.cafe.dressRedShade}"
		# TODO box shadow

ErrorUl = ({ errors, removeError }) ->
	return <div></div> unless errors?.length
	<div
		className="container"
		style={ style.component }
	>
		{
			_(errors).map (error, index) ->
				<div
					style = { style.single }
					key       = "error-#{index}"
				>
					<div
						onClick = { -> removeError error }
						style   = { style.inner }
					>
						<span>{ error.message }</span>
						<span> </span>
						<span>'{ error.meta }'</span>
					</div>
				</div>
		}
	</div>

export default ErrorUl
