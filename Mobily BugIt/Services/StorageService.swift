//
//  StorageService.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import Foundation

protocol StorageService {
    func uploadImage(imageData: Data) async throws -> URL
}
