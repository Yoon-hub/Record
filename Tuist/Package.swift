// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: ["FSCalendar": .framework]
    )
#endif

let package = Package(
    name: "App",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.5"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.7.1"),
        .package(url: "https://github.com/Yoon-hub/FocusCollectionView.git", from: "1.1.1"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", exact: "2.8.4"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.8.1"),
        .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git", exact: "6.1.2"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", exact: "2.0.1"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "4.5.0"),
        .package(url: "https://github.com/Yoon-hub/FloatingBottomSheet.git", branch: "main")
    ]
)
