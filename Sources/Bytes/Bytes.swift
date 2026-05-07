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
    public internal(set) var storage: ContiguousArray<UInt8> = []

    public init() {}
}
