# swift-bytes

Sendable, Foundation-free byte buffer + cursor types for Swift 6. The canonical byte type for bare-swift binary-format packages.

Defined by [bare-swift RFC-0006](https://github.com/bare-swift/bare-swift/blob/main/rfcs/0006-bytes-buffer-type.md).

Part of the [bare-swift](https://github.com/bare-swift) ecosystem.

## Install

```swift
.package(url: "https://github.com/bare-swift/swift-bytes.git", from: "0.1.0")
```

```swift
.product(name: "Bytes", package: "swift-bytes")
```

## Usage

```swift
import Bytes

// Owned, mutable, value-typed buffer.
var buf: Bytes = [0x01, 0x02, 0x03]
buf.append(0x04)
buf.append(contentsOf: [0x05, 0x06])
print(buf.count)                   // 6

// Encode: BytesWriter is the encode-side cursor.
var writer = BytesWriter(reservingCapacity: 16)
writer.writeUInt32LE(0xDEADBEEF)
writer.writeUInt16BE(0x1234)
writer.writeByte(0x42)
let payload: Bytes = writer.finish()   // consuming — writer is gone

// Decode: BytesReader is a ~Copyable cursor.
var reader = BytesReader(payload)
let dword = try reader.readUInt32LE()  // 0xDEADBEEF
let word  = try reader.readUInt16BE()  // 0x1234
let tail  = try reader.readByte()      // 0x42
```

## Documentation

Full DocC documentation: <https://bare-swift.github.io/swift-bytes/>

## License

Apache 2.0 with LLVM exception. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
