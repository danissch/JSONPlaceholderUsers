//
//  CompanyCD.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation

public class CompanyCD: NSObject, NSCoding {
    public var company: Company
    
    enum Key: String {
        case company = "company"
    }
    
    init(company: Company) {
        self.company = company
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(company, forKey: Key.company.rawValue )
    }
    
    public required convenience init?(coder aCoder: NSCoder) {
        let mCompany = aCoder.decodeObject(forKey: Key.company.rawValue) as! Company
        self.init(company: mCompany)
    }
    
    
}
