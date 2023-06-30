//
//  Media.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 30/06/23.
//

import Foundation

struct Media: Decodable {
    let type: String
    let mediaMetadata: [MediaMetaData]
    
    enum CodingKeys: String, CodingKey {
        case type
        case mediaMetadata = "media-metadata"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        mediaMetadata = try values.decodeIfPresent([MediaMetaData].self, forKey: .mediaMetadata) ?? []
    }
}

struct MediaMetaData: Decodable {
    let url: String
    let format: String
    let height: Double
    let width: Double
    
    enum CodingKeys: String, CodingKey {
        case url
        case format
        case height
        case width
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.format = try values.decodeIfPresent(String.self, forKey: .format) ?? ""
        self.height = try values.decodeIfPresent(Double.self, forKey: .height) ?? 0
        self.width = try values.decodeIfPresent(Double.self, forKey: .width) ?? 0
    }
}
