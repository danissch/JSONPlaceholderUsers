//
//  AddressCD.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation
public class AddressCD: NSObject, NSCoding {
    public var address: Address
    
    enum Key:String {
        case address = "address"
    }
    
    init(address: Address) {
        self.address = address
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(address, forKey: Key.address.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mAddress = aDecoder.decodeObject(forKey: Key.address.rawValue) as! Address
        self.init(address: mAddress)
    }
    
}
