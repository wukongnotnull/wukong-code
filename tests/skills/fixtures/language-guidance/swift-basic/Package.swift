// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LanguageGuidanceFixture",
    products: [
        .library(name: "Fetcher", targets: ["Fetcher"]),
    ],
    targets: [
        .target(name: "Fetcher"),
        .testTarget(name: "FetcherTests", dependencies: ["Fetcher"]),
    ]
)
