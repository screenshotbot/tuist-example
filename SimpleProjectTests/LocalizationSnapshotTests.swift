//
//  LocalizationSnapshotTests.swift
//  SimpleProjectTests
//
//  The same screens in every language we ship, light and dark. German catches
//  long compound words, Japanese catches line breaking and glyph height, and
//  Arabic flips the whole layout to right-to-left.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import SimpleProject

final class LocalizationSnapshotTests: XCTestCase {

    /// Inbox in all five languages: `testConversationList.es-light.png` and friends.
    func testConversationList() {
        for testLocale in TestLocale.allCases {
            assertScreenSnapshot(
                ConversationListView(conversations: SampleData.conversations(testLocale.strings)),
                named: testLocale.tag,
                locale: testLocale
            )
        }
    }

    /// Thread view in all five languages.
    func testChatDetail() {
        for testLocale in TestLocale.allCases {
            assertScreenSnapshot(
                ChatDetailView(conversation: SampleData.mayaThread(testLocale.strings)),
                named: testLocale.tag,
                locale: testLocale
            )
        }
    }

    /// Empty state, where the copy is longest and most likely to overflow.
    func testEmptyState() {
        for testLocale in TestLocale.allCases {
            assertScreenSnapshot(
                ConversationListView(conversations: []),
                named: testLocale.tag,
                locale: testLocale
            )
        }
    }

    /// Right-to-left needs the tightest screen too: bubbles, ticks and the
    /// composer all mirror.
    func testRightToLeftOnSmallDevice() {
        assertScreenSnapshot(
            ChatDetailView(
                conversation: SampleData.mayaThreadTyping(TestLocale.arabic.strings),
                draft: TestLocale.arabic.strings.threadAlreadyDone
            ),
            device: .iPhoneSe,
            locale: .arabic
        )
    }

    /// German is the longest of the translations; the composer and tab bar are
    /// where it shows first.
    func testGermanComposerAndTabBar() {
        let stack = VStack(spacing: 16) {
            ChatComposer()
            ChatComposer(draft: TestLocale.german.strings.threadAlreadyDone)
            ChatTabBar(unreadCount: 15)
        }
        assertComponentSnapshot(stack, width: 375, locale: .german)
    }

    /// Message bubbles on their own, per language — the fastest way to eyeball
    /// a translation change.
    func testMessageBubbles() {
        for testLocale in TestLocale.allCases {
            let strings = testLocale.strings
            let stack = VStack(alignment: .leading, spacing: 6) {
                MessageBubbleView(
                    message: Message(
                        id: 1, author: .them,
                        body: .text(strings.threadHello),
                        sentAt: ChatClock.date(2025, 6, 12, 9, 12)
                    )
                )
                MessageBubbleView(
                    message: Message(
                        id: 2, author: .me,
                        body: .text(strings.threadReply),
                        sentAt: ChatClock.date(2025, 6, 12, 9, 15),
                        status: .read
                    )
                )
                MessageBubbleView(
                    message: Message(
                        id: 3, author: .me,
                        body: .text(strings.threadAlreadyDone),
                        sentAt: ChatClock.date(2025, 6, 12, 16, 5),
                        status: .delivered,
                        replyingTo: (author: "Maya Ferreira", text: strings.threadBadge)
                    )
                )
            }
            assertComponentSnapshot(stack, named: testLocale.tag, locale: testLocale)
        }
    }
}
