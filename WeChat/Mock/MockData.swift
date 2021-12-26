//
//  MockData.swift
//  WeChat
//
//  Created by Sun on 2021/12/26.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import Foundation
import CoreGraphics

struct MockData: Codable {
    
    enum Gender: String, Codable {
        case male = "M"
        case female = "F"
    }
    
    struct User: Codable {
        
        let identifier: String
        
        let name: String
        
        let name_en: String
        
        let family: String
        
        let avatar: URL?
        
        let gender: Gender
        
        let country: String
        
        let wxid: String
    }
    
    struct Image: Codable {
        let url: URL?
        let middle_url: URL?
        let size: ImageSize
    }
    
    struct ImageSize: Codable {
        
        let width: CGFloat
        
        let height: CGFloat
        
        var value: CGSize {
            return CGSize(width: width, height: height)
        }
    }
    
    struct WebPage: Codable {
        
        var url: URL?
        
        var title: String
        
        var thumb_url: URL?
    }
    
    let users: [User]
    
    let images: [Image]
    
    let webpages: [WebPage]
    
    var messages: [String]
}
