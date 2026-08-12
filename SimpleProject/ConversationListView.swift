//
//  ConversationListView.swift
//  SimpleProject
//
//  The inbox: search field, pinned + recent conversations, tab bar.
//

import SwiftUI

struct ConversationListView: View {
    let conversations: [Conversation]

    @Environment(\.locale) private var locale
    @Environment(\.strings) private var strings

    var body: some View {
        VStack(spacing: 0) {
            header

            if conversations.isEmpty {
                ChatEmptyStateView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(conversations) { conversation in
                            ConversationRow(conversation: conversation)
                            Divider().padding(.leading, 80)
                        }
                    }
                }
            }

            ChatTabBar(unreadCount: totalUnread)
        }
        .background(Color(uiColor: .systemBackground))
    }

    private var totalUnread: Int {
        conversations.reduce(0) { $0 + $1.unreadCount }
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Text(strings.appTitle)
                    .font(.largeTitle.bold())
                Spacer()
                circleButton("camera")
                circleButton("square.and.pencil")
            }

            HStack(spacing: 7) {
                Image(systemName: "magnifyingglass")
                Text(strings.search)
                Spacer(minLength: 0)
            }
            .font(.body)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }

    private func circleButton(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.accentColor)
            .frame(width: 34, height: 34)
            .background(Color(uiColor: .secondarySystemBackground), in: Circle())
    }
}

struct ConversationRow: View {
    let conversation: Conversation

    @Environment(\.locale) private var locale
    @Environment(\.strings) private var strings

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AvatarView(contact: conversation.contact)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(conversation.contact.name)
                        .font(.body.weight(.semibold))
                        .lineLimit(1)
                    if conversation.isMuted {
                        Image(systemName: "bell.slash.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 4)
                    if let last = conversation.lastMessage {
                        Text(ChatClock.relativeStamp(last.sentAt, strings: strings, locale: locale))
                            .font(.footnote)
                            .foregroundStyle(conversation.unreadCount > 0 && !conversation.isMuted
                                             ? Color.accentColor : Color.secondary)
                    }
                }

                HStack(alignment: .top, spacing: 6) {
                    preview
                    Spacer(minLength: 4)
                    trailingAccessory
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 11)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var preview: some View {
        if conversation.isTyping {
            Text(String(format: strings.typingFormat, firstName))
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                .lineLimit(1)
        } else {
            HStack(spacing: 4) {
                if conversation.lastMessage?.author == .me, let status = conversation.lastMessage?.status {
                    DeliveryTicksView(status: status, tint: .secondary)
                }
                if let symbol = conversation.previewSymbol {
                    Image(systemName: symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(conversation.previewOverride ?? conversation.lastMessage?.previewText ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }

    @ViewBuilder
    private var trailingAccessory: some View {
        VStack(alignment: .trailing, spacing: 4) {
            if conversation.unreadCount > 0 {
                UnreadBadge(count: conversation.unreadCount, muted: conversation.isMuted)
            } else if conversation.isPinned {
                Image(systemName: "pin.fill")
                    .font(.caption)
                    .rotationEffect(.degrees(45))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var firstName: String {
        conversation.contact.name.split(separator: " ").first.map(String.init) ?? conversation.contact.name
    }
}

struct ChatEmptyStateView: View {
    @Environment(\.strings) private var strings

    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 52, weight: .thin))
                .foregroundStyle(Color.accentColor.opacity(0.7))
            Text(strings.emptyTitle)
                .font(.title3.weight(.semibold))
            Text(strings.emptyBody)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 260)
            Text(strings.emptyAction)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(Color.accentColor, in: Capsule())
                .padding(.top, 4)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ChatTabBar: View {
    var unreadCount: Int = 0

    @Environment(\.strings) private var strings

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .top, spacing: 0) {
                item("bubble.left.and.bubble.right.fill", strings.tabChats, selected: true, badge: unreadCount)
                item("phone.fill", strings.tabCalls, selected: false, badge: 0)
                item("gearshape.fill", strings.tabSettings, selected: false, badge: 0)
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
        }
        .background(Color(uiColor: .systemBackground))
    }

    private func item(_ symbol: String, _ title: String, selected: Bool, badge: Int) -> some View {
        VStack(spacing: 3) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: symbol)
                    .font(.title3)
                    .frame(minWidth: 34, minHeight: 24)
                if badge > 0 {
                    Text("\(badge)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .frame(minWidth: 16, minHeight: 16)
                        .background(Color.red, in: Capsule())
                        .offset(x: 4, y: -5)
                }
            }
            Text(title)
                .font(.caption2.weight(.medium))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .foregroundStyle(selected ? Color.accentColor : Color.secondary)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ConversationListView(conversations: SampleData.conversations(.english))
        .chatLocale(Locale(identifier: "en_US"))
}
