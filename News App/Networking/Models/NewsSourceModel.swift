//
//  NewsSourceModel.swift
//  News App
//
//  Created by monty on 27/02/21.
//

import Foundation

struct NewsSourceModel: Codable {

    // MARK: - Properties

    var id: String?
    var name: String?

    // MARK: - Coding

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

}
