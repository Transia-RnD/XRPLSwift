/*
 * Original code based on "backo" - https://github.com/segmentio/backo
 * MIT License - Copyright 2014 Segment.io
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 * is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// https://github.com/XRPLF/xrpl.js/blob/main/packages/xrpl/src/client/ExponentialBackoff.ts

import Foundation

struct ExponentialBackoffOptions {
    // The min backoff duration.
    var min: Int?
    // The max backoff duration.
    var max: Int?
}

// swiftlint:disable:next identifier_name
let DEFAULT_MIN = 100
// swiftlint:disable:next identifier_name
let DEFAULT_MAX = 1000

/**
 * A Back off strategy that increases exponentially. Useful with repeated
 * setTimeout calls over a network (where the destination may be down).
 */
class ExponentialBackoff {
    private var ms: Int
    private var max: Int
    private var factor: Int = 2
    private var numAttempts: Int = 0

    /**
     Constructs an ExponentialBackoff object.
     - parameters:
     - opts - The options for the object.
     */
    init(opts: ExponentialBackoffOptions? = nil) {
        self.ms = opts?.min ?? DEFAULT_MIN
        self.max = opts?.max ?? DEFAULT_MAX
    }

    /**
     * Number of attempts for backoff so far.
     *
     * @returns Number of attempts.
     */
    public func attempts() -> Int {
        return self.numAttempts
    }

    /**
     * Return the backoff duration.
     *
     * @returns The backoff duration in milliseconds.
     */
    public func duration() -> Int {
        let ms = self.ms * BInt(self.factor) ** self.numAttempts
        self.numAttempts += 1
        return Int(round(Double(min(Int(ms), self.max))))
    }

    /**
     * Reset the number of attempts.
     */
    public func reset() {
        self.numAttempts = 0
    }
}
