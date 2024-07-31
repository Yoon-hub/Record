//
//  Project.swift
//  Packages
//
//  Created by 윤제 on 7/8/24.
//

import ProjectDescription

let project = Project(name: "App", targets: [
    .target(
        name: "App",
        destinations: .iOS,
        product: .app,
        bundleId: "record.app.com",
        deploymentTargets: .iOS("17.0"),
        infoPlist: .extendingDefault(with: [
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
            "UIUserInterfaceStyle": .string("Light")
        ]),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [
            .project(target: "Core", path: "../Core"),
            .project(target: "Domain", path: "../Domain"),
            .project(target: "Data", path: "../Data"),
            .external(name: "ReactorKit"),
            .external(name: "PinLayout"),
            .external(name: "RxCocoa"),
            .external(name: "FocusCollectionView")
        ]
    )
])
