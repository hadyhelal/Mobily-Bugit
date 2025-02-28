//
//  ShareViewController.swift
//  Share
//
//  Created by Hady Helal on 26/02/2025.
//

import UIKit
import Social
import SwiftUI

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        if let itemsProviders = (extensionContext?.inputItems.first as? NSExtensionItem)?.attachments {
            let hostView = UIHostingController(rootView: ShareView(itemsProviders: itemsProviders, extensionContext: extensionContext))
            hostView.view.frame = view.frame
            view.addSubview(hostView.view)
        }
    }
    
}

struct ShareView: View {
    var itemsProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
        
    @StateObject private var viewModel = ShareViewModel()
    
    private let extractingQueue = DispatchQueue.global(qos: .userInitiated)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Color.white

                VStack(spacing: .zero) {
                
                    ScrollView {
                        VStack(spacing: 16) {

                            bugImageView

                            bugDescriptionTextView
                                                        
                            VStack(spacing: 8) {
                                submitBugButton
                                
                                cancelOperation
                            }
                            .padding(.horizontal)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.top)
                        .padding(.bottom)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .onAppear() {
                    extractImage(size: geometry.size)
                }
                .background(alignment: .bottomLeading) {
                    Image(.topBanner)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 1.5, height: UIScreen.main.bounds.height * 1.5)
                        .opacity(0.2)
                        .offset(y: -100)
                }

                if viewModel.showSuccessSubmitionDialog {
                    BugSubmittedDialogView(isPresented: $viewModel.showSuccessSubmitionDialog, title: "Your bug has been submitted into the app!") {
                        dismiss()
                    }
                    .offset(y: -200)
                }

            }


        }
    }

    @ViewBuilder
    private var bugImageView: some View {
        if let image = viewModel.inputImage {
            Image(.screenshotEdge)
                .resizable()
                .frame(width: 150, height: 200)
                .scaledToFit()
                .overlay {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .padding(.bottom, 16)
                }
        }
    }
    
    private var bugDescriptionTextView: some View {
        TextField("Enter bug description", text: $viewModel.description)
            .foregroundStyle(Color.black)
            .font(.callout)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.3)
            }
            .padding()

    }
    
    private var submitBugButton: some View {
        PrimaryButton(title: "Save bug into app", disabled: viewModel.isSubmitButtonDisabled) {
            viewModel.save()
        }
    }
    
    private var cancelOperation: some View {
        SecondaryButton(title: "Cancel") {
            dismiss()
        }
    }
        
    private func extractImage(size: CGSize) {
        guard itemsProviders.isEmpty == false else { return }
        extractingQueue.async {
            for item in itemsProviders {
                if let firstTypeIdentifier = item.registeredTypeIdentifiers.first {
                    item.loadItem(forTypeIdentifier: firstTypeIdentifier, options: nil) { (item, error) in
                        if let error = error {
                            print("Error loading item: \(error.localizedDescription)")
                            return
                        }
                        if let image = item as? UIImage {
                            DispatchQueue.main.async {
                                viewModel.inputImage = image
                            }
                        } else if let item = item {
                            if let fileURL = item as? URL {
                                do {
                                    let contentData = try Data(contentsOf: fileURL)
                                    DispatchQueue.main.async {
                                        viewModel.inputImage = UIImage(data: contentData)
                                    }
                                } catch {
                                    print("Error reading file data: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
}

#Preview {
    ShareView(itemsProviders: [])
}

