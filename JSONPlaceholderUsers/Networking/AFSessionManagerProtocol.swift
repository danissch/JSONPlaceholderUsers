//
//  AFSessionManagerProtocol.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation
import Alamofire

protocol AFSessionManagerProtocol {
    func responseString(_ url:String,
                        method: HTTPMethod,
                        parameters: Parameters?,
                        enconding: ParameterEncoding,
                        completionHandler: @escaping (DataResponse<String>) -> Void)
}
