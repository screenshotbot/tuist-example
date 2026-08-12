import XCTest

@testable import SimpleProject

/// The fixed tint set. Adding a colour here changes avatars everywhere, so it's
/// worth pinning the count and the assignments the fixtures rely on.
final class PaletteTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testPaletteIsFixed() {
        XCTAssertEqual(PaletteColor.allCases.count, 6)
    }

    func testContactTintsAreDistinctWithinTheInbox() {
        let tints = SampleData.conversations(strings).map(\.contact.tint)
        XCTAssertEqual(tints.count, 8)
        XCTAssertEqual(Set(tints.map(String.init(describing:))).count, 6)
    }
}
