import ProjectDescription

let bundleId = "io.screenshotbot.swift-snapshot-testing-example"
let deploymentTargets: DeploymentTargets = .iOS("17.0")

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
    ],
    schemes: [
        // Schemes are part of the manifest, so every clone (and every CI run)
        // gets exactly the same ones — nothing depends on Xcode autocreating
        // them. `SimpleProjectTests` is the scheme fastlane runs in CI.
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
