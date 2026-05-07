// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("Bytes basics")
struct BytesBasicsTests {
    @Test("default init is empty")
    func defaultInit() {
        let b = Bytes()
        #expect(b.count == 0)
        #expect(b.isEmpty)
    }

    @Test("init from [UInt8] preserves content")
    func initFromArray() {
        let b = Bytes([0x01, 0x02, 0x03])
        #expect(b.count == 3)
        #expect(b[0] == 0x01)
        #expect(b[1] == 0x02)
        #expect(b[2] == 0x03)
    }

    @Test("init from ContiguousArray<UInt8>")
    func initFromContiguous() {
        let arr: ContiguousArray<UInt8> = [0x10, 0x20]
        let b = Bytes(arr)
        #expect(b.count == 2)
        #expect(b[0] == 0x10)
        #expect(b[1] == 0x20)
    }

    @Test("init from Sequence<UInt8>")
    func initFromSequence() {
        let b = Bytes(stride(from: UInt8(0), to: UInt8(5), by: 1))
        #expect(b.count == 5)
        #expect(b[4] == 4)
    }

    @Test("init repeating fills with byte")
    func initRepeating() {
        let b = Bytes(repeating: 0xFF, count: 4)
        #expect(b.count == 4)
        for i in 0..<4 { #expect(b[i] == 0xFF) }
    }

    @Test("init reservingCapacity returns empty buffer")
    func initReserving() {
        let b = Bytes(reservingCapacity: 1024)
        #expect(b.count == 0)
        #expect(b.isEmpty)
    }

    @Test("subscript get/set roundtrips")
    func subscriptSet() {
        var b = Bytes([0xAA, 0xBB, 0xCC])
        b[1] = 0xDE
        #expect(b[1] == 0xDE)
    }

    @Test("Bytes is Sendable")
    func sendable() {
        let _: any Sendable = Bytes()
    }
}
