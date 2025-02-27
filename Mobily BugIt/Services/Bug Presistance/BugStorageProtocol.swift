//
//  BugStorageProtocol.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

protocol BugStorageProtocol {
    func saveBug(_ bug: Bug) throws
    func loadBugs() async throws -> [Bug]
    func deleteAll() throws
}
