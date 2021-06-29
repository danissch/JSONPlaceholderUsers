//
//  ResultManager.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 27/06/21.
//

import Foundation

class ResultManager<T:Codable>{
    var delegate: ResultManagerDelegate?
    var functionName:String
    var result: ServiceResult<String?>
    var completion: (ServiceResult<T?>) -> Void
    
    init(delegate: ResultManagerDelegate,
         functionName: String,
         result: ServiceResult<String?>,
         completion: @escaping (ServiceResult<T?>) -> Void) {
        self.delegate = delegate
        self.functionName = functionName
        self.result = result
        self.completion = completion
        resultHandler()
    }
    
    func resultHandler(){
        switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        delegate?.onRequestResponse(response: response)
                        return completion(.Success(response, statusCode ))
                    }
                    return completion(.Error("\(functionName) Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return completion(.Error("\(functionName) Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                print("case .Error :: \(functionName)")
                return completion(.Error(message, statusCode))
        }
        
    }
    
}
