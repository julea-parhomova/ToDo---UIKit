//
//  ToDoModel.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/15/21.
//

import Foundation

struct ToDoModel: Codable{
    var toDoList = [ToDoInfo]()
    
    struct ToDoInfo: Codable {
        var thingToDo: String
        var isDone: Bool = false
    }
    
    var json: Data?{
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data){
        let decoder = JSONDecoder()
        if let newValue = try? decoder.decode(ToDoModel.self, from: json){
            self = newValue
        }else{
            return nil
        }
    }
    
    init(){
    }
    
}
