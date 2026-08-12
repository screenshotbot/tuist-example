//
//  ChatSampleData.swift
//  SimpleProject
//
//  Fixture data for previews and snapshot tests. Built from `Strings` so every
//  screen can be rendered in any supported language.
//

import SwiftUI

enum SampleData {

    // MARK: Contacts

    static func maya(_ s: Strings) -> Contact {
        Contact(id: 1, name: "Maya Ferreira", initials: "MF", tint: .indigo, isOnline: true)
    }

    static func devTeam(_ s: Strings) -> Contact {
        Contact(id: 2, name: s.groupDevTeam, initials: "DT", tint: .teal, groupMemberCount: 8)
    }

    static func priya(_ s: Strings) -> Contact {
        Contact(id: 3, name: "Priya Raman", initials: "PR", tint: .pink, isOnline: true)
    }

    static func marco(_ s: Strings) -> Contact {
        Contact(id: 4, name: "Marco Bianchi", initials: "MB", tint: .orange)
    }

    static func family(_ s: Strings) -> Contact {
        Contact(id: 5, name: s.groupFamily, initials: "F", tint: .green, groupMemberCount: 5)
    }

    static func sam(_ s: Strings) -> Contact {
        Contact(id: 6, name: "Sam Okafor", initials: "SO", tint: .purple)
    }

    static func jonas(_ s: Strings) -> Contact {
        Contact(id: 7, name: "Jonas Weber", initials: "JW", tint: .teal)
    }

    static func alerts(_ s: Strings) -> Contact {
        Contact(id: 8, name: "Deploy Alerts", initials: "DA", tint: .indigo)
    }

    // MARK: Threads

    private static let waveform: [CGFloat] = [
        0.25, 0.45, 0.70, 0.95, 0.60, 0.35, 0.55, 0.80, 1.00, 0.75,
        0.40, 0.30, 0.65, 0.85, 0.50, 0.30, 0.45, 0.70, 0.40, 0.20,
    ]

    /// The main thread used by most chat-detail snapshots. Spans two days so the
    /// "Yesterday" / "Today" separators both appear.
    static func mayaThread(_ s: Strings) -> Conversation {
        let yesterday = { (h: Int, m: Int) in ChatClock.date(2025, 6, 11, h, m) }
        let today = { (h: Int, m: Int) in ChatClock.date(2025, 6, 12, h, m) }

        let messages: [Message] = [
            Message(
                id: 1, author: .them,
                body: .voice(seconds: 35, waveform: waveform),
                sentAt: yesterday(17, 20)
            ),
            Message(
                id: 2, author: .me,
                body: .text(s.threadThanks),
                sentAt: yesterday(17, 24),
                status: .read
            ),
            Message(
                id: 3, author: .them,
                body: .text(s.threadHello),
                sentAt: today(9, 12)
            ),
            Message(
                id: 4, author: .me,
                body: .text(s.threadReply),
                sentAt: today(9, 15),
                status: .read
            ),
            Message(
                id: 5, author: .them,
                body: .photo(caption: s.threadPhotoCaption, tint: .purple),
                sentAt: today(9, 41),
                reactions: [Reaction(id: 1, emoji: "🔥", count: 2)]
            ),
            Message(
                id: 6, author: .me,
                body: .text(s.threadShipIt),
                sentAt: today(9, 44),
                status: .read
            ),
            Message(
                id: 7, author: .them,
                body: .text(s.threadOneMore),
                sentAt: today(16, 2)
            ),
            Message(
                id: 8, author: .them,
                body: .text(s.threadBadge),
                sentAt: today(16, 3)
            ),
            Message(
                id: 9, author: .me,
                body: .text(s.threadAlreadyDone),
                sentAt: today(16, 5),
                status: .delivered,
                replyingTo: (author: "Maya Ferreira", text: s.threadBadge)
            ),
            Message(
                id: 10, author: .them,
                body: .file(name: "Design-System-v4.pdf", size: "2.4 MB"),
                sentAt: today(16, 12)
            ),
        ]

        return Conversation(
            id: 1,
            contact: maya(s),
            messages: messages,
            unreadCount: 2,
            isPinned: true,
            firstUnreadID: 7
        )
    }

    /// Same participants, mid-conversation: the other side is typing and the
    /// outgoing message is still in flight.
    static func mayaThreadTyping(_ s: Strings) -> Conversation {
        var conversation = mayaThread(s)
        var messages = Array(conversation.messages.prefix(9))
        messages[8].status = .sending
        conversation = Conversation(
            id: 1,
            contact: maya(s),
            messages: messages,
            unreadCount: 0,
            isPinned: true,
            isTyping: true
        )
        return conversation
    }

    /// A brand-new thread — one message, nothing else.
    static func freshThread(_ s: Strings) -> Conversation {
        Conversation(
            id: 9,
            contact: jonas(s),
            messages: [
                Message(
                    id: 1, author: .me,
                    body: .text(s.threadHello),
                    sentAt: ChatClock.date(2025, 6, 12, 16, 18),
                    status: .sent
                )
            ]
        )
    }

    // MARK: Conversation list

    static func conversations(_ s: Strings) -> [Conversation] {
        let thread = mayaThread(s)

        return [
            thread,
            Conversation(
                id: 2,
                contact: devTeam(s),
                messages: [
                    Message(id: 1, author: .them, body: .text(s.previewDevTeam),
                            sentAt: ChatClock.date(2025, 6, 12, 15, 48))
                ],
                unreadCount: 12,
                isMuted: true
            ),
            Conversation(
                id: 3,
                contact: priya(s),
                messages: [
                    Message(id: 1, author: .me, body: .text(s.previewPriya),
                            sentAt: ChatClock.date(2025, 6, 12, 14, 2), status: .read)
                ],
                isTyping: true
            ),
            Conversation(
                id: 4,
                contact: marco(s),
                messages: [
                    Message(id: 1, author: .them, body: .voice(seconds: 12, waveform: waveform),
                            sentAt: ChatClock.date(2025, 6, 12, 11, 27))
                ],
                unreadCount: 1,
                previewOverride: s.voiceMessage
            ),
            Conversation(
                id: 5,
                contact: family(s),
                messages: [
                    Message(id: 1, author: .them, body: .text(s.previewFamily),
                            sentAt: ChatClock.date(2025, 6, 11, 19, 5))
                ],
                isMuted: true
            ),
            Conversation(
                id: 6,
                contact: sam(s),
                messages: [
                    Message(id: 1, author: .me, body: .text(s.previewSam),
                            sentAt: ChatClock.date(2025, 6, 10, 16, 40), status: .delivered)
                ]
            ),
            Conversation(
                id: 7,
                contact: jonas(s),
                messages: [
                    Message(id: 1, author: .them, body: .text(s.previewJonas),
                            sentAt: ChatClock.date(2025, 6, 8, 10, 15))
                ]
            ),
            Conversation(
                id: 8,
                contact: alerts(s),
                messages: [
                    Message(id: 1, author: .them, body: .text(s.previewAlerts),
                            sentAt: ChatClock.date(2025, 5, 29, 8, 3))
                ]
            ),
        ]
    }
}
