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
        sources: ["Sources/**"],
        resources: ["Resources/**"]
    )
])
