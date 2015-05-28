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

Environment: io.js v2.0.0, OS X 10.10.2, Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz

- Write Number
    - Buffer x 1,926,430 ops/sec ±0.77% (94 runs sampled)
    - FlexBuffer x 2,644,722 ops/sec ±0.63% (93 runs sampled)

- Write String
    - Buffer x 795,720 ops/sec ±0.78% (92 runs sampled)
    - FlexBuffer x 445,640 ops/sec ±0.90% (94 runs sampled)
    - FlexBuffer(ascii) x 822,147 ops/sec ±1.42% (86 runs sampled)

- wrapped native API
    - Buffer x 23,160,784 ops/sec ±0.94% (92 runs sampled)
    - FlexBuffer x 15,903,934 ops/sec ±1.10% (92 runs sampled)

## License
MIT
