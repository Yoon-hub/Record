//
//  Project.swift
//  Packages
//
//  Created by 윤제 on 7/8/24.
//

import ProjectDescription

let teamID = "4EHY29FHRR"
let kakaoAppKey = "e65abf7a0c734491e6f2309b53ed71dd"

let project = Project(name: "App", targets: [
    .target(
        name: "App",
        destinations: .iOS,
        product: .app,
        bundleId: "record.app.com",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .extendingDefault(with: [
            "CFBundleDisplayName": .string("토마토"),
            "UILaunchStoryboardName": .string("LaunchScreen.storyboard"),
            "UIApplicationSceneManifest" : .dictionary([
                "UIApplicationSupportsMultipleScenes" : .boolean(false),
                "UISceneConfigurations" : .dictionary([
                    "UIWindowSceneSessionRoleApplication" : .array([
                        .dictionary([
                            "UISceneConfigurationName" : .string("Default Configuration"),
                            "UISceneDelegateClassName" : .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                        ])
                    ])
                ])
            ]),
            "UIUserInterfaceStyle": .string("Light"),
            "NSAppTransportSecurity": .dictionary([
                "NSAllowsArbitraryLoads": .boolean(true)
            ]),
            "LSApplicationQueriesSchemes": .array([
                .string("kakaokompassauth"),  // 카카오톡으로 로그인
                .string("kakaolink"),         // 카카오톡 공유
                .string("kakaoplus")          // 카카오톡 채널
            ]),
            "CFBundleURLTypes": .array([
                .dictionary([
                    "CFBundleURLSchemes": .array([
                        .string("kakao\(kakaoAppKey)")
                    ])
                ])
            ]),
            
        ]),

        sources: ["Sources/**"],
        resources: [
            "Resources/**",
            "../../Tuist/.build/checkouts/kakao-ios-sdk/Sources/KakaoSDKFriendCore/KakaoSDKFriendResources.bundle"
                   ],
        entitlements: .file(path: "App.entitlements"),
        dependencies: [
            .project(target: "Core", path: "../Core"),
            .project(target: "Domain", path: "../Domain"),
            .project(target: "Data", path: "../Data"),
            .xcframework(path: "../../Carthage/Build/FlexLayout.xcframework", status: .optional),
            .external(name: "ReactorKit"),
            .external(name: "PinLayout"),
            .external(name: "RxCocoa"),
            .external(name: "FocusCollectionView"),
            .external(name: "FSCalendar"),
            .external(name: "RxKeyboard"),
            .external(name: "Lottie"),
            .external(name: "FloatingBottomSheet"),
            .target(name: "Widget"),
            .external(name: "RxGesture"),
            .external(name: "RxKakaoSDKTalk"),
        ],
        settings: .settings(
            base: [
                "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamID)
            ]
        )
    ),
    .target(
        name: "AppUnitTest",
        destinations: .iOS,
        product: .unitTests,
        bundleId: "record.app.unitTest",
        deploymentTargets: .iOS("17.0"),
        sources: ["Tests/**"],
        dependencies: [
            .project(target: "App", path: "./")
        ]
    ),
    .target(
        name: "Widget",
        destinations: .iOS,
        product: .appExtension,
        bundleId: "record.app.com.widget",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .extendingDefault(with: [
            "NSExtension": .dictionary([
                "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
            ])
        ]),
        sources: ["Widget/**"],
        entitlements: .file(path: "Widget/Widget.entitlements"),
        dependencies: [
            .project(target: "Domain", path: "../Domain"),
            .project(target: "Core", path: "../Core"),
            .project(target: "Data", path: "../Data"),
    ],
        settings: .settings(
            base: [
                "DEVELOPMENT_TEAM": SettingValue(stringLiteral: teamID)
            ]
        )
    )
])
