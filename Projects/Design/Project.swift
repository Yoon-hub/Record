//
//  Project.swift
//  AppManifests
//
//  Created by 윤제 on 7/12/24.
//

@preconcurrency import ProjectDescription

let coreProject = Project(name: "Design", targets: [
    .target(
        name: "Design",
        destinations: .iOS,
        product: .framework,
        bundleId: "record.Design.com",
        deploymentTargets: .iOS("15.0"),
        //sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [
            
        ]
    )
], resourceSynthesizers: [
    .custom(name: "Lottie", parser: .json, extensions: ["lottie"]),
    .custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
    .custom(name: "Fonts", parser: .fonts, extensions: ["ttf", "otf"]),
    .custom(name: "JSON", parser: .json, extensions: ["json"]),
])
