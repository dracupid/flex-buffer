Flex-Buffer
===================
A flexible buffer with a complete but limited Buffer API.
- New data can only be appended.
- Written data and free space is distinguished. Only data part is accessible.
- Buffer size will auto-grow when it is not enough.

[![NPM version](https://badge.fury.io/js/flex-buffer.svg)](https://www.npmjs.com/package/flex-buffer)
[![Deps](https://david-dm.org/dracupid/flex-buffer.svg?style=flat)](https://david-dm.org/dracupid/flex-buffer)
[![Build Status](https://travis-ci.org/dracupid/flex-buffer.svg)](https://travis-ci.org/dracupid/flex-buffer)

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

__All the [native Buffer API](https://iojs.org/api/buffer.html) is preserved. However, write* methods can only append data, with no `offset` argument.__

## Test
```
npm test
```

## License
MIT
