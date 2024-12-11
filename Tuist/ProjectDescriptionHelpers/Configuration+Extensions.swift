//
//  Configuration+Extensions.swift
//  Packages
//
//  Created by 윤제 on 12/11/24.
//

import ProjectDescription

extension ConfigurationName {
    public static var develop: ConfigurationName = ConfigurationName(stringLiteral: "Develop")
    public static var production: ConfigurationName = ConfigurationName(stringLiteral: "Production")
}

extension Configuration {
    public static var develop: Configuration = .debug(name: .develop, xcconfig: .relativeToRoot("Configurations/Develop.xcconfig"))
    public static var production: Configuration = .debug(name: .production, xcconfig: .relativeToRoot("Configurations/Production.xcconfig"))
}
