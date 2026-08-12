import SnapshotSupport
import SwiftUI
import XCTest

@testable import SimpleProject

/// Conversation list, at the three occupancies that matter.
final class InboxSnapshotTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testInbox() {
        assertScreen(ConversationListView(conversations: SampleData.conversations(strings)))
    }

    func testInboxWhenEmpty() {
        assertScreen(ConversationListView(conversations: []))
    }

    func testInboxWithSingleThread() {
        assertScreen(ConversationListView(conversations: [SampleData.freshThread(strings)]))
    }
}
