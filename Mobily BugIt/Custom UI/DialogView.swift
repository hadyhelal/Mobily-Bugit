//
//  DialogView.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import SwiftUI

struct DialogView<Content: View>: View {
    @Binding var isActive: Bool

    let content: () -> Content
    
    init(isActive: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isActive = isActive
        self.content = content
    }
    
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    @State private var dialogOpacity: CGFloat = 1
    var body: some View {
        ZStack {

            backgroundView
            
            content()
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: isActive) { _, newIsActive in
            presentDialog(newIsActive)
        }
    }
    
    private func presentDialog(_ present: Bool) {
        withAnimation(.spring()) {
            offset = present ? 0 : UIScreen.main.bounds.height
        }
    }
    
    private var backgroundView: some View {
        Color(.black)
            .opacity(isActive ? 0.5 : 0)
            .onTapGesture {
                isActive = false
            }
    }
}
