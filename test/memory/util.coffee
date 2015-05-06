FB = require '../../src'
FB.SAFE_BUFFER_LENGTH = 100 * 1024 * 1024

memUsageStr = ->
    {rss} = process.memoryUsage()
    (rss / 1024 / 1024).toFixed(2) + 'MB'

module.exports =
    build: (str, fun) ->
        console.log str, memUsageStr()
        a = []
        res = []
        for i in [1...10]
            res.push fun()
            a.push memUsageStr()
        console.log a.join(' ')

    BLOCK: 40 * 1024 * 1024
