FB = require '../src'
assert = require 'assert'
util = require 'util'

eq = assert.strictEqual
deq = assert.deepStrictEqual or assert.deepEqual

testBuf = new Buffer 1

describe "create FlexBuffer", ->
    it "from no size", ->
        buf = new FB()
        eq buf.length, 0
        eq buf.bufferLength, 1024

        buf = new FB 0
        eq buf.length, 0
        eq buf.bufferLength, 0

    it "from negative size", ->
        buf = new FB -1
        eq buf.length, 0
        eq buf.bufferLength, 0

    it "from negative size", ->
        buf = new FB 10
        eq buf.length, 0
        eq buf.bufferLength, 10

    it "from Array", ->
        buf = new FB []
        buf1 = new FB [1, 2, 3]
        eq buf.length, 0
        eq buf.bufferLength, 0
        eq buf1.length, 3
        eq buf1.bufferLength, 3

    it "from string", ->
        buf = new FB ""
        buf1 = new FB "ABD"
        eq buf.length, 0
        eq buf.bufferLength, 0
        eq buf1.length, 3
        eq buf1.bufferLength, 3

    it "from Buffer", ->
        buf = new FB new Buffer(0)
        buf1 = new FB new Buffer(3)
        eq buf.length, 0
        eq buf.bufferLength, 0
        eq buf1.length, 3
        eq buf1.bufferLength, 3

describe "write data", ->
    it "write byte/number", ->
        buf = new FB 0
        buf.write 1
        buf.write 100
        buf.write 0x5F
        buf.write 0x5F
        buf.write 0x5F
        eq 1, buf.write 0x5F

        eq buf.length, 6
        eq buf.bufferLength, 8
        eq buf._resizeTime, 4
        eq buf.toBuffer()[3], 0x5F

    it "write string", ->
        buf = new FB 3
        buf.write "sdf"
        buf.write "9oikj"
        eq 6, buf.write "算法"
        buf.write "12345678901234567890"
        eq 4, buf.write "sdaf"

        eq buf.length, 38
        eq buf.bufferLength, 72
        eq buf._resizeTime, 4
        eq buf.toBuffer()[3], 0x39

    it "write array", ->
        buf = new FB 8
        buf.write [1...8]
        eq 4, buf.write [5...9]
        buf.write [10...100]

        eq buf.length, 101
        eq buf.bufferLength, 106
        eq buf._resizeTime, 2
        eq buf.toBuffer()[3], 4

    it "write buffer", ->
        buf = new FB 8
        buf.write new Buffer [1...8]
        eq 4, buf.write new Buffer [5...9]
        buf.write new Buffer [10...100]

        eq buf.length, 101
        eq buf.bufferLength, 106
        eq buf._resizeTime, 2
        eq buf.toBuffer()[3], 4

describe "convert", ->
    it '#slice', ->
        buf = new FB [1, 2, 3]
        eq buf.slice(0, 1)[0], 1
        eq buf.slice(1, 2)[0], 2
        deq buf.slice(0, 2), new Buffer [1, 2]

    it '#toBuffer', ->
        buf = new FB [1, 2, 3]
        deq buf.toBuffer(), new Buffer [1, 2, 3]

    it '#toString', ->
        buf = new FB "ABD"
        eq buf.toString(), "ABD"

describe "gc", ->
    it "reset", ->
        buf = new FB 10
        buf.write [1..10]
        buf.write "sadasd"
        buf.write 3
        eq buf.length, 17
        buf.reset()
        eq buf.bufferLength, 10
        eq buf.length, 0
        eq buf._resizeTime, 0
    it "release", ->
        buf = new FB 10
        buf.write [1..10]
        buf.write "sadasd"
        buf.write 3
        eq buf.length, 17
        buf.release()
        eq buf.bufferLength, 20
        eq buf.length, 0
        eq buf._resizeTime, 1
    it "flush", ->
        buf = new FB 10
        buf.write [1..10]
        buf.write "sadasd"
        buf.write 3
        eq buf.length, 17
        buf.flush()
        eq buf.bufferLength, 20
        eq buf.length, 0
        eq buf._resizeTime, 1


describe "extended Buffer util API", ->
    if testBuf.equals
        it '#equals', ->
            buf = new FB "asdsd"
            assert buf.equals new Buffer "asdsd"
    if testBuf.indexOf
        it '#indexOf', ->
            buf = new FB "asdsd"
            eq 2, buf.indexOf 'd'

describe "extended Buffer write API", ->
    it '#writeInt32LE', ->
        buf = new FB 1
        buf.writeInt32LE 1357
        eq buf.length, 4
        eq buf._resizeTime, 1

    if testBuf.equals
        it '#writeUIntLE', ->
            buf = new FB 10
            buf.writeUIntLE 1357, 3
            eq 0, buf._resizeTime
            eq 3, buf.length

    it '#write in sequence', ->
        buf = new FB 8
        eq 2, buf.writeInt16LE 123
        eq 4, buf.writeFloatLE 123
        eq 8, buf.writeDoubleBE 21343.4123

        eq 14, buf.length
        eq 1, buf._resizeTime
