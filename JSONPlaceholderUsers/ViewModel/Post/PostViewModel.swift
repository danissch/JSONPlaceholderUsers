//
//  PostViewModel.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//

import Foundation

class PostViewModel: PostViewModelProtocol {
    
    private var privPostsList = [PostRes]()
    var postsList: [PostRes] {
        get {
            return privPostsList
        }
    }
    var networkService: NetworkServiceProtocol?

    func getPosts(completion: @escaping (ServiceResult<[PostRes]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        networkService.request(url: MainConfiguration.shared.urlGetPosts,
                               method: .get,
                               parameters: nil) { (result) in
            _ = ResultManager.init(delegate: self, functionName: #function, result: result, completion: completion)
        }
    }
    
    func getPostsCount() -> Int? {
        return postsList.count
    }
}

extension PostViewModel: ResultManagerDelegate {
    func onRequestResponse(response: Codable) {
        self.privPostsList = response as! [PostRes]
    }
}

