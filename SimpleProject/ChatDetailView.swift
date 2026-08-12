//
//  ChatDetailView.swift
//  SimpleProject
//
//  A single conversation: navigation bar with presence, the message transcript
//  grouped by day, and the composer.
//

import SwiftUI

struct ChatDetailView: View {
    let conversation: Conversation
    /// Text sitting in the composer, if any. Empty renders the idle state.
    var draft: String = ""

    @Environment(\.locale) private var locale
    @Environment(\.strings) private var strings

    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            transcript
            ChatComposer(draft: draft)
        }
        .background(Color(uiColor: .systemBackground))
    }

    // MARK: Navigation bar

    private var navigationBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "chevron.backward")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.accentColor)

                AvatarView(contact: conversation.contact, size: 40)

                VStack(alignment: .leading, spacing: 1) {
                    Text(conversation.contact.name)
                        .font(.body.weight(.semibold))
                        .lineLimit(1)
                    Text(presenceLine)
                        .font(.caption)
                        .foregroundStyle(conversation.isTyping ? Color.accentColor : Color.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 8)

                Image(systemName: "video")
                Image(systemName: "phone")
            }
            .font(.body)
            .foregroundStyle(Color.accentColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }

    private var presenceLine: String {
        if conversation.isTyping {
            return String(format: strings.typingFormat, firstName)
        }
        if conversation.contact.isGroup {
            return String(format: strings.membersFormat, conversation.contact.groupMemberCount)
        }
        if conversation.contact.isOnline {
            return strings.online
        }
        let lastSeen = conversation.lastMessage?.sentAt ?? ChatClock.now
        return String(format: strings.lastSeenFormat, ChatClock.time(lastSeen, locale: locale))
    }

    private var firstName: String {
        conversation.contact.name.split(separator: " ").first.map(String.init) ?? conversation.contact.name
    }

    // MARK: Transcript

    private var transcript: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(items) { item in
                    switch item.kind {
                    case .daySeparator(let label):
                        DaySeparator(label: label)
                    case .unreadDivider(let label):
                        UnreadDivider(label: label)
                    case .message(let message):
                        MessageBubbleView(message: message)
                    }
                }

                if conversation.isTyping {
                    TypingIndicatorView()
                        .padding(.top, 2)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .systemBackground))
    }

    /// The transcript flattened into rows, with day separators inserted
    /// whenever the calendar day changes.
    private var items: [TranscriptItem] {
        var result: [TranscriptItem] = []
        var lastDay: Date?

        for message in conversation.messages {
            let day = ChatClock.calendar.startOfDay(for: message.sentAt)
            if day != lastDay {
                result.append(
                    TranscriptItem(
                        id: "day-\(day.timeIntervalSince1970)",
                        kind: .daySeparator(ChatClock.daySeparator(message.sentAt, strings: strings, locale: locale))
                    )
                )
                lastDay = day
            }
            if message.id == conversation.firstUnreadID {
                result.append(
                    TranscriptItem(id: "unread-\(message.id)", kind: .unreadDivider(strings.unreadDivider))
                )
            }
            result.append(TranscriptItem(id: "message-\(message.id)", kind: .message(message)))
        }

        return result
    }

    struct TranscriptItem: Identifiable {
        enum Kind {
            case daySeparator(String)
            case unreadDivider(String)
            case message(Message)
        }

        let id: String
        let kind: Kind
    }
}

struct ChatComposer: View {
    var draft: String = ""

    @Environment(\.strings) private var strings

    private var hasDraft: Bool { !draft.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom, spacing: 10) {
                Image(systemName: "plus")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Color.accentColor)
                    .frame(height: 36)

                HStack(spacing: 8) {
                    Text(hasDraft ? draft : strings.messagePlaceholder)
                        .font(.body)
                        .foregroundStyle(hasDraft ? Color.primary : Color.secondary)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 4)
                    Image(systemName: "face.smiling")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .frame(minHeight: 38)
                .background(Color(uiColor: .tertiarySystemFill), in: Capsule())

                Image(systemName: hasDraft ? "arrow.up" : "mic.fill")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.white)
                    .frame(width: 38, height: 38)
                    .background(Color.accentColor, in: Circle())
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .systemBackground))
    }
}

#Preview {
    ChatDetailView(conversation: SampleData.mayaThread(.english))
        .chatLocale(Locale(identifier: "en_US"))
}
