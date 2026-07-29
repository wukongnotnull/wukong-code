// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftWorker",
    products: [
        .library(name: "Worker", targets: ["Worker"]),
    ],
    targets: [
        .target(name: "Worker"),
    ]
)
