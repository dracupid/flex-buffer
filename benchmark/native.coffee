Benchmark = require 'benchmark'
FB = require '../src'
a = new Buffer 20
b = new FB 20
suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "\n- wrapped native API"
.add "Buffer", ->
    a.writeDoubleLE 10.10, 0
    a.writeInt32LE 19, 8
.add "FlexBuffer", ->
    b.writeDoubleLE 10.10
    b.writeInt32LE 19
    b.flush()
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
