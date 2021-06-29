//
//  ResultManagerDelegate.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation

protocol ResultManagerDelegate {
    func onRequestResponse(response:Codable)
}
