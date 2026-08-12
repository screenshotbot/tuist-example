//
//  ChatSnapshotTests.swift
//  SimpleProjectTests
//
//  Full-screen snapshots of the chat app, each captured in light and dark mode.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import SimpleProject

final class ChatSnapshotTests: XCTestCase {

    private let strings = TestLocale.english.strings

    // MARK: Inbox

    func testConversationList() {
        assertScreenSnapshot(
            ConversationListView(conversations: SampleData.conversations(strings))
        )
    }

    func testConversationListOnSmallDevice() {
        assertScreenSnapshot(
            ConversationListView(conversations: SampleData.conversations(strings)),
            device: .iPhoneSe
        )
    }

    func testConversationListOnLargeDevice() {
        assertScreenSnapshot(
            ConversationListView(conversations: SampleData.conversations(strings)),
            device: .iPhone13ProMax
        )
    }

    func testConversationListWhenEmpty() {
        assertScreenSnapshot(ConversationListView(conversations: []))
    }

    /// One unread conversation, no pins — the state right after onboarding.
    func testConversationListWithSingleThread() {
        let conversations = [SampleData.freshThread(strings)]
        assertScreenSnapshot(ConversationListView(conversations: conversations))
    }

    // MARK: Conversation

    func testChatDetail() {
        assertScreenSnapshot(
            ChatDetailView(conversation: SampleData.mayaThread(strings))
        )
    }

    func testChatDetailOnSmallDevice() {
        assertScreenSnapshot(
            ChatDetailView(conversation: SampleData.mayaThread(strings)),
            device: .iPhoneSe
        )
    }

    func testChatDetailWhileTyping() {
        assertScreenSnapshot(
            ChatDetailView(conversation: SampleData.mayaThreadTyping(strings))
        )
    }

    func testChatDetailWithDraft() {
        assertScreenSnapshot(
            ChatDetailView(
                conversation: SampleData.mayaThreadTyping(strings),
                draft: "Pushing a fix for the badge colour now — should be on TestFlight in ten."
            )
        )
    }

    func testChatDetailForNewConversation() {
        assertScreenSnapshot(
            ChatDetailView(conversation: SampleData.freshThread(strings))
        )
    }

    func testChatDetailForGroup() {
        let conversations = SampleData.conversations(strings)
        let group = conversations.first { $0.contact.isGroup }!
        assertScreenSnapshot(ChatDetailView(conversation: group))
    }

    // MARK: App entry points

    func testRootView() {
        assertScreenSnapshot(ContentView())
    }

    func testLoginScreen() {
        assertScreenSnapshot(LoginView())
    }
}
