import React, { Component }               from 'react'

class App extends Component

	constructor: ->
		super()
		console.log "constructed"


	componentDidMount: ->
		console.log "mounted"

	render: ->
		<div>Haha!</div>

export default App
