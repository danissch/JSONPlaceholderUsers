//
//  UserViewModelProtocol.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 25/06/21.
//

import Foundation

protocol UserViewModelProtocol {
    var remoteUserList: [UserRes] { get }
    func getRemoteUsers(completion: @escaping(ServiceResult<[UserRes]?>) -> Void)
    func getRemoteUsersCount() -> Int?
}
