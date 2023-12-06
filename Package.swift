// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Risk",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Risk",
            targets: ["Risk"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/fingerprintjs/fingerprintjs-pro-ios",
            .exact("2.2.0")
        ),
        .package(
            url: "https://github.com/checkout/checkout-event-logger-ios-framework.git",
            from: "1.2.4"
        )
    ],
    targets: [
        .target(
            name: "Risk",
            dependencies: [
                .product(name: "CheckoutEventLoggerKit",
                         package: "checkout-event-logger-ios-framework"),
                .product(
                    name: "FingerprintPro",
                    package: "fingerprintjs-pro-ios")
            ],
            path: "Sources"),
        .testTarget(
            name: "RiskTests",
            dependencies: ["Risk"])
    ],
    swiftLanguageVersions: [.v5]
)
