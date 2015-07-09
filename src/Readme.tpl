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
<%= api %>

__All the [native Buffer API](https://iojs.org/api/buffer.html) is wrapped. However, write* methods can only append data, with no `offset` argument.__

## Test
```
npm test
```

## Benchmark
```
npm run benchmark
```

Environment: io.js v2.3,3, OS X 10.10.4, Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz

- Write Number
    - Buffer x 1,960,975 ops/sec ±0.34% (96 runs sampled)
    - FlexBuffer x 2,708,359 ops/sec ±0.11% (92 runs sampled)


- Write String
    - Buffer x 779,358 ops/sec ±0.36% (94 runs sampled)
    - FlexBuffer x 294,180 ops/sec ±0.46% (96 runs sampled)
    - FlexBuffer(ascii) x 844,705 ops/sec ±0.65% (94 runs sampled)


- wrapped native API
    - Buffer x 20,544,389 ops/sec ±0.24% (96 runs sampled)
    - FlexBuffer x 13,983,617 ops/sec ±0.48% (95 runs sampled)

## License
MIT@Jingchen Zhao
