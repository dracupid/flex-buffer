FB = require '../../src'
util = require './util'

util.build "no release", ->
    a = new FB util.BLOCK / 256
    for i in [0...util.BLOCK]
        a.write 1
    a
