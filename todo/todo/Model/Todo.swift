//
//  Todo.swift
//  todo
//
//  Created by hax0r-MBP on 8/16/19.
//  Copyright © 2019 Devslopes. All rights reserved.
//

import Foundation

struct Todos: Codable {
    let items: Array<Todo>
}

struct Todo: Codable {
    let item: String
    let priority: Int
}
