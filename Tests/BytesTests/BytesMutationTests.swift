// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("Bytes mutation")
struct BytesMutationTests {
    @Test("append(_ byte:) extends by one")
    func appendByte() {
        var b = Bytes()
        b.append(0x01)
        b.append(0x02)
        #expect(b.count == 2)
        #expect(b[0] == 0x01)
        #expect(b[1] == 0x02)
    }

    @Test("append(contentsOf:) extends from sequence")
    func appendSequence() {
        var b = Bytes([0x01])
        b.append(contentsOf: [0x02, 0x03] as [UInt8])
        #expect(b.count == 3)
        #expect(Array(b.storage) == [0x01, 0x02, 0x03])
    }

    @Test("append(_ other:) extends from another Bytes")
    func appendOther() {
        var a = Bytes([0x01, 0x02])
        let b = Bytes([0x03, 0x04])
        a.append(b)
        #expect(Array(a.storage) == [0x01, 0x02, 0x03, 0x04])
    }

    @Test("reserveCapacity does not change count or content")
    func reserve() {
        var b = Bytes([0x01, 0x02])
        b.reserveCapacity(1024)
        #expect(b.count == 2)
        #expect(b[0] == 0x01)
    }

    @Test("removeAll empties the buffer")
    func removeAll() {
        var b = Bytes([0x01, 0x02, 0x03])
        b.removeAll()
        #expect(b.isEmpty)
    }

    @Test("range subscript returns a copied sub-Bytes")
    func rangeSubscript() {
        let b = Bytes([0x01, 0x02, 0x03, 0x04, 0x05])
        let middle = b[1..<4]
        #expect(Array(middle.storage) == [0x02, 0x03, 0x04])
        #expect(b.count == 5)
    }

    @Test("toArray returns a fresh [UInt8]")
    func toArray() {
        let b = Bytes([0x10, 0x20, 0x30])
        let arr: [UInt8] = b.toArray()
        #expect(arr == [0x10, 0x20, 0x30])
    }

    @Test("array property returns [UInt8] (alias of toArray)")
    func arrayProperty() {
        let b = Bytes([0xAA, 0xBB])
        let arr: [UInt8] = b.array
        #expect(arr == [0xAA, 0xBB])
    }
}
