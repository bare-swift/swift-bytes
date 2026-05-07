// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Sendable, Foundation-free byte buffer.
///
/// Owned, mutable, value-typed. Backed by `ContiguousArray<UInt8>` for
/// allocation-stability and to avoid Apple-platform NSArray bridging.
///
/// Pair with ``BytesReader`` for decode and ``BytesWriter`` for encode.
public struct Bytes: Sendable {
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

    public var count: Int { storage.count }
    public var isEmpty: Bool { storage.isEmpty }

    public subscript(index: Int) -> UInt8 {
        get { storage[index] }
        set { storage[index] = newValue }
    }
}
