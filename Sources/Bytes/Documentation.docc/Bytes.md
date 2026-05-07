# ``Bytes``

Sendable, Foundation-free byte buffer + cursor types for Swift 6.

## Overview

`swift-bytes` ships three types:

- ``Bytes`` — owned, mutable, value-typed byte buffer.
- ``BytesReader`` — non-copyable sequential decode cursor.
- ``BytesWriter`` — sequential encode cursor whose `finish()` is `consuming`.

Together they're the canonical byte-IO seam for bare-swift binary-format
packages. Conversions to and from `[UInt8]` are first-class; conversions
to `Span<UInt8>` / `swift-nio.ByteBuffer` are caller-side bridges (not
built-in).

```swift
import Bytes

var w = BytesWriter(reservingCapacity: 16)
w.writeUInt32LE(0xDEADBEEF)
w.writeUInt16BE(0x1234)
let payload: Bytes = w.finish()

var r = BytesReader(payload)
let dword = try r.readUInt32LE()    // 0xDEADBEEF
let word  = try r.readUInt16BE()    // 0x1234
```

## Topics

### Buffer

- ``Bytes``

### Cursors

- ``BytesReader``
- ``BytesWriter``

### Errors

- ``BytesError``
