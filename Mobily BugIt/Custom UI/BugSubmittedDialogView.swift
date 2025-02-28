//
//  BugSubmittedDialogView.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import SwiftUI

struct BugSubmittedDialogView: View {
    @Binding var isPresented: Bool
    var title: LocalizedStringKey
    var dismissAction: () -> Void = {}

    var body: some View {
        DialogView(isActive: $isPresented) {
            VStack(alignment: .center, spacing: 16) {
                Image(.doneUploading)
                
                Text(title)
                    .font(.title3)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                submitBugButton
                
            }
            .background(Color.white)
        }
    }
    
    private var submitBugButton: some View {
        Button {
            dismissAction()
            isPresented.toggle()
        } label: {
            Text("Close")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color.primaryBugit)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(Color.secondaryBugit)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))

        }

    }

}
