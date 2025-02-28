//
//  SecondaryButton.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import SwiftUI
struct SecondaryButton: View {
    let title: LocalizedStringKey
    let action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Text(title)
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
