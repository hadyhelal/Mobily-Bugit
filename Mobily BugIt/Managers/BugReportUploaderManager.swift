//
//  BugReportUploaderService.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import Foundation
import Factory

protocol BugReportUploaderManagerProtocol {
    func submitBugReport(description: String, imageData: Data) async throws
}

class BugReportUploaderManager: BugReportUploaderManagerProtocol {
  
    @Injected(\.storageService) private var storageService
    @Injected(\.reporContainerManager) private var bugReportService
    
    func submitBugReport(description: String, imageData: Data) async throws {
        let imageURL = try await storageService.uploadImage(imageData: imageData)
        try await bugReportService.submitBugReport(description: description, imageURL: imageURL.absoluteString)
    }
}
