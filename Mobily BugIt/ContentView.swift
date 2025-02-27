//
//  ContentView.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 26/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var bugDescription = ""
    
    var body: some View {
        
        ZStack {
            
            Color.white
            
            VStack(spacing: .zero) {

                headerView
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        bugImageView

                        pickScreenshotButton
                        
                        bugNoteTextView
                        
                        Spacer(minLength: 0)
                        
                        submitButButton
                        
                    }
                    .padding(.top)
                }
            }
            .ignoresSafeArea(edges: .top)

        }

    }
    
    private var headerView: some View {
        Image(.topBanner)
            .resizable()
            .frame(height: 200)
    }
    
    private var bugImageView: some View {
        Image(.screenshotPlaceholder)
    }
    
    private var pickScreenshotButton: some View {
        Button {
            
        } label: {
            Text("Pick Screenshot")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color.primaryBugit)
                .frame(height: 48)
                .padding(.horizontal)
                .background(Color.secondaryBugit)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
        }
    }
    
    private var bugNoteTextView: some View {
        ZStack(alignment: .topLeading) {
            
            
            
            TextEditor(text: $bugDescription)
                .foregroundStyle(Color.black.opacity(0.8))
                .padding(4)
            
            if bugDescription.isEmpty {
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
    
    private var submitButButton: some View {
        Button {
            
        } label: {
            Text("Submit Bug Review")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.primaryBugit)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                .padding()
        }

    }
    
}

#Preview {
    ContentView()
}
