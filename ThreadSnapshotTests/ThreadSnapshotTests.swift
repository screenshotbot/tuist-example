import SnapshotSupport
import SwiftUI
import XCTest

@testable import SimpleProject

/// The chat detail screen in its three main states.
final class ThreadSnapshotTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testThread() {
        assertScreen(ChatDetailView(conversation: SampleData.mayaThread(strings)))
    }

    func testThreadWhileTyping() {
        assertScreen(ChatDetailView(conversation: SampleData.mayaThreadTyping(strings)))
    }

    func testThreadForNewConversation() {
        assertScreen(ChatDetailView(conversation: SampleData.freshThread(strings)))
    }
}
