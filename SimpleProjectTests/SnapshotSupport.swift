//
//  SnapshotSupport.swift
//  SimpleProjectTests
//
//  Shared plumbing for the chat snapshot tests.
//
//  Every screen is captured twice — light and dark — and every axis that could
//  drift between machines (locale, layout direction, dynamic type, display
//  scale, time zone) is pinned explicitly here rather than inherited from the
//  simulator.
//
//  Re-record everything with:
//
//      RECORD_SNAPSHOTS=1 xcodebuild test -scheme SimpleProject \
//          -destination 'platform=iOS Simulator,name=iPhone SE (3rd generation)'
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import SimpleProject

/// Set `RECORD_SNAPSHOTS=1` in the environment to overwrite the reference images.
let isRecordingSnapshots = ProcessInfo.processInfo.environment["RECORD_SNAPSHOTS"] == "1"

/// The languages the app ships. Arabic doubles as the right-to-left case.
enum TestLocale: String, CaseIterable {
    case english = "en_US"
    case spanish = "es_ES"
    case german = "de_DE"
    case japanese = "ja_JP"
    case arabic = "ar_EG"

    var locale: Locale { Locale(identifier: rawValue) }

    /// Short tag used in snapshot file names, e.g. `testChatDetail.ja-dark.png`.
    var tag: String { String(rawValue.prefix(2)) }

    var strings: Strings { Strings.forLocale(locale) }
}

/// Dynamic type sizes exercised by `DynamicTypeSnapshotTests`, paired so the
/// SwiftUI environment and the UIKit trait collection always agree.
struct TestTypeSize {
    let tag: String
    let swiftUI: ContentSizeCategory
    let uiKit: UIContentSizeCategory

    static let standard = TestTypeSize(tag: "standard", swiftUI: .large, uiKit: .large)
    static let extraLarge = TestTypeSize(tag: "xxxl", swiftUI: .extraExtraExtraLarge,
                                         uiKit: .extraExtraExtraLarge)
    static let accessibility = TestTypeSize(tag: "a11y-xl", swiftUI: .accessibilityExtraLarge,
                                            uiKit: .accessibilityExtraLarge)
}

extension ColorScheme {
    var tag: String { self == .dark ? "dark" : "light" }

    var userInterfaceStyle: UIUserInterfaceStyle { self == .dark ? .dark : .light }
}

extension XCTestCase {

    /// Captures a full screen on `device`, once per color scheme.
    ///
    /// - Parameters:
    ///   - name: Optional variant prefix; the color scheme is always appended,
    ///     so a snapshot ends up named `testChatDetail.<name>-dark.png`.
    func assertScreenSnapshot<V: View>(
        _ view: V,
        named name: String? = nil,
        device: ViewImageConfig = .iPhone13,
        locale: TestLocale = .english,
        typeSize: TestTypeSize = .standard,
        colorSchemes: [ColorScheme] = [.light, .dark],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for scheme in colorSchemes {
            let configured =
                view
                .chatLocale(locale.locale)
                .environment(\.colorScheme, scheme)
                .environment(\.sizeCategory, typeSize.swiftUI)

            assertSnapshot(
                of: configured,
                as: .image(
                    layout: .device(config: device),
                    traits: traits(scheme: scheme, locale: locale, typeSize: typeSize)
                ),
                named: [name, scheme.tag].compactMap { $0 }.joined(separator: "-"),
                record: isRecordingSnapshots,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    /// Captures a single component sized to its content, on a plain background,
    /// once per color scheme.
    func assertComponentSnapshot<V: View>(
        _ view: V,
        named name: String? = nil,
        width: CGFloat = 340,
        locale: TestLocale = .english,
        typeSize: TestTypeSize = .standard,
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
                .chatLocale(locale.locale)
                .environment(\.colorScheme, scheme)
                .environment(\.sizeCategory, typeSize.swiftUI)

            assertSnapshot(
                of: configured,
                as: .image(
                    layout: .sizeThatFits,
                    traits: traits(scheme: scheme, locale: locale, typeSize: typeSize, displayScale: 2)
                ),
                named: [name, scheme.tag].compactMap { $0 }.joined(separator: "-"),
                record: isRecordingSnapshots,
                file: file,
                testName: testName,
                line: line
            )
        }
    }

    /// UIKit side of the environment. SwiftUI resolves semantic colors such as
    /// `.systemBackground` through the hosting view's traits, so the style has
    /// to be set here as well as in the SwiftUI environment.
    private func traits(
        scheme: ColorScheme,
        locale: TestLocale,
        typeSize: TestTypeSize,
        displayScale: CGFloat? = nil
    ) -> UITraitCollection {
        var collections: [UITraitCollection] = [
            UITraitCollection(userInterfaceStyle: scheme.userInterfaceStyle),
            UITraitCollection(preferredContentSizeCategory: typeSize.uiKit),
            UITraitCollection(layoutDirection: locale == .arabic ? .rightToLeft : .leftToRight),
        ]
        if let displayScale {
            collections.append(UITraitCollection(displayScale: displayScale))
        }
        return UITraitCollection(traitsFrom: collections)
    }
}
