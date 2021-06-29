//
//  UserViewModel.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//

import Foundation

class UserViewModel: UserViewModelProtocol {

    private var privRemoteUserList = [UserRes]()
    var remoteUserList: [UserRes] {
        get {
            return privRemoteUserList
        }
    }
    var networkService: NetworkServiceProtocol?
    
    func getRemoteUsers(completion: @escaping (ServiceResult<[UserRes]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        
        networkService.request(url: MainConfiguration.shared.urlGetUsers,
                               method: .get,
                               parameters: nil) { (result) in
            _ = ResultManager(delegate: self, functionName: #function, result: result, completion: completion)
            
        }
    }
    
    func getRemoteUsersCount() -> Int? {
        return remoteUserList.count
    }
    
}

extension UserViewModel: ResultManagerDelegate {
    func onRequestResponse(response: Codable) {
        self.privRemoteUserList = response as! [UserRes]
    }
}
