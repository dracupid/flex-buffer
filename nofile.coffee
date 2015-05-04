kit = require 'nokit'
_ = kit._
drives = kit.require 'drives'

module.exports = (task) ->
    task 'build', "Build Project", (opts) ->
        kit.warp 'src/*.coffee'
        .load drives.reader isCache: false
        .load drives.coffeelint config: 'coffeelint-strict.json'
        .load drives.coffee()
        .run 'dist'
        .catch (e) ->

    task 'doc', ->
        nodoc = require 'nodoc'
        data = {}

        kit.Promise.all [nodoc.generate('./src/index.coffee', moduleName: ''), kit.readFile('./src/Readme.tpl', encoding: 'utf8')]
        .then ([api, tpl]) ->
            _.template(tpl) {api}
        .then (md)->
            kit.writeFile 'Readme.md', md

    task 'test', ->
        kit.spawn 'mocha', ['-r', 'coffee-script/register', 'test/index.coffee']
        .catch ->
            process.exit 1

    task 'benchmark', ->
        kit.spawn 'coffee', ['./benchmark/benchmark.coffee']
        .catch ->
            process.exit 1

    task 'default', ['build', 'doc']
