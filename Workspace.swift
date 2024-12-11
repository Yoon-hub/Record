//
//  Workspace.swift
//  Packages
//
//  Created by 윤제 on 7/8/24.
//

import ProjectDescription

let workspace = Workspace(
    name: "Record",
    projects: ["Projects/**"],
    additionalFiles: [
        .glob(pattern: ".gitignore"),
        .glob(pattern: ".mise.toml"),
        .glob(pattern: ".tuist-version"),
        .glob(pattern: "Cartfile"),
        .glob(pattern: "Cartfile.resolved"),
        .glob(pattern: .relativeToRoot("Configurations/**/*.xcconfig")),
    ]
)
