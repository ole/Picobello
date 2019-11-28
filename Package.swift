// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Picobello",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .executable(name: "picob", targets: ["PicobelloCLI"]),
    .library(name: "Picobello", targets: ["Picobello"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/ole/HexHexHex.git", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "PicobelloCLI",
      dependencies: ["Picobello", "HexHexHex", "SPMUtility"]),
    .target(
      name: "Picobello",
      dependencies: ["HexHexHex"]),
    .testTarget(
      name: "PicobelloTests",
      dependencies: ["Picobello", "HexHexHex"]),
  ]
)
