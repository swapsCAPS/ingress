import React    from 'react'
import ReactDOM from 'react-dom'
import { hot }  from 'react-hot-loader'

import App from './App.coffee'

import "./index.scss"

Root = ->
	<main>
		<App />
	</main>

ReactDOM.render(<Root />, document.getElementById('root'))

export default hot(module)(Root)
