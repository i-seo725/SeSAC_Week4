// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let video = try? JSONDecoder().decode(Video.self, from: jsonData)

import Foundation
import Foundation

// MARK: - Video
struct SearchVideo: Codable {
    let documents: [Document]
    let ds, g: [Int?]
    let m: M
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let author, datetime: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author, datetime
        case playTime = "play_time"
        case thumbnail, title, url
    }
}

// MARK: - M
struct M: Codable {
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
