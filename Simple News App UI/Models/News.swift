//
//  News.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 23/06/23.
//

import Foundation

struct News: Decodable {
    var id: Int
    var title: String
    var abstract: String
    var section: String
    var published_date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case abstract
        case section
        case published_date // kalo mau beda bisa diisi valuenya ex case date = "published_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0 // ini makesure supaya nilainya tidak nil jadi pake decodeifpresent
        self.title = try container.decode(String.self, forKey: .title)
        self.abstract = try container.decode(String.self, forKey: .abstract)
        self.section = try container.decode(String.self, forKey: .section)
        self.published_date = try container.decode(Date.self, forKey: .published_date)
        
        // Ini code kalo enum case nya pengen beda
//        let dateString = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd"
//        date = dateFormater.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
    }
    
}
