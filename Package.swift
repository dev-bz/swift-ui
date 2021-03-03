// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
  name: "swift",
  products: [.library(name: "jui", type: .dynamic, targets: ["sample"]), .executable(name: "main", targets: ["main"])],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(name: "libs", path: "lib")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    //.target(name: "sf", dependencies: [.product(name: "show", package: "libs"), .product(name: "dep", package: "libs")]),
    //.target(name: "cc", dependencies: [.product(name: "show", package: "libs"), .product(name: "dep", package: "libs")]),
    .target(name: "main", dependencies: [.product(name: "utils", package: "libs")]),
    .target(
      name: "sample",
      dependencies: [
        .product(name: "SwiftUI", package: "libs")
        //  .product(name: "swift", package: "libs"),
        // .product(name: "show", package: "libs"),
      ]
    ),
    //.testTarget(name: "swTests", dependencies: ["sw"]),
  ]
)
for t in package.targets { t.swiftSettings = [.unsafeFlags(["-I", "\(String(cString: getenv("TMPDIR")))/s.build/release"])] }
print(CommandLine.arguments)
//let encoder = JSONEncoder()
//print(String(data: try! encoder.encode(package), encoding: .utf8)!)
