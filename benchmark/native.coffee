Benchmark = require 'benchmark'
FB = require '../src'

suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "\n- Write String"
.add "Buffer", ->
    a = new Buffer 100
    a.write '1ad得', 0
.add "FlexBuffer", ->
    a = new FB 100
    a.write '1ad得'
.add "FlexBuffer-2", ->
    a = new FB 2
    a.write '1ad得'
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
