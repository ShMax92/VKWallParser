//
//  User.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 10.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {

    var id: Int?
    var firstName: String?
    var lastName: String?

    override init() {
        super.init()
    }
    
    init(id: Int?,
        firstName: String?,
        lastName: String?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static func jsonParsing(items: JSON) -> [User]{
        var userArray = [User]()
        
        for item in items{
            let user = User()
            if let id = item.1["id"].int{
                user.id = id
            }
            if let firstName = item.1["first_name"].string{
                user.firstName = firstName
            }
            if let lastName = item.1["last_name"].string{
                user.lastName = lastName
            }
            userArray.append(user)
        }
        
        return userArray
    }
    
}
