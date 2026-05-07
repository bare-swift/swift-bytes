// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("Bytes conformances")
struct BytesConformancesTests {
    @Test("Hashable: same contents → equal and hash equal")
    func hashable() {
        let a: Bytes = [0x01, 0x02, 0x03]
        let b = Bytes([0x01, 0x02, 0x03])
        #expect(a == b)
        var s: Set<Bytes> = [a]
        #expect(s.contains(b))
        s.insert(b)
        #expect(s.count == 1)
    }

    @Test("Hashable: different contents → not equal")
    func notEqual() {
        let a: Bytes = [0x01, 0x02, 0x03]
        let b: Bytes = [0x01, 0x02, 0x04]
        #expect(a != b)
    }

    @Test("ExpressibleByArrayLiteral: type-inferred init")
    func arrayLiteral() {
        let b: Bytes = [0xDE, 0xAD, 0xBE, 0xEF]
        #expect(b.count == 4)
        #expect(b[0] == 0xDE)
        #expect(b[3] == 0xEF)
    }

    @Test("RandomAccessCollection: startIndex, endIndex, indices")
    func collection() {
        let b: Bytes = [0x10, 0x20, 0x30]
        #expect(b.startIndex == 0)
        #expect(b.endIndex == 3)
        var collected: [UInt8] = []
        for byte in b { collected.append(byte) }
        #expect(collected == [0x10, 0x20, 0x30])
    }

    @Test("RandomAccessCollection: map / filter / reduce work")
    func collectionAlgorithms() {
        let b: Bytes = [0x01, 0x02, 0x03, 0x04]
        let doubled = b.map { $0 * 2 }
        #expect(doubled == [0x02, 0x04, 0x06, 0x08])
        let sum = b.reduce(0) { $0 + Int($1) }
        #expect(sum == 10)
    }
}
