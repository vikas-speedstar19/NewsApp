//
//  NewsModel.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import Foundation

struct NewsModel: Codable {

    // MARK: - Properties

    var source: NewsSourceModel?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?

    // MARK: - Coding

    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }

}
