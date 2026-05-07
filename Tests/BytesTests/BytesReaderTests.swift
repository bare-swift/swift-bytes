// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("BytesReader")
struct BytesReaderTests {
    @Test("readByte advances offset and returns the next byte")
    func readByte() throws {
        var r = BytesReader(Bytes([0x10, 0x20, 0x30]))
        // ~Copyable cursors can't be used directly in #expect macro arguments;
        // extract property reads into locals.
        let off0 = r.offset
        #expect(off0 == 0)
        let b0 = try r.readByte()
        #expect(b0 == 0x10)
        let off1 = r.offset
        #expect(off1 == 1)
        let b1 = try r.readByte()
        let b2 = try r.readByte()
        #expect(b1 == 0x20)
        #expect(b2 == 0x30)
        let off3 = r.offset
        let atEnd = r.isAtEnd
        #expect(off3 == 3)
        #expect(atEnd)
    }

    @Test("peekByte returns next byte without advancing")
    func peek() throws {
        var r = BytesReader(Bytes([0xAA, 0xBB]))
        let p0 = try r.peekByte()
        #expect(p0 == 0xAA)
        let off0 = r.offset
        #expect(off0 == 0)
        let b0 = try r.readByte()
        #expect(b0 == 0xAA)
        let p1 = try r.peekByte()
        #expect(p1 == 0xBB)
        let off1 = r.offset
        #expect(off1 == 1)
    }

    @Test("readByte from empty throws .truncated")
    func readByteEmpty() {
        var r = BytesReader(Bytes())
        #expect(throws: BytesError.truncated) {
            try r.readByte()
        }
    }

    @Test("readUInt16LE / readUInt32LE / readUInt64LE")
    func readLE() throws {
        var r = BytesReader(Bytes([
            0x34, 0x12,
            0xEF, 0xCD, 0xAB, 0x89,
            0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE,
        ]))
        let u16 = try r.readUInt16LE()
        let u32 = try r.readUInt32LE()
        let u64 = try r.readUInt64LE()
        #expect(u16 == 0x1234)
        #expect(u32 == 0x89ABCDEF)
        #expect(u64 == 0xFEDCBA9876543210)
    }

    @Test("readUInt16BE / readUInt32BE / readUInt64BE")
    func readBE() throws {
        var r = BytesReader(Bytes([
            0x12, 0x34,
            0x89, 0xAB, 0xCD, 0xEF,
            0xFE, 0xDC, 0xBA, 0x98, 0x76, 0x54, 0x32, 0x10,
        ]))
        let u16 = try r.readUInt16BE()
        let u32 = try r.readUInt32BE()
        let u64 = try r.readUInt64BE()
        #expect(u16 == 0x1234)
        #expect(u32 == 0x89ABCDEF)
        #expect(u64 == 0xFEDCBA9876543210)
    }

    @Test("readUInt32LE on a 3-byte buffer throws .truncated")
    func read32Truncated() {
        var r = BytesReader(Bytes([0x01, 0x02, 0x03]))
        #expect(throws: BytesError.truncated) {
            try r.readUInt32LE()
        }
    }

    @Test("readBytes(_:) returns a sub-buffer and advances offset")
    func readBytesBulk() throws {
        var r = BytesReader(Bytes([0x01, 0x02, 0x03, 0x04, 0x05]))
        let three = try r.readBytes(3)
        #expect(Array(three.storage) == [0x01, 0x02, 0x03])
        let off3 = r.offset
        #expect(off3 == 3)
        let two = try r.readBytes(2)
        #expect(Array(two.storage) == [0x04, 0x05])
    }

    @Test("readBytes(_:) past end throws .truncated")
    func readBytesTruncated() {
        var r = BytesReader(Bytes([0x01, 0x02]))
        #expect(throws: BytesError.truncated) {
            try r.readBytes(3)
        }
    }

    @Test("skip advances offset; over-skip throws")
    func skip() throws {
        var r = BytesReader(Bytes([0x01, 0x02, 0x03]))
        try r.skip(2)
        let off2 = r.offset
        #expect(off2 == 2)
        let last = try r.readByte()
        #expect(last == 0x03)
        var r2 = BytesReader(Bytes([0x01]))
        #expect(throws: BytesError.truncated) {
            try r2.skip(2)
        }
    }

    @Test("remaining and isAtEnd track position")
    func remaining() throws {
        var r = BytesReader(Bytes([0x01, 0x02, 0x03]))
        let rem3 = r.remaining
        let end0 = r.isAtEnd
        #expect(rem3 == 3)
        #expect(!end0)
        _ = try r.readByte()
        let rem2 = r.remaining
        #expect(rem2 == 2)
        _ = try r.readBytes(2)
        let rem0 = r.remaining
        let end1 = r.isAtEnd
        #expect(rem0 == 0)
        #expect(end1)
    }
}
