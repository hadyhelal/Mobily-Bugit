//
//  ImgBBResponse.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 28/02/2025.
//

struct ImgBBResponse: Codable {
    let data: ImgBBData?
    let success: Bool?
    let status: Int?
}

struct ImgBBData: Codable {
    let id: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id, url
    }
}
