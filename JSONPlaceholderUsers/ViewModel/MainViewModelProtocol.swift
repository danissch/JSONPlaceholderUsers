//
//  MainViewModelProtocol.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation

protocol MainViewModelProtocol {
    var usersList: [User] { get }
    var filteredUsersList: [User] { get set }
    var postsList: [Post] { get }
    var dataDidLoaded:(() -> Void)? { get set }
    
    func loadData()
    func usersCount() -> Int
    func filteredUsersCount() -> Int
    func getPostsByUser(userId: Int) -> [Post]
}
