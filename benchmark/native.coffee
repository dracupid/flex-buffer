Benchmark = require 'benchmark'
FB = require '../src'

suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "\n- wrapped native API"
.add "Buffer", ->
    a = new Buffer 200
    a.writeDoubleLE 10.10, 0
    a.writeInt32LE 19, 8
.add "FlexBuffer", ->
    a = new FB 200
    a.writeDoubleLE 10.10
    a.writeInt32LE 19
.add "FlexBuffer-2", ->
    a = new FB 2
    a.writeDoubleLE 10.10
    a.writeInt32LE 19
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
