// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "FoldingCell",
    // platforms: [.iOS("8.0")],
    products: [
        .library(name: "FoldingCell", targets: ["FoldingCell"])
    ],
    targets: [
        .target(
            name: "FoldingCell",
            path: "FoldingCell/FoldingCell"
        )
    ]
)
