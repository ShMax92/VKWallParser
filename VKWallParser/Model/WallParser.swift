//
//  WallParser.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 29.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

class WallParser {

    var wallObjects = [WallPost](){
        didSet{
            self.getUsers()
            //NotificationCenter.default.post(name: .wallPostArrayDidUpdate, object: nil)
        }
    }
    var users = [Int:User](){
        didSet{
            NotificationCenter.default.post(name: .userInfoDictionaryDidUpdate, object: nil)
        }
    }
    private let provider = MoyaProvider<VK_API>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    //fetch
    func fetch(api: VK_API){
        provider.request(api){
            (result) in
            switch result {
            case .success (let response):
                switch api {
                case .getWall:
                    self.parseWall(response: response)
                case .getUser:
                    self.parseUser(response: response)
                }
                
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func getUsers(){
        var userSet = Set<Int>()
        var requestString = ""
        for object in self.wallObjects{
            userSet.insert(object.fromId!)
        }
        for id in userSet{
            let stringId = String(id) + ","
            requestString.append(stringId)
        }
        
        self.fetch(api: VK_API.getUser(id: requestString))
    }
    
    //response parsing
    func parseWall (response: Response){
        self.wallObjects.removeAll()
        let json = JSON(response.data)
        let items = json["response"]["items"]
        self.wallObjects = WallPost.jsonParsing(items: items)
    }
    
    func parseUser(response: Response){
        let json = JSON(response.data)
        let items = json["response"]
        let userArray = User.jsonParsing(items: items)
        for user in userArray{
            self.users.updateValue(user, forKey: user.id!)
        }
    }
    
    //TODO: ADD RESPONSE VALIDATION
    //TODO: ADD MORE MEDIA TO SHOW
}

extension Notification.Name{
    static let wallPostArrayDidUpdate = Notification.Name(rawValue: "wallPostArrayDidUpdate")
    static let userInfoDictionaryDidUpdate = Notification.Name(rawValue: "userInfoDictionaryDidUpdate")
    static let couldntGetData = Notification.Name(rawValue: "couldntGetData")
}
