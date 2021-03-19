//
//  Presenter.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/17/21.
//

import Foundation

protocol PresenterDelegate: class{
    func updateTableView()
}

class Presenter{
    
    //нужно ли их полностью скрывать?
    private(set) var model: ToDoModel
    private(set) var document: ToDoData?
    
    weak var delegate: PresenterDelegate?
    
    var done: [ToDoModel.ToDoInfo]{
        return model.toDoList.filter{$0.isDone}
    }
    
    var toDo: [ToDoModel.ToDoInfo]{
        return model.toDoList.filter{!$0.isDone}
    }
    
    init() {
        model = ToDoModel()
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("ToDoList.json"){
            document = ToDoData(fileURL: url)
        }
        document?.open{success in
            if success{
                self.model = self.document?.toDoList ?? ToDoModel()
                self.delegate?.updateTableView()
            }
        }
    }
    
    private var allNames: [String]{
        var names = [String]()
        for toDoInfo in model.toDoList{
            names.append(toDoInfo.thingToDo)
        }
        return names
    }
    
    func addCase(with text: String){
        if allNames.contains(text) == false{
            model.toDoList.append(ToDoModel.ToDoInfo(thingToDo: text))
        }
        saveDocument()
    }
    
    func removeAll(){
        model.toDoList.removeAll()
        delegate?.updateTableView()
        saveDocument()
    }
    
    func removetoDo(){
        var index = model.toDoList.firstIndex{!$0.isDone}
        while index != nil{
            model.toDoList.remove(at: index!)
            index = model.toDoList.firstIndex{!$0.isDone}
        }
        delegate?.updateTableView()
        saveDocument()
    }
    
    func removeDone(){
        var index = model.toDoList.firstIndex{$0.isDone}
        while index != nil{
            model.toDoList.remove(at: index!)
            index = model.toDoList.firstIndex{$0.isDone}
        }
        delegate?.updateTableView()
        saveDocument()
    }
    
    func doneAll(){
        for index in model.toDoList.indices{
            model.toDoList[index].isDone = true
        }
        delegate?.updateTableView()
        saveDocument()
    }
    
    func actionWithCell(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell){
        let text = cell.label.text
        var index = 0
        while model.toDoList[index].thingToDo != text {
            index += 1
        }
        switch action{
        case .done: model.toDoList[index].isDone = !model.toDoList[index].isDone
        case .delete: model.toDoList.remove(at: index)
        }
        saveDocument()
        delegate?.updateTableView()
    }
    
    func close(){
        saveDocument()
        document?.close()
    }
    
    private func saveDocument(){
        document?.toDoList = model
        document?.updateChangeCount(.done)
    }
}
