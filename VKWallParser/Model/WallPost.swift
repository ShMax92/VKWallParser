//
//  WallPost.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 10.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import Foundation
import SwiftyJSON

class WallPost: NSObject {

    var id: Int?
    var ownerId: Int?
    var fromId: Int?
    var date: Int?
    var text: String?
    var commentsCount: Int?
    var likesCount: Int?
    var photos: [String]?
    
    override init() {
        super.init()
    }
    
    init(id: Int?,
                  ownerId: Int?,
                  fromId: Int?,
                  date: Int?,
                  text: String?,
                  commentsCount: Int?,
                  likesCount: Int?){
    
        self.id = id
        self.ownerId = ownerId
        self.fromId = fromId
        self.date = date
        self.text = text
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.photos = [String]()
    }
    
    static func jsonParsing(items: JSON) -> [WallPost]{
        var wallPostArray = Array<WallPost>()
        
        for item in items {
            let wallPost = WallPost()
            if let id = item.1["id"].int{
                wallPost.id = id
            }
            if let ownerId = item.1["owner_id"].int{
                wallPost.ownerId = ownerId
            }
            if let fromId = item.1["from_id"].int{
                wallPost.fromId = fromId
            }
            if let date = item.1["date"].int{
                wallPost.date = date
            }
            if let text = item.1["text"].string{
                wallPost.text = text
            }
            if let commentsCount = item.1["comments"]["count"].int{
                wallPost.commentsCount = commentsCount
            }
            if let likesCount = item.1["likes"]["count"].int{
                wallPost.likesCount = likesCount
            }
            
            wallPost.photos = getPhotos(item: item)
            
            wallPostArray.append(wallPost)
        }
        
        return wallPostArray
    }
    
    static func getPhotos(item: (String,JSON)) -> [String]{
        var photos = [String]()
        
        if let attachments = item.1["attachments"].array{
            for attachment in attachments{
                switch attachment["type"].stringValue{
                case "photo":
                    let value = attachment["photo"]["photo_130"].stringValue
                    photos.append(value)
                default:
                    continue
                }
            }
        }
        return photos
    }
}
