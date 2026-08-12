// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [:]
    )
#endif

let package = Package(
    name: "SimpleProject",
    dependencies: [
        // Screenshotbot's fork of swift-snapshot-testing. It writes the same
        // `__Snapshots__` directories as upstream, but doesn't fail a test run
        // when a reference image is missing — the comparison happens on
        // Screenshotbot instead of on the CI machine.
        .package(url: "https://github.com/tdrhq/swift-snapshot-testing", branch: "main"),
    ]
)
