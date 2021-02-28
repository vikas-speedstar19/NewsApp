//
//  NewsResponseModel.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import Foundation

struct NewsResponseModel: Codable {

    // MARK: - Properties

    var status: String?
    var totalResults: Int?
    var articles: [NewsModel]?

    // MARK: - Coding

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalResults = "totalResults"
        case articles = "articles"
    }
    
}
