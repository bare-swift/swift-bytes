# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-05-07

### Added
- `Bytes` value type — Sendable, Hashable, ExpressibleByArrayLiteral, RandomAccessCollection. Owned `ContiguousArray<UInt8>` storage. Inits from `[UInt8]`, `ContiguousArray<UInt8>`, `some Sequence<UInt8>`, repeating, reservingCapacity. Subscript by `Int` (mutable) and `Range<Int>` (copy-out).
- Mutation: `append(_:)` (byte / sequence / Bytes), `reserveCapacity(_:)`, `removeAll(keepingCapacity:)`.
- Pointer access: `withUnsafeBufferPointer(_:)`, `withUnsafeMutableBufferPointer(_:)`.
- Conversion: `array`, `toArray()`.
- `BytesReader` — `~Copyable` decode cursor. `readByte`, `peekByte`, `readUInt{16,32,64}{LE,BE}`, `readBytes(_:)`, `skip(_:)`, `offset`, `remaining`, `isAtEnd`.
- `BytesWriter` — encode cursor with `consuming finish() -> Bytes`. `writeByte`, `writeUInt{16,32,64}{LE,BE}`, `writeBytes(_:)` for `Bytes` / `[UInt8]` / `Sequence<UInt8>`.
- `BytesError` — typed error enum with single case `.truncated`.
- DocC documentation, full README example, NOTICE referencing RFC-0006.

### Limitations (out of scope for v0.1)
- Mutable slicing without copy (waits on stdlib `MutableSpan`).
- Variable-length integer encoding (composes with swift-varint).
- UTF-8 view (use `String(decoding: bytes.storage, as: UTF8.self)`).
- Arena / pooled allocator.
- Endian-generic accessors (`readInteger<T>(as:endian:)`).
- `Span<UInt8>` / `RawSpan` bridges (waits on stdlib stabilization).
- `swift-nio.ByteBuffer` bridges (caller-side; not built-in).
