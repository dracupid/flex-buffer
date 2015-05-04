Flex-Buffer
===================
A flexible buffer with a complete but limited Buffer API.
- New data can only be appended.
- Written data and free space is distinguished. Only data part is accessible.
- Buffer size will auto-grow when it is not enough.
- Tested on Node 0.8-0.12, latest iojs on Mac, Linux and Windows.

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
<%= api %>

__All the [native Buffer API](https://iojs.org/api/buffer.html) is wrapped. However, write* methods can only append data, with no `offset` argument.__

## Test
```
npm test
```

## Benchmark
Environment: io.js v1.8.1, OS X 10.10.2, Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
- Write Number
    - Buffer x 2,308,113 ops/sec ±0.71% (94 runs sampled)
    - FlexBuffer x 1,568,507 ops/sec ±1.27% (90 runs sampled)
    - FlexBuffer-8 x 487,534 ops/sec ±0.94% (90 runs sampled)
    - FlexBuffer-16 x 844,856 ops/sec ±1.04% (88 runs sampled)
    - FlexBuffer-32 x 1,102,538 ops/sec ±0.94% (88 runs sampled)

- Write String
    - Buffer x 2,703,146 ops/sec ±1.75% (84 runs sampled)
    - FlexBuffer x 1,834,996 ops/sec ±1.13% (90 runs sampled)
    - FlexBuffer-2 x 1,212,164 ops/sec ±0.98% (88 runs sampled)

- wrapped native API
    - Buffer x 3,065,486 ops/sec ±1.11% (80 runs sampled)
    - FlexBuffer x 2,895,890 ops/sec ±1.15% (90 runs sampled)
    - FlexBuffer-2 x 1,191,723 ops/sec ±0.98% (91 runs sampled)

## License
MIT
