//
//  GoogleSignInManager.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//


import UIKit
import GoogleSignIn

protocol GoogleSignInManagerProtocol {
    var isSignedIn: Bool { get }
    func signIn(presenting viewController: UIViewController) async
}

final class GoogleSignInManager: GoogleSignInManagerProtocol {
    
    var isSignedIn = false

    @MainActor
    func signIn(presenting viewController: UIViewController) async {
        do {
            _ = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            isSignedIn = true
        } catch {
            do {
                _ = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: nil, additionalScopes: Constants.additionalScopes)
                isSignedIn = true
            } catch {
                print("Error with signing in: \(error.localizedDescription)")
                isSignedIn = false
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
    }
}
