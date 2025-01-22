//
//  Project.swift
//  AppManifests
//
//  Created by 윤제 on 7/23/24.
//

import ProjectDescription

let domainProject = Project(name: "Domain", targets: [
    .target(
        name: "Domain",
        destinations: .iOS,
        product: .staticLibrary,
        bundleId: "record.Domain.com",
        deploymentTargets: .iOS("17.0"),
        sources: ["Sources/**"],
        dependencies: [
            .project(target: "Core", path: "../Core"),
            .external(name: "RxKakaoSDKTalk")
        ]
    )
])
