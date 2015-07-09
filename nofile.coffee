kit = require 'nokit'
_ = kit._
$ = require('dracupid-no')(kit)

module.exports = (task) ->
    task 'build', "Build Project", (opts) ->
        $.coffee disable: 'missing_fat_arrows'
        .then ->
            kit.remove 'dist/Readme.tpl'

    task 'doc', ->
        nodoc = require 'nodoc'
        kit.Promise.all [nodoc.generate('./src/index.coffee', moduleName: ''), kit.readFile('./src/Readme.tpl', encoding: 'utf8')]
        .then ([api, tpl]) ->
            _.template(tpl) {api}
        .then (md)->
            kit.writeFile 'Readme.md', md

    task 'test', ->
        $.mocha()

    task 'memory', ->
        kit.spawn 'coffee', ['./test/memory.coffee']
        .catch (e) ->
            console.error e
            process.exit 1

    task 'benchmark', ->
        kit.spawn 'coffee', ['./benchmark/benchmark.coffee']
        .catch ->
            process.exit 1

    task 'default', ['build', 'doc']
