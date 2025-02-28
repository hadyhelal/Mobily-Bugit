//
//  UIApplication + Ext.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import UIKit

extension UIApplication {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to: nil, from: nil, for: nil)
    }
}
