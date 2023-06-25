//
//  NewsProvider.swift
//  Simple News App UI
//
//  Created by Erlangga Ardiansyah on 23/06/23.
//

import Foundation
import Alamofire

class NewsProvider {
    static let share: NewsProvider = NewsProvider()
    private init() { }
    
    func loadTopNews() {
        AF.request("https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json",
                   method: .get,
                   parameters: ["api-key": "89AHP2A6VzmE376ZGzG18GX7PJVxJLxy"])
        .responseData { dataResponse in
            if let data = dataResponse.data {
                do {
                    let response = try JSONDecoder().decode(TopNewsResponse.self, from: data)
                }
                catch {
                    
                }
               
            }
        }
    }
}
