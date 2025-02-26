//
//  ShareViewModel.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 26/02/2025.
//

import SwiftUI

class ShareViewModel: ObservableObject {
    @Published var description: String = ""
    @Published var inputImage: UIImage? = nil
    @Published var isLoading: Bool = false

    
    init() {

    }
    
    func save() {

    }
}
