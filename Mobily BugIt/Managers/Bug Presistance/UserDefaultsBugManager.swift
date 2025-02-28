//
//  UserDefaultsBugManager.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import Foundation

final class UserDefaultsBugManager: BugStorageProtocol {
    
    private let userDefaults = UserDefaults.init(suiteName: "group.mobily.bugit")
    private let bugsKey = "savedBugs"
    
    func saveBug(_ bug: Bug) throws {
        var savedBugs = loadBugs()
        savedBugs.append(bug)
        let encodedBugs = try JSONEncoder().encode(savedBugs)
        userDefaults?.set(encodedBugs, forKey: bugsKey)
    }
    
    func loadBugs() -> [Bug] {
        guard let data = userDefaults?.data(forKey: bugsKey),
              let bugs = try? JSONDecoder().decode([Bug].self, from: data) else {
            return []
        }
        return bugs
    }
    
    func deleteAll() throws {
        userDefaults?.set([], forKey: bugsKey)
    }
}

