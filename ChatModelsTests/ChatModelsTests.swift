import XCTest

@testable import SimpleProject

/// Pure model logic — no views, no snapshots.
final class ChatModelsTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testPreviewTextPerBodyKind() {
        let sentAt = ChatClock.date(2025, 6, 12, 9, 0)

        let text = Message(id: 1, author: .me, body: .text("Hello"), sentAt: sentAt)
        XCTAssertEqual(text.previewText, "Hello")

        let photo = Message(id: 2, author: .me, body: .photo(caption: "Beach", tint: .teal), sentAt: sentAt)
        XCTAssertEqual(photo.previewText, "Beach")

        let file = Message(id: 3, author: .me, body: .file(name: "spec.pdf", size: "1 MB"), sentAt: sentAt)
        XCTAssertEqual(file.previewText, "spec.pdf")

        let voice = Message(id: 4, author: .me, body: .voice(seconds: 5, waveform: [0.5]), sentAt: sentAt)
        XCTAssertEqual(voice.previewText, "")
    }

    func testConversationSummarisesItsLastMessage() {
        let conversation = SampleData.mayaThread(strings)
        XCTAssertEqual(conversation.lastMessage?.id, conversation.messages.last?.id)
        XCTAssertEqual(conversation.previewSymbol, "doc.fill")
    }

    func testGroupDetection() {
        XCTAssertTrue(SampleData.devTeam(strings).isGroup)
        XCTAssertFalse(SampleData.maya(strings).isGroup)
    }
}
