//
//  DynamicTypeSnapshotTests.swift
//  SimpleProjectTests
//
//  Accessibility text sizes. Layouts that look fine at the default size are
//  usually where truncation and clipping first appear.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import SimpleProject

final class DynamicTypeSnapshotTests: XCTestCase {

    private let strings = TestLocale.english.strings

    private let sizes: [TestTypeSize] = [.extraLarge, .accessibility]

    func testConversationList() {
        for size in sizes {
            assertScreenSnapshot(
                ConversationListView(conversations: SampleData.conversations(strings)),
                named: size.tag,
                typeSize: size
            )
        }
    }

    func testChatDetail() {
        for size in sizes {
            assertScreenSnapshot(
                ChatDetailView(conversation: SampleData.mayaThread(strings)),
                named: size.tag,
                typeSize: size
            )
        }
    }

    /// Largest text on the smallest screen — the worst case.
    func testChatDetailOnSmallDevice() {
        assertScreenSnapshot(
            ChatDetailView(conversation: SampleData.mayaThread(strings)),
            device: .iPhoneSe,
            typeSize: .accessibility
        )
    }

    func testEmptyState() {
        assertScreenSnapshot(
            ConversationListView(conversations: []),
            typeSize: .accessibility
        )
    }

    func testConversationRow() {
        for size in sizes {
            let conversations = SampleData.conversations(strings)
            let rows = VStack(spacing: 0) {
                ForEach(conversations.prefix(3)) { conversation in
                    ConversationRow(conversation: conversation)
                    Divider().padding(.leading, 64)
                }
            }
            assertComponentSnapshot(rows, named: size.tag, width: 375, typeSize: size)
        }
    }
}
