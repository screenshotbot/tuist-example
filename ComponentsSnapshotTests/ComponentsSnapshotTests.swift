import SnapshotSupport
import SwiftUI
import XCTest

@testable import SimpleProject

/// Small reusable pieces, captured on their own so a screen-level diff can be
/// traced back to the component that moved.
final class ComponentsSnapshotTests: XCTestCase {

    private let strings = Strings.forLocale(Locale(identifier: "en_US"))

    func testAvatar() {
        assertComponent(AvatarView(contact: SampleData.maya(strings)), width: 80)
    }

    func testUnreadBadges() {
        let badges = HStack(spacing: 12) {
            UnreadBadge(count: 1)
            UnreadBadge(count: 12)
            UnreadBadge(count: 99, muted: true)
        }
        assertComponent(badges, width: 200)
    }

    func testDeliveryTicks() {
        let ticks = HStack(spacing: 16) {
            DeliveryTicksView(status: .sending, tint: .secondary)
            DeliveryTicksView(status: .sent, tint: .secondary)
            DeliveryTicksView(status: .delivered, tint: .secondary)
            DeliveryTicksView(status: .read, tint: .blue)
        }
        assertComponent(ticks, width: 200)
    }
}
