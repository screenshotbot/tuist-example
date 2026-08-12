import XCTest

@testable import SimpleProject

/// The deterministic clock the snapshots depend on. Assertions use `contains`
/// for formatted output, because the separator between time and AM/PM varies
/// between OS versions.
final class ChatClockTests: XCTestCase {

    private let locale = Locale(identifier: "en_US")
    private lazy var strings = Strings.forLocale(locale)

    func testTimeIsFormattedInUTC() {
        let morning = ChatClock.date(2025, 6, 12, 9, 41)
        XCTAssertTrue(ChatClock.time(morning, locale: locale).contains("9:41"))
    }

    func testRelativeStampCollapsesToTimeForToday() {
        let today = ChatClock.date(2025, 6, 12, 9, 41)
        let stamp = ChatClock.relativeStamp(today, strings: strings, locale: locale)
        XCTAssertEqual(stamp, ChatClock.time(today, locale: locale))
    }

    func testDaySeparatorNamesYesterdayAndWeekdays() {
        let yesterday = ChatClock.date(2025, 6, 11, 17, 20)
        XCTAssertEqual(ChatClock.daySeparator(yesterday, strings: strings, locale: locale), strings.yesterday)

        let lastWeekend = ChatClock.date(2025, 6, 8, 10, 15)
        XCTAssertEqual(ChatClock.daySeparator(lastWeekend, strings: strings, locale: locale), "Sunday")
    }
}
