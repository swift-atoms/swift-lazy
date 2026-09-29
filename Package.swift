// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-lazy",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Lazy", targets: ["Lazy"]),

        .library(name: "Lazy Foundation Integration", targets: ["Lazy Foundation Integration"]),
        .library(name: "Lazy Test Support", targets: ["Lazy Test Support"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Lazy",
            dependencies: [
            ],
            path: "Sources/Lazy"
        ),
        
        .target(
            name: "Lazy Foundation Integration",
            dependencies: [
                .target(name: "Lazy"),
            ],
            path: "Sources/Lazy Foundation Integration"
        ),
        .target(
            name: "Lazy Test Support",
            dependencies: [
                .target(name: "Lazy"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Lazy Tests",
            dependencies: [
                .target(name: "Lazy"),
                .target(name: "Lazy Test Support"),
                .target(name: "Lazy Foundation Integration"),
            ],
            path: "Tests/Lazy Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
