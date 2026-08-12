//
//  MessageBubbleView.swift
//  SimpleProject
//
//  A single message row: quote, body (text / photo / voice note / file),
//  timestamp, delivery ticks and reactions.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message

    @Environment(\.locale) private var locale
    @Environment(\.strings) private var strings

    private var isMine: Bool { message.author == .me }

    var body: some View {
        HStack(spacing: 0) {
            if isMine { Spacer(minLength: 56) }

            VStack(alignment: isMine ? .trailing : .leading, spacing: -8) {
                bubble
                if !message.reactions.isEmpty {
                    reactions
                        .padding(isMine ? .trailing : .leading, 12)
                        .zIndex(1)
                }
            }

            if !isMine { Spacer(minLength: 56) }
        }
        .padding(.bottom, message.reactions.isEmpty ? 0 : 8)
    }

    // MARK: Bubble

    private var bubble: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let quote = message.replyingTo {
                quoteView(author: quote.author, text: quote.text)
            }

            switch message.body {
            case .text(let text):
                Text(text)
                    .font(.body)
                    .foregroundStyle(isMine ? Color.white : Color.primary)
                    .fixedSize(horizontal: false, vertical: true)

            case .photo(let caption, let tint):
                photoView(tint: tint)
                if let caption {
                    Text(caption)
                        .font(.body)
                        .foregroundStyle(isMine ? Color.white : Color.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

            case .voice(let seconds, let waveform):
                voiceView(seconds: seconds, waveform: waveform)

            case .file(let name, let size):
                fileView(name: name, size: size)
            }

            footer
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(bubbleBackground)
        .clipShape(bubbleShape)
    }

    private var bubbleShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            cornerRadii: .init(
                topLeading: 18,
                bottomLeading: isMine ? 18 : 5,
                bottomTrailing: isMine ? 5 : 18,
                topTrailing: 18
            )
        )
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        if isMine {
            LinearGradient(
                colors: [Color(red: 0.20, green: 0.52, blue: 0.98), Color(red: 0.13, green: 0.38, blue: 0.92)],
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            Color(uiColor: .secondarySystemBackground)
        }
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text(ChatClock.time(message.sentAt, locale: locale))
                .font(.caption2)
                .foregroundStyle(isMine ? Color.white.opacity(0.75) : Color.secondary)
            if isMine {
                DeliveryTicksView(status: message.status)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    // MARK: Bodies

    private func quoteView(author: String, text: String) -> some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(isMine ? Color.white.opacity(0.8) : Color.accentColor)
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 1) {
                Text(author)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(isMine ? Color.white : Color.accentColor)
                Text(text)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundStyle(isMine ? Color.white.opacity(0.85) : Color.secondary)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .frame(maxWidth: 230, alignment: .leading)
        .background(
            (isMine ? Color.white.opacity(0.18) : Color.primary.opacity(0.06)),
            in: RoundedRectangle(cornerRadius: 8)
        )
    }

    private func photoView(tint: PaletteColor) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(tint.gradient)
            .frame(width: 214, height: 148)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 34, weight: .light))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .accessibilityLabel(strings.photo)
    }

    private func voiceView(seconds: Int, waveform: [CGFloat]) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "play.fill")
                .font(.system(size: 13))
                .foregroundStyle(isMine ? Color.white : Color.accentColor)
                .frame(width: 30, height: 30)
                .background(
                    (isMine ? Color.white.opacity(0.22) : Color.accentColor.opacity(0.15)),
                    in: Circle()
                )

            WaveformView(
                samples: waveform,
                tint: isMine ? Color.white.opacity(0.85) : Color.accentColor.opacity(0.7)
            )

            Text(String(format: "0:%02d", seconds))
                .font(.caption.monospacedDigit())
                .foregroundStyle(isMine ? Color.white.opacity(0.8) : Color.secondary)
        }
        .accessibilityLabel(strings.voiceMessage)
    }

    private func fileView(name: String, size: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.fill")
                .font(.system(size: 17))
                .foregroundStyle(isMine ? Color.white : Color.accentColor)
                .frame(width: 38, height: 38)
                .background(
                    (isMine ? Color.white.opacity(0.22) : Color.accentColor.opacity(0.15)),
                    in: RoundedRectangle(cornerRadius: 9)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                    .foregroundStyle(isMine ? Color.white : Color.primary)
                Text(size)
                    .font(.caption)
                    .foregroundStyle(isMine ? Color.white.opacity(0.75) : Color.secondary)
            }
        }
    }

    private var reactions: some View {
        HStack(spacing: 4) {
            ForEach(message.reactions) { reaction in
                HStack(spacing: 3) {
                    Text(reaction.emoji).font(.caption)
                    if reaction.count > 1 {
                        Text("\(reaction.count)")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(Color(uiColor: .systemBackground), in: Capsule())
                .overlay(Capsule().stroke(Color.primary.opacity(0.08), lineWidth: 1))
            }
        }
    }
}
