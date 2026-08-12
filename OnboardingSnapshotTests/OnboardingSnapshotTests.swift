import SnapshotSupport
import SwiftUI
import XCTest

@testable import SimpleProject

/// The screens outside the chat flow itself.
final class OnboardingSnapshotTests: XCTestCase {

    func testLogin() {
        assertScreen(LoginView())
    }

    func testRoot() {
        assertScreen(ContentView())
    }
}
