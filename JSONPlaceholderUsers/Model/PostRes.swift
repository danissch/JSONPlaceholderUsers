//
//  PostRes.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//

import Foundation

// MARK: - PostResElement
struct PostRes: Codable, Identifiable {
    let userID: Int
    let id: Int
    let title: String
    let body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
}

