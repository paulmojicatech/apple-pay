// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ApplePay",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ApplePay",
            targets: ["ApplePayPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "ApplePayPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/ApplePayPlugin"),
        .testTarget(
            name: "ApplePayPluginTests",
            dependencies: ["ApplePayPlugin"],
            path: "ios/Tests/ApplePayPluginTests")
    ]
)