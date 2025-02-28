//
//  Dependancies Container.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//


import Factory

extension Container {
    
    var bugStorageManager: Factory<BugStorageProtocol> {
        self { UserDefaultsBugManager() }
    }
    
    var bugReportUploaderManager: Factory<BugReportUploaderManagerProtocol> {
        self { BugReportUploaderManager() }
    }
    
    var storageService: Factory<ImageCloudStorageManagerProtocol> {
        self { ImageCloudStorageManager() }
    }
    
    var reporContainerManager: Factory<BugReportManagerProtocol> {
        self { GoogleSheetsManager() }
    }
    
    var googleSignInManager: Factory<GoogleSignInManagerProtocol> {
        self { GoogleSignInManager() }
    }
    
}
