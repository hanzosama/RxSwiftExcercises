//
//  Task.swift
//  TodoList
//
//  Created by Jhoan Mauricio Vivas Rubiano on 14/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation

enum TaskPriority: Int{
    case high
    case medium
    case low
}

struct Task {
    let title:String
    let priority:TaskPriority
}
