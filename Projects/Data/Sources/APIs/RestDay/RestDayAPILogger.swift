//
//  RestDayAPILogger.swift
//  Data
//
//  Created by Cursor on 4/2/26.
//

import Foundation
import os

enum RestDayAPILogger {
    private static let logger = Logger(subsystem: "record.app.com", category: "RestDayAPI")
    
    static func networkFailure(year: String, month: String, error: Error) {
        logger.error("RestDay network failure year=\(year, privacy: .public) month=\(month, privacy: .public) error=\(String(describing: error), privacy: .public)")
    }
    
    static func decodeFailure(year: String, month: String, error: Error, responsePreview: String?) {
        let preview = (responsePreview.map { String($0.prefix(280)) } ?? "(empty)")
        logger.error("RestDay JSON decode failure year=\(year, privacy: .public) month=\(month, privacy: .public) error=\(error.localizedDescription, privacy: .public) preview=\(preview, privacy: .public)")
    }
    
    static func businessFailure(year: String, month: String, resultCode: String, resultMsg: String) {
        logger.error("RestDay API result error year=\(year, privacy: .public) month=\(month, privacy: .public) resultCode=\(resultCode, privacy: .public) resultMsg=\(resultMsg, privacy: .public)")
    }
}
