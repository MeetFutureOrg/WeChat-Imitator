//
//  Contact.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import ObjectMapper
import Contacts

struct Contact: Mappable {

    var id: String?
    var name: String?
    var phones: [String] = []

    init?(map: Map) {}
    init() {}

    init(_ contact: CNContact) {
        id = contact.identifier
        name = [contact.givenName, contact.familyName].joined(separator: " ")
        phones = contact.phoneNumbers.map { $0.value.stringValue }
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        phones <- map["phones"]
        name <- map["name"]
    }
}
