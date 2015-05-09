kit = require 'nokit'
path = require 'path'
Promise = Promise or kit.Promise

Promise.all ['number', 'string', 'native'].map (name) ->
    kit.exec 'coffee ' + path.join __dirname, name + '.coffee'
.then (arr) ->
    arr.forEach ({stdout}) ->
        console.log stdout
.catch console.err
