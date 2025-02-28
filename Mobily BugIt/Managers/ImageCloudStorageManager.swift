//
//  ImageCloudStorageManager.swift
//  Mobily BugIt
//
//  Created by Hady Helal on 27/02/2025.
//

import Foundation

protocol ImageCloudStorageManagerProtocol {
    func uploadImage(imageData: Data) async throws -> URL
}

class ImageCloudStorageManager: ImageCloudStorageManagerProtocol {
    
    private let imgbbApiKey = "cf7c3b59f66b4d53e702734abccf3c19"
    
    func uploadImage(imageData: Data) async throws -> URL {
        let url = try getImageDomainURLFrom()

        let request = getImageRequest(from: url, imageData: imageData)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(ImgBBResponse.self, from: data)

        // Extract Image URL
        guard let imageUrlString = decodedResponse.data?.url, let imageUrl = URL(string: imageUrlString) else {
            throw URLError(.cannotParseResponse)
        }

        return imageUrl
    }
    
    private func getImageDomainURLFrom() throws -> URL {
        let urlString = "https://api.imgbb.com/1/upload?expiration=600&key=\(imgbbApiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    private func getImageRequest(from url: URL, imageData: Data) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let filename = "image.jpg"
        let mimeType = "image/jpeg"

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        return request
    }

}
