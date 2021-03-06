"use strict"

class FlexBuffer
    ###*
     * Grow factor of the flex buffer. </br>
     * > If the buffer is full, it will be resized to its `origin length * grow factor`. <br/>
     * > A falsey SAFE_BUFFER_LENGTH means unlimited, which may be unsafe. <br/>
     * > If grow factor is 0, the buffer will be resized to its `origin length + input data's length`.
     * @type {number}
     * @prefix FlexBuffer.
    ###
    @SAFE_BUFFER_LENGTH: 10 * 1024 * 1024 # 10M

    ###*
     * If buffer length exceeds this length, it will grow as grow factor is 0.
     * @type {number}
     * @prefix FlexBuffer.
    ###
    @GROW_FACTOR: 2

    ###*
     * Flex Buffer constructor
     * @param  {number | Buffer | Array | string} arg   The same arg as Buffer, number is only initial byte size. Default is 1024.
     * @param  {Object={}} opts             options
     * @option {string='utf8'} encoding          string encoding to use (only for string type)
     * @option {number=2} growFactor             GROW_FACTOR
     * @option {number=10MB} safeBufferLength    SAFE_BUFFER_LENGTH
    ###
    constructor: (arg = 1024, opts = {}) ->
        ###*
         * How many times has the buffer been resized
         * @type {number}
         * @private
        ###
        @_initArg = arg
        @_initOpts = opts
        @_resizeTime = 0

        @_buildBuffer arg, opts

        ###*
         * Grow factor of this flex buffer.
         * @type {number}
        ###
        @GROW_FACTOR = opts.growFactor or FlexBuffer.GROW_FACTOR

        ###*
         * Safe buffer length for this flex buffer.
         * @type {number}
        ###
        @SAFE_BUFFER_LENGTH = opts.safeBufferLength or FlexBuffer.SAFE_BUFFER_LENGTH
        @

    _buildBuffer: (arg, opts = {}) ->
        if typeof arg is 'number'
            @_buffer = new Buffer arg
            @_writeOffset = 0
        else if Buffer.isBuffer arg
            @_buffer = arg
            @_writeOffset = arg.length
        else
            @_buffer = new Buffer arg, opts.encoding
            @_writeOffset = @_buffer.length

    _newBufferSize: (delta) ->
        if not @_buffer.length
            delta
        else if not @SAFE_BUFFER_LENGTH
            newSize = @_buffer.length * @GROW_FACTOR
        else if @_buffer.length < @SAFE_BUFFER_LENGTH and @GROW_FACTOR isnt 0
            newSize = @_buffer.length * @GROW_FACTOR
            if newSize - @_buffer.length > delta
                newSize
            else
                @_buffer.length + delta
        else
            @_writeOffset + delta

    _resize: (delta) ->
        oldBuffer = @_buffer
        # allocate a new buffer
        @_buffer = new Buffer @_newBufferSize delta
        # copy old buffer to a new buffer
        oldBuffer.copy @_buffer, 0
        # release old buffer
        oldBuffer = null
        @_resizeTime += 1

    _resizeIfRequired: (delta) ->
        if @_writeOffset + delta > @_buffer.length
            @_resize(delta)

    _writeByte: (byteNum) ->
        @_buffer[@_writeOffset++] = byteNum

    _writeNumber: (num) ->
        @_resizeIfRequired 1
        @_writeByte num
        1

    _writeBuffer: (buf) ->
        len = buf.length
        @_resizeIfRequired len

        buf.copy @_buffer, @_writeOffset
        @_writeOffset += len
        len

    _writeArray: (arr) ->
        len = arr.length
        @_resizeIfRequired len

        for i in arr
            @_writeByte i
        len

    _writeString: (str, encoding) ->
        len = Buffer.byteLength str, encoding # This is a obvious overhead.
        @_resizeIfRequired len
        @_buffer.write str, @_writeOffset, len, encoding
        @_writeOffset += len
        len

    ###*
     * Write/append a byte | array of bytes | buffer | string to the tail of the buffer
     * @param  {number | string | Array | Buffer}  value     The value to write
     * @param  {string="utf8"}                     encoding  string encoding
     * @return {number}                                      length to write
    ###
    write: (value, encoding) ->
        if typeof value is 'number'
            @_writeNumber value
        else if Buffer.isBuffer value
            @_writeBuffer value
        else if Array.isArray value
            @_writeArray value
        else if typeof value is 'string'
            @_writeString value, encoding
        else
            throw TypeError "Unvalid data type"

    ###*
     * The same as Buffer.slice applied on data part of the buffer, with an additional newBuffer argument.
     * @param  {number = 0}             start       start pos
     * @param  {number = this.length}   end         end pos
     * @param  {boolean=false}          newBuffer   return a new Buffer instance, which doesn't references the same memory as the old.
     * @return {Buffer}                             data buffer
    ###
    slice: (start = 0, end = @length, newBuffer = false) ->
        _buf = @_buffer.slice start, end
        if newBuffer then new Buffer _buf else _buf

    ###*
     * Return data part of the buffer.
     * @param  {boolean=false} newBuffer   return a new Buffer instance.
     * @return {Buffer}              data buffer
    ###
    toBuffer: (newBuffer = false) ->
        @slice null, null, newBuffer

    toString: ->
        @toBuffer().toString()

    inspect: ->
        """
        [FlexBuffer]
            length: #{@length},
            bufferLength: #{@bufferLength}
            _resizeTime: #{@_resizeTime}
            _buffer: #{@_buffer.inspect()}
        """

    ###*
     * Release the buffer and create a buffer using initial state.
     * @param
    ###
    reset: ->
        @_resizeTime = 0
        @release()
        @_buildBuffer @_initArg, @_initOpts

    ###*
     * Release the buffer
     * @param
    ###
    release: ->
        @_buffer = null
        @flush()

    ###*
     * Flush the buffer, clear all data, won't release space.
     * @param
    ###
    flush: ->
        @_writeOffset = 0

Object.defineProperties FlexBuffer::,
    ###*
     * internal buffer's length, including free space.
     * @type {number}
    ###
    'bufferLength':
        get: -> if @_buffer then @_buffer.length else 0
    ###*
     * length of data part
     * @type {number}
    ###
    'length':
        get: -> @_writeOffset

# Extend native Buffer API

_writerBuilder = (len, k, v) ->
    FlexBuffer::[k] = (val) ->
        @_resizeIfRequired len
        v.call @_buffer, val, @_writeOffset, false
        @_writeOffset += len
        len


BufferKeys = Object.keys Buffer::

Object.defineProperties FlexBuffer::,
    'parent':
        enumerable: true
        get: -> @toBuffer(false).parent
    'offset':
        enumerable: true
        get: -> @toBuffer(false).offset

for k in BufferKeys
    if k in ['parent', 'offset']
        continue

    v = Buffer::[k]
    if FlexBuffer::[k]? or typeof v isnt 'function'
        continue

    do (k, v) ->
        if k.indexOf('write') is 0
            arr = k.match /\d+/
            if arr and arr[0]
                _writerBuilder.call @, arr[0] / 8, k, v
            else if /Double/.test k
                _writerBuilder.call @, 8, k, v
            else if /Float/.test k
                _writerBuilder.call @, 4, k, v
            else
                FlexBuffer::[k] = (val, byteLength) ->
                    @_resizeIfRequired byteLength
                    v.call @_buffer, val, @_writeOffset, byteLength, false
                    @_writeOffset += byteLength
                    byteLength
        else
            FlexBuffer::[k] = ->
                dataBuf = @toBuffer false
                v.apply dataBuf, arguments

module.exports = FlexBuffer
