Flex-Buffer
===================
A flexible buffer with a complete but limited Buffer API.
- New data can only be appended.
- Written data and free space is distinguished. Only data part is accessible.
- Buffer size will auto-grow when it is not enough.

[![NPM version](https://badge.fury.io/js/flex-buffer.svg)](https://www.npmjs.com/package/flex-buffer)
[![Deps](https://david-dm.org/dracupid/flex-buffer.svg?style=flat)](https://david-dm.org/dracupid/flex-buffer)
[![Build Status](https://travis-ci.org/dracupid/flex-buffer.svg)](https://travis-ci.org/dracupid/flex-buffer)
[![Build status](https://ci.appveyor.com/api/projects/status/github/dracupid/flex-buffer?svg=true)](https://ci.appveyor.com/project/dracupid/flex-buffer)


## Quick Start
```
npm install flex-buffer -S
```
then
```javascript
FlexBuffer = require("flex-buffer");

fBuf = new FlexBuffer(4);
fBuf.write([1, 2, 3]);
fBuf.write("hello world");
fBuf.writeUInt32LE(165);
```

## API


- #### <a href="./src/index.coffee?source#L15" target="_blank"><b>constructor(arg, opts = {})</b></a>
  Flex Buffer constructor

  - **<u>param</u>**: `arg` { _number | Buffer | Array | string_ }

    The same arg as Buffer, number is only initial byte size. Default is 1024.

  - **<u>param</u>**: `opts` { _Object={}_ }

    options

  - **<u>option</u>**: `encoding` { _string='utf8'_ }

    string encoding to use (only for string type)

  - **<u>option</u>**: `growFactor` { _number=2_ }

    GROW_FACTOR

  - **<u>option</u>**: `safeBufferLength` { _number=10MB_ }

    SAFE_BUFFER_LENGTH

- #### <a href="./src/index.coffee?source#L28" target="_blank"><b>length</b></a>
  length of data part

  - **<u>type</u>**: { _Number_ }

- #### <a href="./src/index.coffee?source#L42" target="_blank"><b>GROW\_FACTOR</b></a>
  Grow factor of the flex buffer. </br>
  > If the buffer is full, it will be resized to its `origin length * grow factor` <br/>
  > If grow factor is 0, the buffer will be resized to its `origin length + input data's length`

  - **<u>type</u>**: { _number_ }

- #### <a href="./src/index.coffee?source#L47" target="_blank"><b>SAFE\_BUFFER_LENGTH</b></a>
  If buffer length exceeds this length, it will grow as grow factor is 0.

  - **<u>type</u>**: { _number_ }

- #### <a href="./src/index.coffee?source#L85" target="_blank"><b>write(value)</b></a>
  Write/append a byte | array of bytes | buffer | string to the block

  - **<u>param</u>**: `value` { _number | string | Array | Buffer_ }

    The value to write

- #### <a href="./src/index.coffee?source#L118" target="_blank"><b>slice(start =  0, end =  this.length, newBuffer = false)</b></a>
  The same as Buffer.slice applied on data part of the buffer, with an additional newBuffer argument.

  - **<u>param</u>**: `start` { _number = 0_ }

    start pos

  - **<u>param</u>**: `end` { _number = this.length_ }

    end pos

  - **<u>param</u>**: `newBuffer` { _boolean=false_ }

    return a new Buffer instance, which doesn't references the same memory as the old.

  - **<u>return</u>**: { _Buffer_ }

    data buffer

- #### <a href="./src/index.coffee?source#L127" target="_blank"><b>toBuffer(newBuffer = false)</b></a>
  Return data part of the buffer.

  - **<u>param</u>**: `newBuffer` { _boolean=false_ }

    return a new Buffer instance.

  - **<u>return</u>**: { _Buffer_ }

    data buffer

- #### <a href="./src/index.coffee?source#L147" target="_blank"><b>bufferLength</b></a>
  internal buffer's length, including free space.

  - **<u>type</u>**: { _number_ }

- #### <a href="./src/index.coffee?source#L153" target="_blank"><b>freeLength</b></a>
  free space length

  - **<u>type</u>**: { _number_ }



__All the [native Buffer API](https://iojs.org/api/buffer.html) is preserved. However, write* methods can only append data, with no `offset` argument.__

## Test
```
npm test
```

## License
MIT
