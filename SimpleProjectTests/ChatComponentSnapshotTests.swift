//
//  ChatComponentSnapshotTests.swift
//  SimpleProjectTests
//
//  Component-level snapshots. These are cheap, fast, and pinpoint exactly which
//  piece of the UI moved when a screen-level snapshot changes.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import SimpleProject

final class ChatComponentSnapshotTests: XCTestCase {

    private let strings = TestLocale.english.strings

    // MARK: Bubbles

    func testIncomingTextBubble() {
        let message = Message(
            id: 1, author: .them,
            body: .text(strings.threadHello),
            sentAt: ChatClock.date(2025, 6, 12, 9, 12)
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    func testOutgoingTextBubble() {
        let message = Message(
            id: 1, author: .me,
            body: .text(strings.threadReply),
            sentAt: ChatClock.date(2025, 6, 12, 9, 15),
            status: .read
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    /// A message long enough to wrap several times, to catch bubble width and
    /// line-break regressions.
    func testLongTextBubble() {
        let message = Message(
            id: 1, author: .them,
            body: .text(
                """
                Reviewed the whole flow this morning — the inbox, the thread, \
                the empty state and the composer. Only thing left is the badge \
                colour, everything else looks ready to ship.
                """
            ),
            sentAt: ChatClock.date(2025, 6, 12, 9, 20)
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    func testPhotoBubbleWithCaptionAndReaction() {
        let message = Message(
            id: 1, author: .them,
            body: .photo(caption: strings.threadPhotoCaption, tint: .purple),
            sentAt: ChatClock.date(2025, 6, 12, 9, 41),
            reactions: [Reaction(id: 1, emoji: "🔥", count: 2)]
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    func testVoiceNoteBubble() {
        let conversation = SampleData.mayaThread(strings)
        let voiceNote = conversation.messages[0]
        assertComponentSnapshot(MessageBubbleView(message: voiceNote))
    }

    func testFileAttachmentBubble() {
        let message = Message(
            id: 1, author: .them,
            body: .file(name: "Design-System-v4.pdf", size: "2.4 MB"),
            sentAt: ChatClock.date(2025, 6, 12, 16, 12)
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    func testReplyQuoteBubble() {
        let message = Message(
            id: 1, author: .me,
            body: .text(strings.threadAlreadyDone),
            sentAt: ChatClock.date(2025, 6, 12, 16, 5),
            status: .delivered,
            replyingTo: (author: "Maya Ferreira", text: strings.threadBadge)
        )
        assertComponentSnapshot(MessageBubbleView(message: message))
    }

    /// All four delivery states side by side.
    func testDeliveryStatuses() {
        let statuses: [DeliveryStatus] = [.sending, .sent, .delivered, .read]
        let stack = VStack(alignment: .trailing, spacing: 6) {
            ForEach(Array(statuses.enumerated()), id: \.offset) { index, status in
                MessageBubbleView(
                    message: Message(
                        id: index, author: .me,
                        body: .text(["Sending…", "Sent", "Delivered", "Read"][index]),
                        sentAt: ChatClock.date(2025, 6, 12, 16, index),
                        status: status
                    )
                )
            }
        }
        assertComponentSnapshot(stack)
    }

    // MARK: List rows

    func testConversationRows() {
        let rows = VStack(spacing: 0) {
            ForEach(SampleData.conversations(strings)) { conversation in
                ConversationRow(conversation: conversation)
                Divider().padding(.leading, 64)
            }
        }
        assertComponentSnapshot(rows, width: 375)
    }

    func testConversationRowStates() {
        let all = SampleData.conversations(strings)
        let interesting = [
            all[1],  // muted group with a large unread count
            all[2],  // someone typing
            all[3],  // voice-note preview
            all[5],  // outgoing message with delivery ticks
        ]
        let rows = VStack(spacing: 0) {
            ForEach(interesting) { conversation in
                ConversationRow(conversation: conversation)
                Divider().padding(.leading, 64)
            }
        }
        assertComponentSnapshot(rows, width: 375)
    }

    // MARK: Small parts

    func testAvatars() {
        let contacts = [
            SampleData.maya(strings),
            SampleData.devTeam(strings),
            SampleData.marco(strings),
            SampleData.priya(strings),
        ]
        let row = HStack(spacing: 14) {
            ForEach(contacts) { contact in
                AvatarView(contact: contact)
            }
        }
        assertComponentSnapshot(row, width: 300)
    }

    func testUnreadBadges() {
        let row = HStack(spacing: 12) {
            UnreadBadge(count: 1)
            UnreadBadge(count: 9)
            UnreadBadge(count: 12)
            UnreadBadge(count: 128)
            UnreadBadge(count: 12, muted: true)
        }
        assertComponentSnapshot(row, width: 260)
    }

    func testTypingIndicator() {
        assertComponentSnapshot(
            HStack { TypingIndicatorView(); Spacer() },
            width: 200
        )
    }

    func testDaySeparatorAndUnreadDivider() {
        let stack = VStack(spacing: 0) {
            DaySeparator(label: strings.yesterday)
            DaySeparator(label: strings.today)
            UnreadDivider(label: strings.unreadDivider)
        }
        assertComponentSnapshot(stack)
    }

    func testComposerStates() {
        let stack = VStack(spacing: 16) {
            ChatComposer()
            ChatComposer(draft: "Already done, pushing the change now.")
            ChatComposer(
                draft: """
                    Long draft that wraps onto several lines so we can see how \
                    the composer grows with the text it contains.
                    """
            )
        }
        assertComponentSnapshot(stack, width: 375)
    }

    func testTabBar() {
        assertComponentSnapshot(ChatTabBar(unreadCount: 15), width: 375)
    }

    func testEmptyState() {
        assertComponentSnapshot(
            ChatEmptyStateView().frame(height: 420),
            width: 375
        )
    }
}
