Benchmark = require 'benchmark'
FB = require '../src'
a = new Buffer 150
b = new FB 150
suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "- Write Number"
.add "Buffer", ->
    for i in [1...100]
        a[i] = 10
.add "FlexBuffer", ->
    for i in [1...100]
        b.write 10
    b.flush()
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
