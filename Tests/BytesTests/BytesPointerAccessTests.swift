// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("Bytes pointer access")
struct BytesPointerAccessTests {
    @Test("withUnsafeBufferPointer reads underlying contiguous bytes")
    func unsafeRead() {
        let b: Bytes = [0xAA, 0xBB, 0xCC]
        let sum: Int = b.withUnsafeBufferPointer { buf in
            var s = 0
            for byte in buf { s += Int(byte) }
            return s
        }
        #expect(sum == 0xAA + 0xBB + 0xCC)
    }

    @Test("withUnsafeMutableBufferPointer can mutate in place")
    func unsafeMutate() {
        var b: Bytes = [0x00, 0x00, 0x00]
        b.withUnsafeMutableBufferPointer { buf in
            for i in 0..<buf.count { buf[i] = UInt8(i + 1) }
        }
        #expect(Array(b.storage) == [0x01, 0x02, 0x03])
    }
}
