Benchmark = require 'benchmark'
FB = require '../src'

suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "- Write Number"
.add "Buffer", ->
    a = new Buffer 100
    for i in [1...50]
        a[0] = 10
.add "FlexBuffer", ->
    a = new FB 100
    for i in [1...50]
        a.write 10
.add "FlexBuffer-8", ->
    a = new FB 2
    for i in [1...50]
        a.write 10
.add "FlexBuffer-16", ->
    a = new FB 16
    for i in [1...50]
        a.write 10
.add "FlexBuffer-32", ->
    a = new FB 32
    for i in [1...50]
        a.write 10
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
