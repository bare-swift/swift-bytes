// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import Bytes

@Suite("BytesError")
struct BytesErrorTests {
    @Test("BytesError is Sendable, Equatable, Error")
    func conformances() {
        let a: BytesError = .truncated
        let b: BytesError = .truncated
        #expect(a == b)
        let _: any Error = a
        let _: any Sendable = a
    }
}
