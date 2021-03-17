//
//  ToDoData.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/15/21.
//

import UIKit

class ToDoData: UIDocument {

    var toDoList: ToDoModel?
    
    override func contents(forType typeName: String) throws -> Any {
        return toDoList?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data{
            toDoList = ToDoModel(json: json)
        }
    }
    
}
