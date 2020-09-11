//
//  Images.swift
//  Project Y
//
//  Created by Admin on 10.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import Foundation

struct ImagesResults: Decodable {
    let urls: Urls
}

struct Urls: Decodable  {
    let small: String
}
