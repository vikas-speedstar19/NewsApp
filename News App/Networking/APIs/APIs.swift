//
//  APIs.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import Foundation
import Alamofire

class APIs {

    static func getNews(country: String = "in",
                          pageSize: Int,
                          pageNumber: Int,
                          completion: @escaping (NewsResponseModel?) -> (Void)) {
        let apiKey = "6debf1ea73cd4ada9ad3e26a0bd3e80a"
        let api = "https://newsapi.org/v2/top-headlines?country=\(country)&pageSize=\(pageSize)&page=\(pageNumber)&apiKey=6debf1ea73cd4ada9ad3e26a0bd3e80a"
        AF.request(api).responseDecodable {
            (response: DataResponse<NewsResponseModel, AFError>) in
            let result = response.result
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

}
