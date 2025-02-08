// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-feature-composer",
    platforms: [.iOS(.v15), .watchOS(.v9), .macOS(.v13)],
    products: [
        .library(
            name: "FeatureComposer",
            targets: [
                "FeatureComposer",
                "FeatureComposerTestingSupport"
            ]
        ),
    ],
    targets: [
        .target(name: "FeatureComposer"),
        .target(name: "FeatureComposerTestingSupport"),
        .testTarget(
            name: "FeatureComposerTests",
            dependencies: [
                "FeatureComposer",
                "FeatureComposerTestingSupport"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
