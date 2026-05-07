// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Sequential decode cursor over a ``Bytes`` value.
///
/// `~Copyable` because the cursor's `offset` is positional state; copying
/// would create two cursors that silently diverge. To process the same
/// buffer with two independent cursors, initialize two readers from the
/// same `Bytes` value.
public struct BytesReader: ~Copyable {
    private let bytes: Bytes
    public private(set) var offset: Int

    public init(_ bytes: Bytes) {
        self.bytes = bytes
        self.offset = 0
    }

    public var remaining: Int { bytes.count - offset }
    public var isAtEnd: Bool { offset >= bytes.count }

    // MARK: - Single-byte

    public mutating func readByte() throws(BytesError) -> UInt8 {
        guard offset < bytes.count else { throw .truncated }
        let b: UInt8 = bytes.storage[offset]
        offset += 1
        return b
    }

    public mutating func peekByte() throws(BytesError) -> UInt8 {
        guard offset < bytes.count else { throw .truncated }
        return bytes.storage[offset]
    }

    // MARK: - Fixed-width LE

    public mutating func readUInt16LE() throws(BytesError) -> UInt16 {
        guard offset + 2 <= bytes.count else { throw .truncated }
        let b0: UInt16 = UInt16(bytes.storage[offset])
        let b1: UInt16 = UInt16(bytes.storage[offset + 1])
        offset += 2
        return b0 | (b1 << 8)
    }

    public mutating func readUInt32LE() throws(BytesError) -> UInt32 {
        guard offset + 4 <= bytes.count else { throw .truncated }
        let b0: UInt32 = UInt32(bytes.storage[offset])
        let b1: UInt32 = UInt32(bytes.storage[offset + 1])
        let b2: UInt32 = UInt32(bytes.storage[offset + 2])
        let b3: UInt32 = UInt32(bytes.storage[offset + 3])
        offset += 4
        return b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
    }

    public mutating func readUInt64LE() throws(BytesError) -> UInt64 {
        guard offset + 8 <= bytes.count else { throw .truncated }
        var v: UInt64 = 0
        for i in 0..<8 {
            v |= UInt64(bytes.storage[offset + i]) << (8 * i)
        }
        offset += 8
        return v
    }

    // MARK: - Fixed-width BE

    public mutating func readUInt16BE() throws(BytesError) -> UInt16 {
        guard offset + 2 <= bytes.count else { throw .truncated }
        let b0: UInt16 = UInt16(bytes.storage[offset])
        let b1: UInt16 = UInt16(bytes.storage[offset + 1])
        offset += 2
        return (b0 << 8) | b1
    }

    public mutating func readUInt32BE() throws(BytesError) -> UInt32 {
        guard offset + 4 <= bytes.count else { throw .truncated }
        let b0: UInt32 = UInt32(bytes.storage[offset])
        let b1: UInt32 = UInt32(bytes.storage[offset + 1])
        let b2: UInt32 = UInt32(bytes.storage[offset + 2])
        let b3: UInt32 = UInt32(bytes.storage[offset + 3])
        offset += 4
        return (b0 << 24) | (b1 << 16) | (b2 << 8) | b3
    }

    public mutating func readUInt64BE() throws(BytesError) -> UInt64 {
        guard offset + 8 <= bytes.count else { throw .truncated }
        var v: UInt64 = 0
        for i in 0..<8 {
            v = (v << 8) | UInt64(bytes.storage[offset + i])
        }
        offset += 8
        return v
    }

    // MARK: - Bulk

    public mutating func readBytes(_ n: Int) throws(BytesError) -> Bytes {
        guard n >= 0, offset + n <= bytes.count else { throw .truncated }
        let slice: ContiguousArray<UInt8> = ContiguousArray(bytes.storage[offset..<(offset + n)])
        offset += n
        return Bytes(slice)
    }

    public mutating func skip(_ n: Int) throws(BytesError) {
        guard n >= 0, offset + n <= bytes.count else { throw .truncated }
        offset += n
    }
}
