//
//  PrimaryButton.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    var disabled: Bool = false
    let action: () -> Void
    var body: some View {
        
            Button {
                action()
            } label: {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(disabled ? Color.disable : Color.primaryBugit)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .disabled(disabled)
            }

    }
}

