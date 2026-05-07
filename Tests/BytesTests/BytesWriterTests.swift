// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("BytesWriter")
struct BytesWriterTests {
    @Test("default init produces an empty writer")
    func emptyInit() {
        var w = BytesWriter()
        let result = w.finish()
        #expect(result.isEmpty)
    }

    @Test("reservingCapacity does not change initial count")
    func reservingCapacity() {
        var w = BytesWriter(reservingCapacity: 1024)
        w.writeByte(0xAA)
        let result = w.finish()
        #expect(result.count == 1)
    }

    @Test("writeByte appends single bytes in order")
    func writeByteSeq() {
        var w = BytesWriter()
        w.writeByte(0x01)
        w.writeByte(0x02)
        w.writeByte(0x03)
        #expect(Array(w.finish().storage) == [0x01, 0x02, 0x03])
    }

    @Test("writeUInt16LE / writeUInt32LE / writeUInt64LE produce LE bytes")
    func writeLE() {
        var w = BytesWriter()
        w.writeUInt16LE(0x1234)
        w.writeUInt32LE(0x89ABCDEF)
        w.writeUInt64LE(0xFEDCBA9876543210)
        let expected: [UInt8] = [
            0x34, 0x12,
            0xEF, 0xCD, 0xAB, 0x89,
            0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE,
        ]
        #expect(Array(w.finish().storage) == expected)
    }

    @Test("writeUInt16BE / writeUInt32BE / writeUInt64BE produce BE bytes")
    func writeBE() {
        var w = BytesWriter()
        w.writeUInt16BE(0x1234)
        w.writeUInt32BE(0x89ABCDEF)
        w.writeUInt64BE(0xFEDCBA9876543210)
        let expected: [UInt8] = [
            0x12, 0x34,
            0x89, 0xAB, 0xCD, 0xEF,
            0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10,
        ]
        #expect(Array(w.finish().storage) == expected)
    }

    @Test("writeBytes(_ bytes:) and writeBytes(_ array:) and writeBytes(_ sequence:) all append")
    func writeBulk() {
        var w = BytesWriter()
        let other: Bytes = [0x10, 0x20]
        w.writeBytes(other)
        w.writeBytes([0x30, 0x40] as [UInt8])
        w.writeBytes(stride(from: UInt8(0x50), to: UInt8(0x53), by: 1))
        #expect(Array(w.finish().storage) == [0x10, 0x20, 0x30, 0x40, 0x50, 0x51, 0x52])
    }
}
