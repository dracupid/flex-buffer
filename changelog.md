### v0.4.2
- minor opt

### v0.4.1
- fix: wrpper bug

### v0.4.0
- fix: bug

### v0.3.1
- new api: FlexBuffer.SAFE_BUFFER_LENGTH, FlexBuffer.GROW_FACTOR
- fix: a memory release bug

### v0.3.0
- new api: release, reset, flush

### v0.2.0
- Performance optimization, much faster now.
    + Write Number
        + FlexBuffer x 465,957 ops/sec --> 1,568,507 ops/sec
        + FlexBuffer-8 x 279,433 ops/sec --> 487,534 ops/sec
        + FlexBuffer-16 x 372,279 ops/sec --> 844,856 ops/sec
        + FlexBuffer-32 x 410,284 ops/sec --> 1,102,538 ops/sec

    + Write String
        + FlexBuffer x 866,326 ops/sec --> 1,834,996 ops/sec
        + FlexBuffer-2 x 703,650 ops/sec --> 1,212,164 ops/sec

    + wrapped native API
        + FlexBuffer x 2,349,653 ops/sec --> 2,895,890 ops/sec ±1.15%
        + FlexBuffer-2 x 60,840 ops/sec --> 1,191,723 ops/sec ±0.98%
