// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Sequential encode cursor that accumulates bytes into a ``Bytes`` value.
///
/// Use ``finish()`` to consume the writer and obtain the resulting buffer.
/// `finish()` is `consuming`, so a finished buffer cannot be aliased with
/// further writer mutations.
public struct BytesWriter: Sendable {
    public private(set) var bytes: Bytes

    public init(reservingCapacity capacity: Int = 0) {
        self.bytes = Bytes(reservingCapacity: capacity)
    }

    // MARK: - Single-byte

    public mutating func writeByte(_ byte: UInt8) {
        bytes.append(byte)
    }

    // MARK: - Fixed-width LE

    public mutating func writeUInt16LE(_ value: UInt16) {
        bytes.append(UInt8(truncatingIfNeeded: value))
        bytes.append(UInt8(truncatingIfNeeded: value >> 8))
    }

    public mutating func writeUInt32LE(_ value: UInt32) {
        for i in 0..<4 {
            bytes.append(UInt8(truncatingIfNeeded: value >> (8 * i)))
        }
    }

    public mutating func writeUInt64LE(_ value: UInt64) {
        for i in 0..<8 {
            bytes.append(UInt8(truncatingIfNeeded: value >> (8 * i)))
        }
    }

    // MARK: - Fixed-width BE

    public mutating func writeUInt16BE(_ value: UInt16) {
        bytes.append(UInt8(truncatingIfNeeded: value >> 8))
        bytes.append(UInt8(truncatingIfNeeded: value))
    }

    public mutating func writeUInt32BE(_ value: UInt32) {
        for i in (0..<4).reversed() {
            bytes.append(UInt8(truncatingIfNeeded: value >> (8 * i)))
        }
    }

    public mutating func writeUInt64BE(_ value: UInt64) {
        for i in (0..<8).reversed() {
            bytes.append(UInt8(truncatingIfNeeded: value >> (8 * i)))
        }
    }

    // MARK: - Bulk

    public mutating func writeBytes(_ other: Bytes) {
        bytes.append(other)
    }

    public mutating func writeBytes(_ array: [UInt8]) {
        bytes.append(contentsOf: array)
    }

    public mutating func writeBytes(_ sequence: some Sequence<UInt8>) {
        bytes.append(contentsOf: sequence)
    }

    /// Consume the writer and return the accumulated ``Bytes``.
    /// `consuming` so the writer cannot be reused after extracting the buffer.
    public consuming func finish() -> Bytes {
        bytes
    }
}
