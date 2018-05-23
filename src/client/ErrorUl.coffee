import React, { Component } from 'react'
import _ from "underscore"

ErrorUl = ({ errors }) ->
	return <ul></ul> unless errors?.length
	<ul className="list-group">
		{
			_(errors).map (error, index) ->
				<li
					className = "list-group-item list-group-item-danger"
					key       = "error-#{index}"
				>
					<span>{ error.message }</span>
					<span> </span>
					<span>'{ error.meta }'</span>
				</li>
		}
	</ul>

export default ErrorUl
