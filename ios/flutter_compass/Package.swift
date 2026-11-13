// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_compass",
    platforms: [.iOS("12.0")],
    products: [.library(name: "flutter-compass", targets: ["flutter_compass"])],
    dependencies: [.package(name: "FlutterFramework", path: "../FlutterFramework")],
    targets: [
        .target(
            name: "flutter_compass",
            dependencies: [.product(name: "FlutterFramework", package: "FlutterFramework")]
        )
    ]
)
