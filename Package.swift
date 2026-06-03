// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevelopKit",
    products: [
		/// 只做聚合不放具体实现
        .library(name: "DevelopKit", targets: ["DevelopKit"]),
		.library(name: "DevelopFoundation", targets: ["DevelopFoundation"]),
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
					"SnapKit",
				]
        ),
		.target(name: "DevelopFoundation"),
		// MARK: - 下面都是测试Target
		.testTarget(name: "DevelopKitTests", dependencies: ["DevelopKit"]),
		.testTarget(name: "DevelopFoundationTests", dependencies: ["DevelopFoundation"]),
    ],
    swiftLanguageModes: [.v6]
)
