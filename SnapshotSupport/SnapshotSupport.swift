//
//  SnapshotSupport.swift
//  SnapshotSupport
//
//  Snapshot helpers shared by every snapshot test target.
//
//  This module exists to make the dependency graph realistic: the test targets
//  below depend on `SnapshotTesting` *transitively*, through this framework,
//  which is how large apps are usually laid out. Anything deciding "is this a
//  snapshot test target?" has to walk the graph rather than look for a direct
//  dependency edge.
//
//  It deliberately knows nothing about the app — only SwiftUI — so it can be a
//  framework rather than a test bundle.
//

import SnapshotTesting
import SwiftUI
import XCTest

/// Set `RECORD_SNAPSHOTS=1` in the environment to overwrite the reference images.
public let isRecordingSnapshots = ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"

extension ColorScheme {
    var snapshotTag: String { self == .dark ? "dark" : "light" }

    var userInterfaceStyle: UIUserInterfaceStyle { self == .dark ? .dark : .light }
}

extension XCTestCase {

    /// Captures a full screen on `device`, once per color scheme.
    ///
    /// `#file` is resolved at the call site, so snapshots land in a
    /// `__Snapshots__` directory next to the calling target's sources — one
    /// Screenshotbot channel per test target.
    public func assertScreen<V: View>(
        _ view: V,
        named name: String? = nil,
        device: ViewImageConfig = .iPhone13,
        colorSchemes: [ColorScheme] = [.light, .dark],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for scheme in colorSchemes {
            assertSnapshot(
                of: view.environment(\.colorScheme, scheme),
                as: .image(
                    layout: .device(config: device),
                    traits: UITraitCollection(userInterfaceStyle: scheme.userInterfaceStyle)
                ),
                named: [name, scheme.snapshotTag].compactMap { $0 }.joined(separator: "-"),
                record: isRecordingSnapshots,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    /// Captures a single component sized to its content, on a plain background,
    /// once per color scheme.
    public func assertComponent<V: View>(
        _ view: V,
        named name: String? = nil,
        width: CGFloat = 340,
        colorSchemes: [ColorScheme] = [.light, .dark],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for scheme in colorSchemes {
            let configured =
                view
                .frame(width: width)
                .padding(12)
                .background(Color(uiColor: .systemBackground))
                .environment(\.colorScheme, scheme)

            assertSnapshot(
                of: configured,
                as: .image(
                    layout: .sizeThatFits,
                    traits: UITraitCollection(traitsFrom: [
                        UITraitCollection(userInterfaceStyle: scheme.userInterfaceStyle),
                        UITraitCollection(displayScale: 2),
                    ])
                ),
                named: [name, scheme.snapshotTag].compactMap { $0 }.joined(separator: "-"),
                record: isRecordingSnapshots,
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
