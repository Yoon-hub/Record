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
        deploymentTargets: .iOS("15.0"),
        sources: ["Sources/**"],
        dependencies: [
            .external(name: "ReactorKit"),
            .external(name: "RxCocoa"),
            .project(target: "Design", path: "../Design"),
            .external(name: "Alamofire"),
            .external(name: "RxAlamofire")
        ]
    )
])
