import React, { Component } from 'react'
import _ from "underscore"

ErrorUl = ({ errors }) ->
	return <ul></ul> unless errors?.length
	<ul>
		{
			_(errors).map (error, index) ->
				<li key="error-#{index}">{ error.message }</li>
		}
	</ul>

export default ErrorUl
