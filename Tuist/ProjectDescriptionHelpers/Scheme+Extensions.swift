//
//  Scheme+Extensions.swift
//  Packages
//
//  Created by 윤제 on 12/11/24.
//

import ProjectDescription

public extension Scheme {
    
    /// Sever(Real & Develop)
    public static func toServerScheme(
        targetName: String
    ) -> [Scheme] {
        
        // TargetReference 만들기
        let targets = [targetName]
            .map { return TargetReference(stringLiteral: $0) }
        
        // Scheme Name
        let productionServerSchemeName = targetName
        let developmentServerSchemeName = "\(targetName) (develop)"
        
        // Scheme
        
        /// 운영기 Scheme
        let producitonServerScheme = Scheme.scheme(
            name: productionServerSchemeName,
            shared: true,
            hidden: false,
            buildAction: BuildAction.buildAction(targets: targets),
            runAction: .runAction(configuration: .production,
                                  arguments: .arguments(
                                      environmentVariables: [
                                          "IDELogRedirectionPolicy": EnvironmentVariable.environmentVariable(value: "oslogToStdio", isEnabled: true),
                                      ]
                                  )
                                 ),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .production)
        )
        
        /// 개발기 Scheme
        let developmentServerScheme = Scheme.scheme(
            name: developmentServerSchemeName,
            shared: true,
            hidden: false,
            buildAction: BuildAction.buildAction(targets: targets),
            runAction: .runAction(configuration: .develop,
                                  arguments: .arguments(
                                  environmentVariables: ["IDELogRedirectionPolicy": EnvironmentVariable.environmentVariable(value: "oslogToStdio", isEnabled: true)]
                                  )
                                 ),
            archiveAction: .archiveAction(configuration: .develop),
            profileAction: .profileAction(configuration: .develop),
            analyzeAction: .analyzeAction(configuration: .develop)
        )
        
        return [producitonServerScheme, developmentServerScheme]
    }
}
