//
//  VK_API.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 11.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import Foundation
import Moya

private let SERVICE_TOKEN = "fa4bd42afa4bd42afa4bd42a84fa2ebdb9ffa4bfa4bd42aa1167dfea7ff012bdfb4c89d"
private let CLIENT_ID = "6646163"
private let CLIENT_SECRET = "Z0ioarOzsuJ15BhUV4Og"
private let GRANT_TYPE = "client_credentials"


enum VK_API {
    case getWall(id: Int)
    case getUser(id: String)
}

extension VK_API: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getWall, .getUser:
            return URL(string: "https://api.vk.com/method/")!
        }
    }
    
    var path: String {
        switch self {
        case .getWall:
            return String("wall.get")
        case .getUser:
            return String("users.get")
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWall, .getUser:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getWall(let id):
            return ["owner_id": id, "count": 50,
                    "filter": "all", "extended": 0,
                    "v": 5.52, "access_token": SERVICE_TOKEN, "client_secret": CLIENT_SECRET]
        case .getUser(let id):
            return ["user_ids": id, "fields": "screen_name", "name_case": "nom",
                    "v": 5.52, "access_token": SERVICE_TOKEN, "client_secret": CLIENT_SECRET]
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: self.parameterEncoding)
    }
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var headers: [String : String]? {
        return nil
    }
    
}
