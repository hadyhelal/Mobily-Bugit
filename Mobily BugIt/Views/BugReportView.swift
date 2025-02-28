//
//  ContentView.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 26/02/2025.
//

import SwiftUI

struct BugReportView: View {
    
    @StateObject private var viewModel = BugReportViewModel()
    
    private let notificationCenter = NotificationCenter.default
    @FocusState private var isDescriptionFieldFocused: Bool
    @State private var showingImagePicker = false
    
    var body: some View {
        
        ZStack {
            
            Color.white
            
            VStack(spacing: .zero) {

                headerView
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        bugImageView

                        pickScreenshotButton
                        
                        bugDescriptionTextView
                        
                        Spacer(minLength: 0)
                        
                        submitBugButton
                        
                    }
                    .padding(.top)
                }
            }
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.inputImage)
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear { viewModel.onAppear() }
            .onReceive(notificationCenter.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.getDataFromShare()
            }
            
            if viewModel.isLoading {
                loadingOverlay
            }
            
            if viewModel.showSuccessSubmitionDialog {
                BugSubmittedDialogView(isPresented: $viewModel.showSuccessSubmitionDialog, title: "Bug report has been submitted successfully!")
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }

    }
    
    private var headerView: some View {
        Image(.topBanner)
            .resizable()
            .frame(height: 200)
    }
    
    private var bugImageView: some View {
        Group {
            if let inputImage = viewModel.inputImage {
                Image(uiImage: inputImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(.screenshotPlaceholder)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        showImagePicker()
                    }
            }
        }
        .frame(width: 100, height: 250)
    }
    
    private var pickScreenshotButton: some View {
        SecondaryButton(title: "Pick Screenshot") {
            showImagePicker()
        }
        .frame(width: 173)
    }
    
    private var bugDescriptionTextView: some View {
        ZStack(alignment: .topLeading) {
            
            TextEditor(text: $viewModel.bugDescription)
                .foregroundStyle(Color.black.opacity(0.8))
                .padding(4)
                .focused($isDescriptionFieldFocused)
            
            if viewModel.bugDescription.isEmpty {
                Text("Say something about this bug...")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
        }
        .font(.callout)
        .frame(height: 120)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 0.3)
        }
        .padding()
    }
    
    private var submitBugButton: some View {
        PrimaryButton(title: "Submit Bug Review", disabled: viewModel.isSubmitButtonDisabled) {
            isDescriptionFieldFocused = false
            viewModel.submitBug()
        }
        .padding(.horizontal)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            DotLoader()
        }
    }
    
    private func showImagePicker() {
        isDescriptionFieldFocused = false
        showingImagePicker = true
    }
}

#Preview {
    BugReportView()
}
