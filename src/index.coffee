DEFAULT_SAFE_BUFFER_LENGTH = 10 * 1024 * 1024 # 10M
DEFAULT_GROW_FACTOR = 2

class FlexBuffer
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
         * Grow factor of the flex buffer. </br>
         * > If the buffer is full, it will be resized to its `origin length * grow factor` <br/>
         * > If grow factor is 0, the buffer will be resized to its `origin length + input data's length`
         * @type {number}
        ###
        @GROW_FACTOR = opts.growFactor or DEFAULT_GROW_FACTOR
        ###*
         * If buffer length exceeds this length, it will grow as grow factor is 0.
         * @type {number}
        ###
        @SAFE_BUFFER_LENGTH = opts.safeBufferLength or DEFAULT_SAFE_BUFFER_LENGTH
        @

    _buildBuffer: (arg, opts) ->
        if typeof arg is 'number'
            @_buffer = new Buffer arg
            @length = 0
        else if Buffer.isBuffer arg
            @_buffer = arg
            ###*
             * length of data part
             * @type {Number}
            ###
            @length = arg.length
        else
            @_buffer = new Buffer arg, opts.encoding
            @length = @_buffer.length

    _newBufferSize: (delta) ->
        if not @_buffer.length
            delta
        else if @_buffer.length < @SAFE_BUFFER_LENGTH and @GROW_FACTOR isnt 0
            newSize = @_buffer.length * @GROW_FACTOR
            if newSize - @_buffer.length > delta
                newSize
            else
                @_buffer.length + delta
        else
            @length + delta

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
        if @length + delta > @_buffer.length
            @_resize(delta)


    _writeByte: (byteNum) ->
        @_buffer[@length++] = byteNum

    _writeNumber: (num) ->
        @_resizeIfRequired 1
        @_writeByte num
        1

    _writeBuffer: (buf) ->
        len = buf.length
        @_resizeIfRequired len

        buf.copy @_buffer, @length
        @length += len
        len

    _writeArray: (arr) ->
        len = arr.length
        @_resizeIfRequired len

        for i in arr
            @_writeByte i
        len

    _writeString: (str, encoding) ->
        len = Buffer.byteLength str, encoding
        @_resizeIfRequired len
        @_buffer.write str, @length, len, encoding
        @length += len
        len

    ###*
     * Write/append a byte | array of bytes | buffer | string to the block
     * @param  {number | string | Array | Buffer}  value     The value to write
     * @param  {string="utf8"}                     encoding  string encoding
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
    ###
    reset: ->
        @_resizeTime = 0
        @release()
        @_buildBuffer @_initArg, @_initOpts

    ###*
     * release buffer
    ###
    release: ->
        @buffer = null
        @flush()

    ###*
     * Flush the buffer, clean all data, don't release space.
    ###
    flush: ->
        @length = 0

Object.defineProperties FlexBuffer::,
    ###*
     * internal buffer's length, including free space.
     * @type {number}
    ###
    'bufferLength':
        get: -> @_buffer.length
    ###*
     * free space length
     * @type {number}
    ###
    'freeLength':
        get: -> @_buffer.length - @length

# Extend native Buffer API

_writerBuilder = (len, k, v) ->
    FlexBuffer::[k] = (val) ->
        @_resizeIfRequired len
        v.call @_buffer, val, @length, false
        @length += len
        len

for k, v of Buffer::
    if FlexBuffer::[k]? or typeof v isnt 'function'
        continue

    if k.indexOf('write') is 0
        do (k, v) ->
            arr = k.match /\d+/
            if arr and arr[0]
                _writerBuilder.call @, parseInt(arr[0]) / 8, k, v
            else if /Double/.test k
                _writerBuilder.call @, 8, k, v
            else if /Float/.test k
                _writerBuilder.call @, 4, k, v
            else
                FlexBuffer::[k] = (val, byteLength) ->
                    @_resizeIfRequired 6
                    len = v.call @_buffer, val, @length, byteLength, false
                    @length = len
                    len
    else
        do (k, v) ->
            FlexBuffer::[k] = ->
                dataBuf = @toBuffer false
                v.apply dataBuf, arguments

module.exports = FlexBuffer
