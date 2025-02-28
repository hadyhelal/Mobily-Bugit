//
//  ShareViewModel.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 26/02/2025.
//

import SwiftUI

class ShareViewModel: ObservableObject {
    @Published var description: String = ""
    @Published var inputImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var showSuccessSubmitionDialog = false

    var bugStorageManager: BugStorageProtocol
    
    var isSubmitButtonDisabled: Bool {
        description.isEmpty || inputImage == nil
    }
    
    init(bugStorageManager: BugStorageProtocol = UserDefaultsBugManager()) {
        self.bugStorageManager = bugStorageManager
    }
    
    func save() {
        if let inputImage = inputImage, let imageData = inputImage.jpegData(compressionQuality: 1) {
            do {
                try bugStorageManager.saveBug(Bug(description: description, imageData: imageData))
                showSuccessSubmitionDialog = true
            } catch {
                print(error)
            }
        }
    }
}

