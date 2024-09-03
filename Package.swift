// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Bidon",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(name: "Bidon", targets: ["Bidon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.1.8"),
    ],
    targets: [
        .target(
            name: "Bidon",
            dependencies: ["Lottie"]
        ),
    ]
)
