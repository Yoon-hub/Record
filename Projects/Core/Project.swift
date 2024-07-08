//
//  Project.swift
//  AppManifests
//
//  Created by 윤제 on 7/8/24.
//

import ProjectDescription

let coreProject = Project(name: "Core", targets: [
    .target(
        name: "Core",
        destinations: .iOS,
        product: .staticLibrary,
        bundleId: "record.Core.com",
        sources: ["Sources/**"]
    )
])
