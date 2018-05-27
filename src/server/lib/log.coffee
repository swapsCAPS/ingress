winston = require "winston"

logger = null

module.exports = ->
	return logger if logger
	logger = new winston.Logger
		transports: [
			new winston.transports.Console
				colorize: true
				level:      "verbose"
		]
	logger
