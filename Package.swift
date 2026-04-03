// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MixpanelAnalyticsKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "MixpanelAnalyticsKit",
            targets: ["MixpanelAnalyticsKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/mixpanel/mixpanel-swift.git", exact: "6.1.0")
    ],
    targets: [
        .target(
            name: "MixpanelAnalyticsKit",
            dependencies: [
                .product(name: "Mixpanel", package: "mixpanel-swift")
            ]
        ),
        .testTarget(
            name: "MixpanelAnalyticsKitTests",
            dependencies: ["MixpanelAnalyticsKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
