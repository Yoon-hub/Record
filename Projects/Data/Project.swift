//
//  Project.swift
//  AppManifests
//
//  Created by 윤제 on 7/23/24.
//

import ProjectDescription

let dataProject = Project(name: "Data", targets: [
    .target(
        name: "Data",
        destinations: .iOS,
        product: .staticLibrary,
        bundleId: "record.Data.com",
        deploymentTargets: .iOS("17.0"),
        sources: ["Sources/**"],
        dependencies: [
            .project(target: "Domain", path: "../Domain"),
            .external(name: "RxKakaoSDKTalk")
        ]
    )
])
