//
//  Article.swift
//  News App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation
struct Article:Decodable {
    let title:String
    let description:String? //optional for fix bug decodification, because it will fail if there is not match with the field
}
