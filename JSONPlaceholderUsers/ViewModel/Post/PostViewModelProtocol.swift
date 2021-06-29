//
//  PostViewModelProtocol.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//

import Foundation

protocol PostViewModelProtocol {
    var postsList: [PostRes] { get }
    func getPosts(completion: @escaping(ServiceResult<[PostRes]?>) -> Void)
    func getPostsCount() -> Int?
}
