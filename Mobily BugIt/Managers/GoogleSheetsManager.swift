//
//  GoogleSheetsManager.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//


import Foundation
import GoogleAPIClientForREST_Sheets
import GoogleSignIn

protocol BugReportManagerProtocol {
    func submitBugReport(description: String, imageURL: String) async throws
}

class GoogleSheetsManager: BugReportManagerProtocol {
    
    private let sheetService = GTLRSheetsService()

    func submitBugReport(description: String, imageURL: String) async throws {
        sheetService.apiKey = Constants.apiKey
        sheetService.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        let date = Date().getCurrentDateFormatted(dateFormat: "dd-MM-yy")
        let _ = try await createSheetIfNotExists(spreadsheetId: Constants.sheetID, sheetName: date)
        let _ = try await appendData(spreadsheetId: Constants.sheetID, range: "\(date)!A:B", data: [description, imageURL])
    }
    
    private func createSheetIfNotExists(spreadsheetId: String, sheetName: String) async throws {
        let existingSheets = try await readSheets(spreadsheetId: spreadsheetId)

        if existingSheets.contains(sheetName) { return }

        let addSheetRequest = [
            "addSheet": [
                "properties": [
                    "title": sheetName
                ]
            ]
        ]

        let request = GTLRSheets_BatchUpdateSpreadsheetRequest()
        request.requests = [GTLRSheets_Request(json: addSheetRequest)]

        let query = GTLRSheetsQuery_SpreadsheetsBatchUpdate.query(withObject: request, spreadsheetId: spreadsheetId)

        return try await withCheckedThrowingContinuation { continuation in
            sheetService.executeQuery(query) { (ticket, result, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func appendData(spreadsheetId: String, range: String, data: [String]) async throws {
        let rangeToAppend = GTLRSheets_ValueRange()
        rangeToAppend.values = [data]

        let query = GTLRSheetsQuery_SpreadsheetsValuesAppend.query(withObject: rangeToAppend, spreadsheetId: spreadsheetId, range: range)
        query.valueInputOption = "USER_ENTERED"

        return try await withCheckedThrowingContinuation { continuation in
            sheetService.executeQuery(query) { (ticket, result, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }

    private func readSheets(spreadsheetId: String) async throws -> [String] {
        let query = GTLRSheetsQuery_SpreadsheetsGet.query(withSpreadsheetId: spreadsheetId)

        return try await withCheckedThrowingContinuation { continuation in
            sheetService.executeQuery(query) { (ticket, result, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let result = result as? GTLRSheets_Spreadsheet
                    let sheets = result?.sheets?.compactMap { $0.properties?.title }
                    continuation.resume(returning: sheets ?? [])
                }
            }
        }
    }

}

