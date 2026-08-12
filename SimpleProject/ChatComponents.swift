//
//  ChatComponents.swift
//  SimpleProject
//
//  Small building blocks shared by the conversation list and the chat detail
//  screen. Nothing here animates: snapshots need every run to render the same
//  pixels.
//

import SwiftUI

/// Circular avatar with the contact's initials over their tint, plus an
/// optional presence dot.
struct AvatarView: View {
    let contact: Contact
    var size: CGFloat = 52

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(contact.tint.gradient)
                .frame(width: size, height: size)
                .overlay {
                    if contact.isGroup {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: size * 0.36, weight: .semibold))
                            .foregroundStyle(.white)
                    } else {
                        Text(contact.initials)
                            .font(.system(size: size * 0.38, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }

            if contact.isOnline {
                Circle()
                    .fill(Color.green)
                    .frame(width: size * 0.28, height: size * 0.28)
                    .overlay {
                        Circle().stroke(Color(uiColor: .systemBackground), lineWidth: size * 0.05)
                    }
            }
        }
        .frame(width: size, height: size)
    }
}

/// The sending / sent / delivered / read ticks on outgoing messages.
struct DeliveryTicksView: View {
    let status: DeliveryStatus
    var tint: Color = .white.opacity(0.75)

    var body: some View {
        Group {
            switch status {
            case .sending:
                Image(systemName: "clock")
            case .sent:
                Image(systemName: "checkmark")
            case .delivered, .read:
                ZStack(alignment: .leading) {
                    Image(systemName: "checkmark")
                    Image(systemName: "checkmark").offset(x: 4)
                }
                .padding(.trailing, 4)
            }
        }
        .font(.caption2.weight(.bold))
        .foregroundStyle(status == .read ? Color(red: 0.45, green: 0.85, blue: 1.0) : tint)
    }
}

/// Static three-dot "typing" bubble.
struct TypingIndicatorView: View {
    private let opacities: [Double] = [0.35, 0.6, 0.9]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(opacities.enumerated()), id: \.offset) { _, opacity in
                Circle()
                    .fill(Color.secondary.opacity(opacity))
                    .frame(width: 7, height: 7)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(uiColor: .secondarySystemBackground), in: Capsule())
    }
}

/// Fixed-height bars standing in for an audio waveform.
struct WaveformView: View {
    let samples: [CGFloat]
    let tint: Color
    var height: CGFloat = 26

    var body: some View {
        HStack(alignment: .center, spacing: 2.5) {
            ForEach(Array(samples.enumerated()), id: \.offset) { _, sample in
                Capsule()
                    .fill(tint)
                    .frame(width: 2.5, height: max(3, sample * height))
            }
        }
        .frame(height: height)
    }
}

/// Rounded pill used for unread counts.
struct UnreadBadge: View {
    let count: Int
    var muted: Bool = false

    var body: some View {
        Text("\(count)")
            .font(.footnote.weight(.semibold))
            .monospacedDigit()
            .foregroundStyle(.white)
            .padding(.horizontal, count > 9 ? 7 : 0)
            .frame(minWidth: 22, minHeight: 22)
            .background(muted ? Color.secondary.opacity(0.6) : Color.accentColor, in: Capsule())
    }
}

/// Centred date pill between message groups.
struct DaySeparator: View {
    let label: String

    var body: some View {
        Text(label)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Color(uiColor: .secondarySystemBackground), in: Capsule())
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}

/// Full-width rule marking where the unread messages begin.
struct UnreadDivider: View {
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Color.accentColor.opacity(0.35)).frame(height: 1)
            Text(label.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.accentColor)
            Rectangle().fill(Color.accentColor.opacity(0.35)).frame(height: 1)
        }
        .padding(.vertical, 10)
    }
}
