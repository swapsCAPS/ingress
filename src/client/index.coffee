import React    from 'react'
import ReactDOM from 'react-dom'
import { hot }  from 'react-hot-loader'

import App from './App.coffee'

import "./index.scss"
import globalStyle from "./globalStyle.coffee"

Root = ->
	<div>
		<main>
			<App />
		</main>
	</div>

ReactDOM.render(<Root />, document.getElementById('root'))

export default hot(module)(Root)
