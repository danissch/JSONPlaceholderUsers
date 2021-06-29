//
//  NSObjectExtension.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation

extension NSObject {
    @objc class var stringRepresentation:String {
        let name = String(describing: self)
        return name
    }
}
