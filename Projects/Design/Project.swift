//
//  Project.swift
//  AppManifests
//
//  Created by 윤제 on 7/12/24.
//

import ProjectDescription

let coreProject = Project(name: "Design", targets: [
    .target(
        name: "Design",
        destinations: .iOS,
        product: .framework,
        bundleId: "record.Design.com",
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        dependencies: [
            
        ]
    )
])
