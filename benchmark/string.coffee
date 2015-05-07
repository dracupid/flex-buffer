Benchmark = require 'benchmark'
FB = require '../src'
a = new Buffer 80
b = new FB 80
c = new FB 80

str = '1ad2'
len = Buffer.byteLength str

suite = new Benchmark.Suite()
suite.on 'start', ->
    console.log "\n- Write String"
.add "Buffer", ->
    for i in [1...10]
        a.write '1ad2', len * i
.add "FlexBuffer", ->
    for i in [1...10]
        b.write '1ad2'
    b.flush()
.add "FlexBuffer(ascii)", ->
    for i in [1...10]
        c.write '1ad2', 'ascii'
    c.flush()
.on 'cycle', (e) -> console.log "    - " + e.target
.run 'async': false
