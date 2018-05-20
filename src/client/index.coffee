import React    from 'react'
import ReactDOM from 'react-dom'
import { hot }  from 'react-hot-loader'

import App from './App.coffee'

Root = ->
	<div>
		<App />
	</div>

ReactDOM.render(<Root />, document.getElementById('root'))

export default hot(module)(Root)
