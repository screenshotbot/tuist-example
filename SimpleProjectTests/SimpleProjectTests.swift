//
//  SimpleProjectTests.swift
//  SimpleProjectTests
//
//  Created by Arnold Noronha on 1/5/24.
//

import XCTest
import SnapshotTesting

@testable import SimpleProject

final class SimpleProjectTests: XCTestCase {

    func testDataSnapshot() throws {
        let data = "foobar"
        //Data snapshots do not work on XCode cloud
        //assertSnapshot(matching: data, as: .dump)
    }

    /// The original login screen snapshot, kept in its plain sizeThatFits form.
    /// The chat screens use the helpers in `SnapshotSupport.swift` instead.
    func testLoginViewSnapshot() throws {
        let loginView = LoginView()
        assertSnapshot(matching: loginView, as: .image)
    }
}
