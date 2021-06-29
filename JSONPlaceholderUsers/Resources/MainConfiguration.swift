//
//  MainConfiguration.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 26/06/21.
//

import Foundation

class MainConfiguration {
    static let shared = MainConfiguration()
    
    private var urlBase: String = ""
    var urlGetUsers: String = ""
    var urlGetPosts: String = ""
    var urlGetPostsByUser: String = ""
    
    func readPropertyList(){
        var format = PropertyListSerialization.PropertyListFormat.xml //format of the property list
            var plistData:[String : AnyObject] = [:]  //our data
        let plistPath:String? = Bundle.main.path(forResource: "config", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do { //convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                   options: .mutableContainersAndLeaves,
                                                                   format: &format) as! [String:AnyObject]
             
            urlBase = plistData["URL_BASE"] as! String
            urlGetUsers = "\(urlBase)\(plistData["URL_GET_USERS"] as! String)"
            urlGetPosts = "\(urlBase)\(plistData["URL_GET_POSTS"] as! String)"
            urlGetPostsByUser = "\(urlBase)\(plistData["URL_GET_POST_BYUSER"] as! String)"
            
            
        } catch{
            print("Error reading plist: \(error), format: \(format)")
        }
    }
}
