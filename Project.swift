import ProjectDescription

let bundleId = "io.screenshotbot.swift-snapshot-testing-example"
let deploymentTargets: DeploymentTargets = .iOS("17.0")

/// Test targets that capture screenshots.
///
/// They're tagged `screenshotbot` and they reach `SnapshotTesting` only through
/// the `SnapshotSupport` framework — the transitive shape a real multi-module
/// app has, and the reason anything classifying these targets has to walk the
/// dependency graph rather than look for a direct edge.
let snapshotTestTargets = [
    "InboxSnapshotTests",
    "ThreadSnapshotTests",
    "BubbleSnapshotTests",
    "ComponentsSnapshotTests",
    "OnboardingSnapshotTests",
]

/// Test targets that capture nothing. No tag, no snapshot dependency — these
/// are the ones selective testing can skip with no consequence for any channel.
let plainTestTargets = [
    "ChatModelsTests",
    "ChatClockTests",
    "SampleDataTests",
    "StringsTests",
    "PaletteTests",
]

func testTarget(_ name: String, snapshots: Bool) -> Target {
    .target(
        name: name,
        destinations: .iOS,
        product: .unitTests,
        bundleId: "\(bundleId).\(name.lowercased())",
        deploymentTargets: deploymentTargets,
        infoPlist: .default,
        sources: ["\(name)/**/*.swift"],
        dependencies: [.target(name: "SimpleProject")]
            + (snapshots ? [.target(name: "SnapshotSupport")] : []),
        metadata: snapshots ? .metadata(tags: ["screenshotbot"]) : .default
    )
}

let project = Project(
    name: "SimpleProject",
    organizationName: "Screenshotbot",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.0",
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": "HQ25CUJ52L",
            "MARKETING_VERSION": "1.0",
            "CURRENT_PROJECT_VERSION": "1",
        ]
    ),
    targets: [
        .target(
            name: "SimpleProject",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIApplicationSupportsIndirectInputEvents": true,
                ]
            ),
            sources: ["SimpleProject/**/*.swift"],
            resources: [
                "SimpleProject/Assets.xcassets",
                "SimpleProject/Preview Content/Preview Assets.xcassets",
            ],
            settings: .settings(
                base: [
                    "ENABLE_PREVIEWS": "YES",
                    "DEVELOPMENT_ASSET_PATHS": "\"SimpleProject/Preview Content\"",
                ]
            )
        ),

        // The snapshot tests. `SnapshotTesting` is resolved by `tuist install`
        // from Tuist/Package.swift, and the snapshots themselves are written
        // next to the test sources in SimpleProjectTests/__Snapshots__.
        .target(
            name: "SimpleProjectTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["SimpleProjectTests/**/*.swift"],
            dependencies: [
                .target(name: "SimpleProject"),
                .external(name: "SnapshotTesting"),
            ]
        ),

        .target(
            name: "SimpleProjectUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "\(bundleId).uitests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["SimpleProjectUITests/**/*.swift"],
            dependencies: [
                .target(name: "SimpleProject")
            ]
        ),

        // Snapshot helpers shared by the per-feature snapshot targets. It links
        // XCTest, hence ENABLE_TESTING_SEARCH_PATHS.
        .target(
            name: "SnapshotSupport",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleId).snapshotsupport",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["SnapshotSupport/**/*.swift"],
            dependencies: [.external(name: "SnapshotTesting")],
            settings: .settings(base: ["ENABLE_TESTING_SEARCH_PATHS": "YES"])
        ),
    ]
        + snapshotTestTargets.map { testTarget($0, snapshots: true) }
        + plainTestTargets.map { testTarget($0, snapshots: false) },
    schemes: [
        // Schemes are part of the manifest, so every clone (and every CI run)
        // gets exactly the same ones — nothing depends on Xcode autocreating
        // them. `AllTests` is the scheme fastlane runs in CI.
        //
        // One scheme covering every unit test target is deliberate: selective
        // testing skips per target *within* a single run, so this is what makes
        // partial skips — some channels uploading, others not — visible.
        .scheme(
            name: "AllTests",
            shared: true,
            buildAction: .buildAction(targets: ["SimpleProjectTests"]
                + snapshotTestTargets.map { .target($0) }
                + plainTestTargets.map { .target($0) }),
            testAction: .targets(
                [.testableTarget(target: "SimpleProjectTests")]
                    + snapshotTestTargets.map { .testableTarget(target: .target($0)) }
                    + plainTestTargets.map { .testableTarget(target: .target($0)) },
                configuration: .debug
            )
        ),

        .scheme(
            name: "SimpleProjectTests",
            shared: true,
            buildAction: .buildAction(targets: ["SimpleProjectTests"]),
            testAction: .targets(
                [.testableTarget(target: "SimpleProjectTests")],
                configuration: .debug
            )
        ),

        // Mirrors the shared scheme the hand-written .xcodeproj used to carry:
        // runs the app, and tests both the snapshot and the UI test bundles.
        .scheme(
            name: "SimpleProject",
            shared: true,
            buildAction: .buildAction(targets: ["SimpleProject"]),
            testAction: .targets(
                [
                    .testableTarget(target: "SimpleProjectTests"),
                    .testableTarget(target: "SimpleProjectUITests"),
                ],
                configuration: .debug
            ),
            runAction: .runAction(configuration: .debug, executable: "SimpleProject"),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release, executable: "SimpleProject"),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ]
)
