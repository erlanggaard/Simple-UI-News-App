//
//  News.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 23/06/23.
//

import Foundation

struct News: Decodable {
    let id: Int
    let title: String
    let abstract: String
    let section: String
    let published_date: Date
    let media: [Media]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case abstract
        case section
        case published_date // kalo mau beda bisa diisi valuenya ex: date = "published_date"
        case media
    }
    
    // constructor news
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0 // ini makesure supaya nilainya tidak nil jadi pake decodeifpresent
        self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.abstract = try values.decodeIfPresent(String.self, forKey: .abstract) ?? ""
        self.section = try values.decodeIfPresent(String.self, forKey: .section) ?? ""
        
        let dateString = try values.decodeIfPresent(String.self, forKey: .published_date) ?? ""
        self.published_date = dateString.date(format: .date) ?? Date(timeIntervalSince1970: 0)
        media = try values.decodeIfPresent([Media].self, forKey: .media) ?? []
        
        // Ini code kalo enum case nya pengen beda
//        let dateString = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd"
//        date = dateFormater.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
    }
    
}

// MARK EXTENSION FOR DATE TO STRING
enum DateFormat: String {
    case date = "yyyy-MM-dd"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
}

extension String {
    func date(format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
}
