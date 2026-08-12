import XCTest

@testable import SimpleProject

/// The fixtures every snapshot renders. If these drift, every channel moves at
/// once — which is exactly the blast radius selective testing has to get right.
final class SampleDataTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testInboxFixtureShape() {
        let conversations = SampleData.conversations(strings)
        XCTAssertEqual(conversations.count, 8)
        XCTAssertEqual(conversations.filter(\.isPinned).count, 1)
        XCTAssertEqual(conversations.filter(\.isMuted).count, 2)
    }

    func testMainThreadIsOrderedAndUnread() {
        let thread = SampleData.mayaThread(strings)
        XCTAssertEqual(thread.messages.count, 10)
        XCTAssertEqual(thread.unreadCount, 2)
        XCTAssertEqual(thread.firstUnreadID, 7)

        let timestamps = thread.messages.map(\.sentAt)
        XCTAssertEqual(timestamps, timestamps.sorted())
    }

    func testFreshThreadHasOneOutgoingMessage() {
        let thread = SampleData.freshThread(strings)
        XCTAssertEqual(thread.messages.count, 1)
        XCTAssertEqual(thread.messages.first?.author, .me)
        XCTAssertEqual(thread.messages.first?.status, .sent)
    }
}
