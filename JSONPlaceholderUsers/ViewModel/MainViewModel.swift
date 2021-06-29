//
//  MainViewModel.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation

class MainViewModel: MainViewModelProtocol {
    private var privUsersList = [User]()
    var usersList: [User] {
        get { return privUsersList.sorted(by: { $0.id < $1.id }) }
    }
    private var privFilteredUsersList = [User]()
    var filteredUsersList: [User] {
        get { return privFilteredUsersList }
        set { privFilteredUsersList = newValue }
    }
    private var privPostsList = [Post]()
    var postsList: [Post] {
        get { return privPostsList }
    }
    var dataDidLoaded:(() -> Void)?
    
    func loadData() {
        _ = MainViewModelFacade(delegate: self)
    }
    
    func usersCount() -> Int {
        return usersList.count
    }
    
    func filteredUsersCount() -> Int {
        return filteredUsersList.count
    }
    
    func postsCount() -> Int {
        return postsList.count
    }
    
    func getPostsByUser(userId: Int) -> [Post]{
        return self.postsList.filter({$0.userId == userId })
    }
    
}

extension MainViewModel: MainViewModelFacadeDelegate {
    func onDataLoaded(users: [User], posts: [Post]) {
        self.privUsersList = users
        self.privPostsList = posts
        self.dataDidLoaded?()
    }
}
