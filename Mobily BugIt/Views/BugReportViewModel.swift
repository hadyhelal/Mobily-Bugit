//
//  BugReportViewModel.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import Foundation
import UIKit.UIImage
import Factory

//@MainActor
final class BugReportViewModel: ObservableObject {
    
    @Injected(\.bugReportUploaderManager) private var bugUploaderService
    @Injected(\.googleSignInManager) private var signInManager
    @Injected(\.bugStorageManager) private var bugStorageManager
    
    @Published var bugDescription = ""
    @Published var inputImage: UIImage?
    
    @Published var showSuccessSubmitionDialog = false

    @Published var showingAlert = false
    @Published private(set) var alertMessage = ""
    @Published private(set) var alertTitle   = ""
    @Published private(set) var isLoading    = false
    
    var isSubmitButtonDisabled: Bool {
        bugDescription.isEmpty || inputImage == nil
    }
    
    @MainActor
    func onAppear() {
        signIn()
        getDataFromShare()
    }
    
    @MainActor
    func signIn() {
        Task {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController else {
                return
            }
            await signInManager.signIn(presenting: rootViewController)
        }
    }
    
    func getDataFromShare() {
        Task {
            do {
                let bugs = try bugStorageManager.loadBugs()
                if let bug = bugs.last {
                    bugDescription = bug.description
                    inputImage = UIImage(data: bug.imageData)
                    try bugStorageManager.deleteAll()
                }
            } catch {
                showAlert(title: "Failed", message: "Failed to retrive bug from share.")
            }
        }
    }
    
    @MainActor
    func submitBug() {
        isLoading = true
        guard signInManager.isSignedIn else {
            isLoading = false
            signIn()
            return
        }
        
        guard let inputImage = inputImage, let imageData = inputImage.jpegData(compressionQuality: 0.1) else {
            isLoading = false
            showAlert(title: "Submission Error", message: "No image selected or image data could not be processed.")
            return
        }
        
        Task {
            do {
                try await bugUploaderService.submitBugReport(description: bugDescription, imageData: imageData)
                
                isLoading = false
                resetData()
                
                showSuccessSubmitionDialog = true
            } catch {
                #if DEBUG
                print("Error during submission: \(error)")
                #endif
                
                isLoading = false
                showAlert(title: "Submission Failed", message: "Failed to upload bug report. Please try again.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }
    
    @MainActor
    private func resetData() {
        self.inputImage = nil
        self.bugDescription = ""
    }
    
}
