import Foundation
import Testing
@testable import FFFoundation

fileprivate extension ExpressibleByIntegerLiteral {
    static var nsecPerSec: Self { 1_000_000_000 }
}

@Suite
struct TimerTests {
    @Test
    func timerFiringManually() {
        var timerInClosure: AnyTimer?
        let timer = AnyTimer(interval: 2, block: { timerInClosure = $0 })
        timer.fire()
        #expect(timerInClosure === timer)
    }

    @Test
    func timerInvalidatesOnDeinit() async throws {
        try await confirmation(expectedCount: 0) { confirmation in
            let timerInterval: TimeInterval = 2.0
            var timer: AnyTimer? = AnyTimer(interval: timerInterval, block: { _ in confirmation() })
            timer?.schedule()
            timer = nil // deinit
            try await Task.sleep(nanoseconds: UInt64(timerInterval * .nsecPerSec) * 2)
        }
    }

    @Test
    func timerWithShortIntervalAndNoTolerance() async throws {
        try await confirmation(expectedCount: 1) { exp in
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let timer = AnyTimer(interval: timerInterval, block: { timer in
                #expect(abs(abs(date.timeIntervalSinceNow) - timerInterval) <= 0.02)
                exp()
            })
            date = Date()
            timer.schedule()
            try await Task.sleep(nanoseconds: UInt64(timerInterval * .nsecPerSec) * 2)
        }
    }

    @Test
    func timerWithShortIntervalAndTolerance() async throws {
        try await confirmation(expectedCount: 1) { exp in
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let tolerance: TimeInterval = 0.5

            let timer = AnyTimer(interval: timerInterval, block: { timer in
                #expect(abs(abs(date.timeIntervalSinceNow) - timerInterval) <= tolerance)
                exp()
            })
            timer.tolerance = tolerance
            date = Date()
            timer.schedule()
            try await Task.sleep(nanoseconds: UInt64(timerInterval * .nsecPerSec) * 2)
        }
    }

    @Test
    func repeatingTimerWithShortIntervalAndTolerance() async throws {
        try await confirmation(expectedCount: 1) { exp in
            var date = Date()
            let timerInterval: TimeInterval = 2.0
            let tolerance: TimeInterval = 0.5
            var accuracies = Array<TimeInterval>()

            let repeats = 5
            var counter = 0
            let timer = AnyTimer(interval: timerInterval, repeats: true, block: { timer in
                let interval = Date().timeIntervalSince(date)
                date = Date()
                accuracies.append(interval)
                counter += 1
                if counter >= repeats {
                    timer.invalidate()
                    exp()
                }
            })
            timer.tolerance = tolerance
            date = Date()
            timer.schedule()
            while counter < repeats {
                try await Task.sleep(nanoseconds: UInt64(timerInterval * .nsecPerSec))
            }

            #expect(counter == repeats)
            #expect(accuracies.count == repeats)
            accuracies.forEach {
                #expect(abs($0 - timerInterval) <= tolerance + 0.09)
            }
        }
    }
}
