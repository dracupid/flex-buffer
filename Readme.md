Flex-Buffer
===================
A flexible buffer with a complete but limited Buffer API.
- New data can only be appended.
- Written data and free space is distinguished. Only data part is accessible.
- Buffer size will auto-grow when it is not enough.
- Tested on Node 0.8-0.12, latest iojs on Mac, Linux and Windows.

[![NPM version](https://badge.fury.io/js/flex-buffer.svg)](https://www.npmjs.com/package/flex-buffer)
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


- #### <a href="./src/index.coffee?source#L12" target="_blank"><b>FlexBuffer.SAFE\_BUFFER_LENGTH </b></a>
    Grow factor of the flex buffer. </br>
  > If the buffer is full, it will be resized to its `origin length * grow factor`. <br/>
  > A falsey SAFE_BUFFER_LENGTH means unlimited, which may be unsafe. <br/>
  > If grow factor is 0, the buffer will be resized to its `origin length + input data's length`.

  - **type**:  { _number_ }

- #### <a href="./src/index.coffee?source#L19" target="_blank"><b>FlexBuffer.GROW\_FACTOR </b></a>
    If buffer length exceeds this length, it will grow as grow factor is 0.

  - **type**:  { _number_ }

- #### <a href="./src/index.coffee?source#L29" target="_blank"><b>constructor (arg, opts = {})</b></a>
    Flex Buffer constructor

  - **param**: `arg` { _number | Buffer | Array | string_ }

    The same arg as Buffer, number is only initial byte size. Default is 1024.

  - **param**: `opts` { _Object={}_ }

    options

  - **option**: `encoding` { _string='utf8'_ }

    string encoding to use (only for string type)

  - **option**: `growFactor` { _number=2_ }

    GROW_FACTOR

  - **option**: `safeBufferLength` { _number=10MB_ }

    SAFE_BUFFER_LENGTH

- #### <a href="./src/index.coffee?source#L45" target="_blank"><b>GROW\_FACTOR </b></a>
    Grow factor of this flex buffer.

  - **type**:  { _number_ }

- #### <a href="./src/index.coffee?source#L51" target="_blank"><b>SAFE\_BUFFER_LENGTH </b></a>
    Safe buffer length for this flex buffer.

  - **type**:  { _number_ }

- #### <a href="./src/index.coffee?source#L130" target="_blank"><b>write (value, encoding = "utf8")</b></a>
    Write/append a byte | array of bytes | buffer | string to the tail of the buffer

  - **param**: `value` { _number | string | Array | Buffer_ }

    The value to write

  - **param**: `encoding` { _string="utf8"_ }

    string encoding

  - **return**:  { _number_ }

    length to write

- #### <a href="./src/index.coffee?source#L149" target="_blank"><b>slice (start =  0, end =  this.length, newBuffer = false)</b></a>
    The same as Buffer.slice applied on data part of the buffer, with an additional newBuffer argument.

  - **param**: `start` { _number = 0_ }

    start pos

  - **param**: `end` { _number = this.length_ }

    end pos

  - **param**: `newBuffer` { _boolean=false_ }

    return a new Buffer instance, which doesn't references the same memory as the old.

  - **return**:  { _Buffer_ }

    data buffer

- #### <a href="./src/index.coffee?source#L158" target="_blank"><b>toBuffer (newBuffer = false)</b></a>
    Return data part of the buffer.

  - **param**: `newBuffer` { _boolean=false_ }

    return a new Buffer instance.

  - **return**:  { _Buffer_ }

    data buffer

- #### <a href="./src/index.coffee?source#L177" target="_blank"><b>reset ()</b></a>
    Release the buffer and create a buffer using initial state.

- #### <a href="./src/index.coffee?source#L186" target="_blank"><b>release ()</b></a>
    Release the buffer

- #### <a href="./src/index.coffee?source#L194" target="_blank"><b>flush ()</b></a>
    Flush the buffer, clear all data, won't release space.

- #### <a href="./src/index.coffee?source#L202" target="_blank"><b>bufferLength </b></a>
    internal buffer's length, including free space.

  - **type**:  { _number_ }

- #### <a href="./src/index.coffee?source#L208" target="_blank"><b>length </b></a>
    length of data part

  - **type**:  { _number_ }



__All the [native Buffer API](https://iojs.org/api/buffer.html) is wrapped. However, write* methods can only append data, with no `offset` argument.__

## Test
```
npm test
```

## Benchmark
```
npm run benchmark
```

Environment: , OS X 10.10.4, Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz

**io.js v2.4.0**
- Write Number
    - Buffer x 1,967,194 ops/sec ±0.48% (95 runs sampled)
    - FlexBuffer x 2,608,820 ops/sec ±0.32% (96 runs sampled)


- Write String
    - Buffer x 776,848 ops/sec ±0.64% (93 runs sampled)
    - FlexBuffer x 290,386 ops/sec ±0.54% (92 runs sampled)
    - FlexBuffer(ascii) x 824,243 ops/sec ±1.18% (93 runs sampled)


- wrapped native API
    - Buffer x 19,973,789 ops/sec ±0.59% (94 runs sampled)
    - FlexBuffer x 14,407,768 ops/sec ±0.50% (93 runs sampled)


**io.js v3.0.0**
> Due to changes in V8, io.js has reimplemented Buffer on top of V8's Uint8Array. Thus, Buffer instantiation is measurably slower. Access operations may be faster in some circumstances but the exact performance profile and difference over previous versions will depend on how Buffer is used within applications. See [io.js changelog](https://github.com/nodejs/io.js/blob/master/CHANGELOG.md#2015-08-04-version-300-rvagg) for more info.

- Write Number
    - Buffer x 1,448,511 ops/sec ±0.49% (94 runs sampled)
    - FlexBuffer x 1,137,468 ops/sec ±0.39% (95 runs sampled)


- Write String
    - Buffer x 519,786 ops/sec ±0.56% (95 runs sampled)
    - FlexBuffer x 238,278 ops/sec ±0.77% (90 runs sampled)
    - FlexBuffer(ascii) x 506,659 ops/sec ±1.36% (83 runs sampled)


- wrapped native API
    - Buffer x 10,587,654 ops/sec ±1.06% (94 runs sampled)
    - FlexBuffer x 7,510,308 ops/sec ±0.47% (94 runs sampled)

## License
MIT@Jingchen Zhao
