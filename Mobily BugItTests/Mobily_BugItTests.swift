//
//  Mobily_BugItTests.swift
//  Mobily BugItTests
//
//  Created by Hady Helal on 26/02/2025.
//

import XCTest
import Factory
@testable import Mobily_BugIt

final class MockPersistent: BugStorageProtocol {
    var bugsCahes = [Bug]()
    
    func saveBug(_ bug: Bug) throws {
        bugsCahes.append(bug)
    }
    
    func loadBugs() throws -> [Bug] {
        return bugsCahes
    }
    
    func deleteAll() throws {
        bugsCahes.removeAll()
    }
}

final class BugLocalStorageTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        
        Container.shared.bugStorageManager.register { MockPersistent() }
    }
    
    override func tearDown() {
        Container.shared.bugStorageManager.reset()
        super.tearDown()
    }
    
    func testSaveBug() async {
        let savedDescription = "testBug"
        let data = Data()
        
        let huntedBug = Bug(description: savedDescription, imageData: data)
        let bugManager = Container.shared.bugStorageManager()
        
        do {
            try bugManager.saveBug(huntedBug)
        } catch {
            print(error)
        }
        
        do {
            let savedBugs = try bugManager.loadBugs()
            if let latestSavedBug = savedBugs.last {
                XCTAssertEqual(latestSavedBug.description, savedDescription)
                XCTAssertEqual(latestSavedBug.imageData, data)
            }
        } catch {
            print(error)
        }
    }
    
}
