//
//  marvel.swift
//  HeroisMarvel
//
//  Created by Eduardo Frederico on 05/02/25.
//  Copyright © 2025 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire
import SwiftHash


class MarvelAPI {
    
    static private let basePath = "https://gateway.marvel.com/v1/public/characters"
    static private let privateKey = "4e908c8df812e37ba7d2bb6442d3f43dbe58de56"
    static private let publicKey = "6d515f2e9556fab6b141d0fec549305a"
    static private let limit = 50
    
    private init() {}
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        } else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data, let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                  marvelInfo.code == 200 else {
                onComplete(nil)
                return
            }
            onComplete(marvelInfo)
        }
    }
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
}
