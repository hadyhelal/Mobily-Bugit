//
//  BugModel.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import SwiftData

@Model
class BugModel {
    @Attribute(.externalStorage)
    var imageData: Data
    
    var desc: String = ""
    
    init(imageData: Data, description: String) {
        self.imageData = imageData
        self.desc = description
    }
}
