// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("Bytes round-trip")
struct BytesRoundTripTests {
    @Test("Mixed-width LE writes round-trip via reader")
    func mixedLE() throws {
        var lcg: UInt64 = 0x9E37_79B9_7F4A_7C15
        var w = BytesWriter(reservingCapacity: 1024)
        var values: [(width: Int, value: UInt64)] = []
        for _ in 0..<256 {
            lcg ^= lcg << 13
            lcg ^= lcg >> 7
            lcg ^= lcg << 17
            let widthChoice: Int = Int(lcg & 0x3)
            switch widthChoice {
            case 0:
                let v: UInt8 = UInt8(truncatingIfNeeded: lcg)
                w.writeByte(v)
                values.append((1, UInt64(v)))
            case 1:
                let v: UInt16 = UInt16(truncatingIfNeeded: lcg)
                w.writeUInt16LE(v)
                values.append((2, UInt64(v)))
            case 2:
                let v: UInt32 = UInt32(truncatingIfNeeded: lcg)
                w.writeUInt32LE(v)
                values.append((4, UInt64(v)))
            default:
                w.writeUInt64LE(lcg)
                values.append((8, lcg))
            }
        }
        let payload: Bytes = w.finish()
        var r = BytesReader(payload)
        for (width, expected) in values {
            switch width {
            case 1:
                let got = try r.readByte()
                #expect(UInt64(got) == expected)
            case 2:
                let got = try r.readUInt16LE()
                #expect(UInt64(got) == expected)
            case 4:
                let got = try r.readUInt32LE()
                #expect(UInt64(got) == expected)
            case 8:
                let got = try r.readUInt64LE()
                #expect(got == expected)
            default:
                Issue.record("unexpected width \(width)")
            }
        }
        let atEnd = r.isAtEnd
        #expect(atEnd)
    }

    @Test("Mixed-width BE writes round-trip via reader")
    func mixedBE() throws {
        var lcg: UInt64 = 0xDEAD_BEEF_CAFE_BABE
        var w = BytesWriter()
        w.writeUInt16BE(0xBEEF)
        w.writeUInt32BE(0xDEADBEEF)
        w.writeUInt64BE(0xFEDCBA9876543210)
        for _ in 0..<32 {
            lcg ^= lcg << 13
            lcg ^= lcg >> 7
            lcg ^= lcg << 17
            w.writeByte(UInt8(truncatingIfNeeded: lcg))
        }
        let payload: Bytes = w.finish()
        var r = BytesReader(payload)
        let u16 = try r.readUInt16BE()
        let u32 = try r.readUInt32BE()
        let u64 = try r.readUInt64BE()
        #expect(u16 == 0xBEEF)
        #expect(u32 == 0xDEADBEEF)
        #expect(u64 == 0xFEDCBA9876543210)
        var seedCheck: UInt64 = 0xDEAD_BEEF_CAFE_BABE
        for _ in 0..<32 {
            seedCheck ^= seedCheck << 13
            seedCheck ^= seedCheck >> 7
            seedCheck ^= seedCheck << 17
            let got = try r.readByte()
            #expect(got == UInt8(truncatingIfNeeded: seedCheck))
        }
        let atEnd = r.isAtEnd
        #expect(atEnd)
    }

    @Test("readBytes / writeBytes round-trip arbitrary chunks")
    func bulkRoundTrip() throws {
        var w = BytesWriter()
        let chunkA: Bytes = [0xDE, 0xAD]
        let chunkB: Bytes = [0xBE, 0xEF, 0x42]
        w.writeBytes(chunkA)
        w.writeBytes(chunkB)
        let payload = w.finish()
        var r = BytesReader(payload)
        let firstTwo = try r.readBytes(2)
        let nextThree = try r.readBytes(3)
        #expect(Array(firstTwo.storage) == [0xDE, 0xAD])
        #expect(Array(nextThree.storage) == [0xBE, 0xEF, 0x42])
        let atEnd = r.isAtEnd
        #expect(atEnd)
    }
}
