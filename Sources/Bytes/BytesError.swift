// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Errors thrown by ``BytesReader``.
public enum BytesError: Error, Equatable, Sendable {
    /// A read advanced past the end of the buffer.
    case truncated
}
