console.log "hai Lea!!!"

kusje = (index) ->
	word = if index <= 1 then "kusje" else "kusjes"
	hearts = [0..(index % 80)].map((x, i) -> "❤ ").join("")
	console.log "#{index} #{word} voor Lea #{hearts}"
	setTimeout ->
		kusje ++index
	, 50

kusje(1)
