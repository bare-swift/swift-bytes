// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Sendable, Foundation-free byte buffer.
///
/// Owned, mutable, value-typed. Backed by `ContiguousArray<UInt8>` for
/// allocation-stability and to avoid Apple-platform NSArray bridging.
///
/// Pair with ``BytesReader`` for decode and ``BytesWriter`` for encode.
public struct Bytes: Sendable, Hashable, ExpressibleByArrayLiteral, RandomAccessCollection {
    /// Internal contiguous storage. Public for inspection only; mutate via
    /// the documented operations.
    public internal(set) var storage: ContiguousArray<UInt8>

    public init() {
        self.storage = []
    }

    public init(_ array: [UInt8]) {
        self.storage = ContiguousArray(array)
    }

    public init(_ array: ContiguousArray<UInt8>) {
        self.storage = array
    }

    public init(_ sequence: some Sequence<UInt8>) {
        self.storage = ContiguousArray(sequence)
    }

    public init(repeating byte: UInt8, count: Int) {
        self.storage = ContiguousArray(repeating: byte, count: count)
    }

    public init(reservingCapacity capacity: Int) {
        self.storage = []
        self.storage.reserveCapacity(capacity)
    }

    public init(arrayLiteral elements: UInt8...) {
        self.storage = ContiguousArray(elements)
    }

    // MARK: - RandomAccessCollection

    public var startIndex: Int { storage.startIndex }
    public var endIndex: Int { storage.endIndex }
    public var count: Int { storage.count }
    public var isEmpty: Bool { storage.isEmpty }

    public subscript(index: Int) -> UInt8 {
        get { storage[index] }
        set { storage[index] = newValue }
    }

    /// Range subscript returns a copy of the sub-region as a new ``Bytes``.
    public subscript(range: Range<Int>) -> Bytes {
        Bytes(ContiguousArray(storage[range]))
    }

    // MARK: - Mutation

    public mutating func append(_ byte: UInt8) {
        storage.append(byte)
    }

    public mutating func append(contentsOf bytes: some Sequence<UInt8>) {
        storage.append(contentsOf: bytes)
    }

    public mutating func append(_ other: Bytes) {
        storage.append(contentsOf: other.storage)
    }

    public mutating func reserveCapacity(_ n: Int) {
        storage.reserveCapacity(n)
    }

    public mutating func removeAll(keepingCapacity: Bool = false) {
        storage.removeAll(keepingCapacity: keepingCapacity)
    }

    // MARK: - Borrowing

    public func withUnsafeBufferPointer<R>(
        _ body: (UnsafeBufferPointer<UInt8>) throws -> R
    ) rethrows -> R {
        try storage.withUnsafeBufferPointer(body)
    }

    public mutating func withUnsafeMutableBufferPointer<R>(
        _ body: (inout UnsafeMutableBufferPointer<UInt8>) throws -> R
    ) rethrows -> R {
        try storage.withUnsafeMutableBufferPointer(body)
    }

    // MARK: - Convert

    public var array: [UInt8] {
        Array(storage)
    }

    public func toArray() -> [UInt8] {
        Array(storage)
    }
}
