//
//  APIModel.swift
//  tenLongBookstore
//
//  Created by Henry on 2019/10/4.
//  Copyright © 2019 Henry. All rights reserved.
//

import Foundation

struct BookShelf: Decodable {
    var list: [List]
    
    struct List: Decodable {
        var image: String?
        var sellPrice: String?
        var name: String?
        var link: String?
    }
}

