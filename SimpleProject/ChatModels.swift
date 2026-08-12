//
//  ChatModels.swift
//  SimpleProject
//
//  Domain models for the chat app. Everything here is deterministic: dates are
//  built from fixed components in UTC so snapshots never depend on the wall
//  clock or the machine's time zone.
//

import SwiftUI

enum MessageAuthor {
    case me
    case them
}

/// Delivery state, rendered as the little checkmarks on outgoing messages.
enum DeliveryStatus {
    case sending
    case sent
    case delivered
    case read
}

enum MessageBody {
    case text(String)
    /// A photo attachment. The image is drawn as a gradient placeholder so the
    /// project needs no binary assets.
    case photo(caption: String?, tint: PaletteColor)
    /// A voice note with a fixed waveform, so it renders identically every run.
    case voice(seconds: Int, waveform: [CGFloat])
    case file(name: String, size: String)
}

struct Reaction: Identifiable {
    let id: Int
    let emoji: String
    let count: Int
}

struct Message: Identifiable {
    let id: Int
    let author: MessageAuthor
    let body: MessageBody
    let sentAt: Date
    var status: DeliveryStatus = .read
    var reactions: [Reaction] = []
    /// A quoted message shown above the bubble.
    var replyingTo: (author: String, text: String)?

    var previewText: String {
        switch body {
        case .text(let text): return text
        case .photo(let caption, _): return caption ?? ""
        case .voice: return ""
        case .file(let name, _): return name
        }
    }
}

/// Tints used for avatars and photo placeholders. Fixed set keeps colors stable
/// across runs and readable in both color schemes.
enum PaletteColor: CaseIterable {
    case indigo, teal, orange, pink, green, purple

    var gradient: LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var colors: [Color] {
        switch self {
        case .indigo: return [Color(red: 0.36, green: 0.42, blue: 0.94), Color(red: 0.24, green: 0.28, blue: 0.78)]
        case .teal: return [Color(red: 0.18, green: 0.70, blue: 0.72), Color(red: 0.10, green: 0.52, blue: 0.60)]
        case .orange: return [Color(red: 0.98, green: 0.62, blue: 0.24), Color(red: 0.92, green: 0.42, blue: 0.18)]
        case .pink: return [Color(red: 0.95, green: 0.42, blue: 0.62), Color(red: 0.80, green: 0.25, blue: 0.52)]
        case .green: return [Color(red: 0.30, green: 0.76, blue: 0.44), Color(red: 0.16, green: 0.58, blue: 0.34)]
        case .purple: return [Color(red: 0.66, green: 0.42, blue: 0.94), Color(red: 0.48, green: 0.28, blue: 0.80)]
        }
    }
}

struct Contact: Identifiable {
    let id: Int
    let name: String
    let initials: String
    let tint: PaletteColor
    var isOnline: Bool = false
    /// Members of a group chat; empty for one-to-one conversations.
    var groupMemberCount: Int = 0

    var isGroup: Bool { groupMemberCount > 0 }
}

struct Conversation: Identifiable {
    let id: Int
    let contact: Contact
    let messages: [Message]
    var unreadCount: Int = 0
    var isPinned: Bool = false
    /// The message the "unread messages" divider is drawn above, if any.
    var firstUnreadID: Int?
    var isMuted: Bool = false
    var isTyping: Bool = false
    /// Overrides the row preview when the last message isn't plain text.
    var previewOverride: String?

    var lastMessage: Message? { messages.last }

    var previewSymbol: String? {
        switch lastMessage?.body {
        case .photo: return "camera.fill"
        case .voice: return "mic.fill"
        case .file: return "doc.fill"
        default: return nil
        }
    }
}

// MARK: - Deterministic clock

enum ChatClock {
    static let timeZone = TimeZone(identifier: "UTC")!

    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }

    /// The "now" every screen is rendered against — Thursday, 12 June 2025, 16:20 UTC.
    static let now = date(2025, 6, 12, 16, 20)

    static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: timeZone,
            year: year, month: month, day: day, hour: hour, minute: minute
        )
        return components.date!
    }

    static func time(_ date: Date, locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    static func weekday(_ date: Date, locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: date)
    }

    static func shortDate(_ date: Date, locale: Locale) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.setLocalizedDateFormatFromTemplate("dMMM")
        return formatter.string(from: date)
    }

    /// Row timestamps collapse to a time, "Yesterday", a weekday, or a date.
    static func relativeStamp(_ date: Date, strings: Strings, locale: Locale) -> String {
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date),
                                           to: calendar.startOfDay(for: now)).day ?? 0
        switch days {
        case 0: return time(date, locale: locale)
        case 1: return strings.yesterday
        case 2...6: return weekday(date, locale: locale)
        default: return shortDate(date, locale: locale)
        }
    }

    static func daySeparator(_ date: Date, strings: Strings, locale: Locale) -> String {
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date),
                                           to: calendar.startOfDay(for: now)).day ?? 0
        switch days {
        case 0: return strings.today
        case 1: return strings.yesterday
        case 2...6: return weekday(date, locale: locale)
        default: return shortDate(date, locale: locale)
        }
    }
}
