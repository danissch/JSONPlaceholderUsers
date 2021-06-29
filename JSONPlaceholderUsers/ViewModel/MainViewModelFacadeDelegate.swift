//
//  MainViewModelFacadeDelegate.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation

protocol MainViewModelFacadeDelegate {
    func onDataLoaded(users:[User], posts: [Post])
}
