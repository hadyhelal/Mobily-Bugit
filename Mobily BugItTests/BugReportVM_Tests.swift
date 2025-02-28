//
//  BugReportVM_Tests.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

import XCTest
import Factory
@testable import Mobily_BugIt

// MARK: - Mock Bug Storage Manager
final class MockBugStorageManager: BugStorageProtocol {

    
    var mockBugs: [Bug] = []
    var didDeleteAll = false

    func loadBugs() throws -> [Bug] {
        return mockBugs
    }
    
    func saveBug(_ bug: Bug) throws {
        mockBugs.append(bug)
    }

    func deleteAll() throws {
        didDeleteAll = true
    }
}

// MARK: - Mock Bug Report Uploader
final class MockBugReportUploaderManager: BugReportUploaderManagerProtocol {
    var shouldFail = false

    func submitBugReport(description: String, imageData: Data) async throws {
        if shouldFail { throw NSError(domain: "TestError", code: 1) }
    }
}

// MARK: - Mock Google Sign-In Manager
final class MockGoogleSignInManager: GoogleSignInManagerProtocol {
    var isSignedIn = false
    var didSignIn = false

    func signIn(presenting: UIViewController) async {
        didSignIn = true
        isSignedIn = true
    }
}

final class BugReportViewModelTests: XCTestCase {

    private var viewModel: BugReportViewModel!
    private var mockBugStorageManager: MockBugStorageManager!
    private var mockBugUploaderService: MockBugReportUploaderManager!
    private var mockSignInManager: MockGoogleSignInManager!

    override func setUp() {
        super.setUp()
            mockBugStorageManager = MockBugStorageManager()
            mockBugUploaderService = MockBugReportUploaderManager()
            mockSignInManager = MockGoogleSignInManager()
            
            Container.shared.bugStorageManager.register { self.mockBugStorageManager }
            Container.shared.bugReportUploaderManager.register { self.mockBugUploaderService }
            Container.shared.googleSignInManager.register { self.mockSignInManager }
            
            viewModel = BugReportViewModel()
    }

    override func tearDown() {
        viewModel = nil
        Container.shared.bugStorageManager.reset()
        Container.shared.bugReportUploaderManager.reset()
        Container.shared.googleSignInManager.reset()
        super.tearDown()
    }

    // MARK: - Tests
    @MainActor
    func testInitialState() {
        XCTAssertTrue(viewModel.bugDescription.isEmpty)
        XCTAssertNil(viewModel.inputImage)
        XCTAssertFalse(viewModel.showSuccessSubmitionDialog)
        XCTAssertFalse(viewModel.showingAlert)
        XCTAssertFalse(viewModel.isLoading)
    }

    @MainActor
    func testIsSubmitButtonDisabled() {
        XCTAssertTrue(viewModel.isSubmitButtonDisabled)
        
        viewModel.bugDescription = "Test Bug"
        XCTAssertTrue(viewModel.isSubmitButtonDisabled)
        
        viewModel.inputImage = UIImage()
        XCTAssertFalse(viewModel.isSubmitButtonDisabled)
    }

    func testSignInCallsSignInManager() async {
        await viewModel.signIn()
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertTrue(mockSignInManager.didSignIn)
    }

    func testSubmitBug_FailsWhenNotSignedIn() async{
        viewModel.bugDescription = "Bug Report"
        viewModel.inputImage = UIImage()

        mockSignInManager.isSignedIn = false

        await viewModel.submitBug()
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(mockSignInManager.didSignIn) // Should trigger sign-in
    }

    func testSubmitBug_FailsWithError() async {
        viewModel.bugDescription = "Bug Report"
        viewModel.inputImage = UIImage()
        
        mockSignInManager.isSignedIn = true
        mockBugUploaderService.shouldFail = true

        await viewModel.submitBug()
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showingAlert)
        XCTAssertEqual(viewModel.alertTitle, "Submission Error")
    }
}
