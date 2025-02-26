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
    @FocusState private var isDescriptionFieldFocused: Bool
    
    private let extractingQueue = DispatchQueue.global(qos: .userInitiated)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    headerView
                    descriptionTextField
                    imagePreview
                    actionButtons
                    Spacer()
                }
                .padding()
                .onAppear {
                    extractImage(size: geometry.size)
                }
            }
        }
    }
    
    // Header view with title and cancel button
    private var headerView: some View {
        HStack {
            Text("BugIt")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: dismiss) {
                Text("Cancel")
                    .foregroundColor(.blue)
            }
        }
        .padding(.bottom, 16)
    }
    
    // TextField for entering description
    private var descriptionTextField: some View {
        TextField("Enter a description (optional)", text: $viewModel.description)
            .focused($isDescriptionFieldFocused)
            .padding(.vertical, 8)
    }
    
    // Image preview with resizing
    @ViewBuilder
    private var imagePreview: some View {
        if let image = viewModel.inputImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding(.bottom, 16)
        }
    }
    
    
    // Save and cancel buttons
    private var actionButtons: some View {
        HStack {
            Button {
                viewModel.save()
                dismiss()
            } label: {
                Text("Send To App")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
            }
        }
    }
        
    func extractImage(size: CGSize) {
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
    
    // Dismiss the extension context
    private func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
}
