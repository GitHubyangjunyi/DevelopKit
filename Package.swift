// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevelopKit",
    products: [
        .library(name: "DevelopKit", targets: ["DevelopKit"]),
    ],
	dependencies: [
		.package(url: "https://github.com/devxoul/Then", branch: "main"),
		.package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.9.1"),
		.package(url: "https://github.com/SnapKit/SnapKit", exact: "5.7.1"),
		.package(url: "https://github.com/nicklockwood/SwiftFormat", branch: "main"),
	],
    targets: [
        .target(name: "DevelopKit",
				dependencies: [
					"Then",
				]
        ),
        .testTarget(name: "DevelopKitTests", dependencies: ["DevelopKit"]),
    ],
    swiftLanguageModes: [.v6]
)
