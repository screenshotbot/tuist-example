import SnapshotSupport
import SwiftUI
import XCTest

@testable import SimpleProject

/// Individual message bubbles, one body kind per test.
final class BubbleSnapshotTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testIncomingText() {
        let message = Message(
            id: 1, author: .them,
            body: .text(strings.threadHello),
            sentAt: ChatClock.date(2025, 6, 12, 9, 12)
        )
        assertComponent(MessageBubbleView(message: message))
    }

    func testOutgoingTextWithReceipt() {
        let message = Message(
            id: 2, author: .me,
            body: .text(strings.threadReply),
            sentAt: ChatClock.date(2025, 6, 12, 9, 15),
            status: .read
        )
        assertComponent(MessageBubbleView(message: message))
    }

    func testFileAttachment() {
        let message = Message(
            id: 3, author: .them,
            body: .file(name: "Design-System-v4.pdf", size: "2.4 MB"),
            sentAt: ChatClock.date(2025, 6, 12, 16, 12)
        )
        assertComponent(MessageBubbleView(message: message))
    }
}
