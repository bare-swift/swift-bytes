# Test-parity exceptions

Per [RFC-0002](https://github.com/bare-swift/bare-swift/blob/main/rfcs/0002-test-parity-policy.md) (and its 2026-05-07 amendment for inline literals per [RFC-0004](https://github.com/bare-swift/bare-swift/blob/main/rfcs/0004-inline-test-vectors.md)), this file documents how `swift-bytes` validates correctness.

## Source: RFC-0006

`swift-bytes` is the Swift implementation of the API specified in
[RFC-0006](https://github.com/bare-swift/bare-swift/blob/main/rfcs/0006-bytes-buffer-type.md).
There is no upstream Rust crate to track parity against; the spec itself is
the source of truth.

The Swift translation:

- Per-type unit tests cover every method on `Bytes`, `BytesReader`,
  and `BytesWriter`.
- Endianness round-trips (LE / BE) are tested per integer width.
- A round-trip property test (`BytesRoundTripTests.swift`) writes a
  deterministic LCG-driven sequence of mixed-width values through
  `BytesWriter`, then reads them back through `BytesReader` and asserts
  identity.
- Truncation (over-reading) is verified to throw `BytesError.truncated`.

## Out of scope for v0.1 (per RFC-0006)

- Mutable slicing without copy (`MutableSpan`-like API). Defer to v0.2.
- Variable-length integer encoding. Composes with swift-varint.
- UTF-8 view. Use `String(decoding: bytes.storage, as: UTF8.self)`.
- Arena / pooled allocator. Future optimization.
- Endian-generic accessors. Defer.
- `Span<UInt8>` / `RawSpan` bridges. Wait for stdlib stabilization.
- `swift-nio.ByteBuffer` bridges. Caller-side; not built-in.

## Refresh

When RFC-0006 is amended (e.g., to add `Span` bridges in v0.2), update the
test files to cover the new surface. There is no "upstream commit" to track
because the spec is internal.
