//
//  Presenter.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/17/21.
//

import Foundation
import CoreData

protocol PresenterDelegate: AnyObject{
    func updateTableView()
}

extension String: Error{}

class Presenter{
    
    weak var delegate: PresenterDelegate?
    
    func elements (for state: Status,context: NSManagedObjectContext) -> [Affairs]{
        let condition = state == .done ? true : (state == .toDo ? false : true)
        let request: NSFetchRequest<Affairs> = Affairs.fetchRequest()
        if state != .all{
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: condition))
        }
        let result = try? context.fetch(request)
        return result ?? []
    }
    
    func removeElements(removeFor state: Status, container: NSPersistentContainer){
        let result = elements(for: state, context: container.viewContext)
        for toDo in result{
            container.viewContext.delete(toDo)
        }
        try? container.viewContext.save()
        delegate?.updateTableView()
    }
    
    func doneAll(container: NSPersistentContainer){
        let request: NSFetchRequest<Affairs> = Affairs.fetchRequest()
        if let result = try? container.viewContext.fetch(request){
            for toDo in result{
                toDo.isDone = true
            }
            try? container.viewContext.save()
            delegate?.updateTableView()
        }
    }
    
    func actionWithCell(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell, container: NSPersistentContainer) throws{
        if let text = cell.label.text{
            let request: NSFetchRequest<Affairs> = Affairs.fetchRequest()
            request.predicate = NSPredicate(format: "text = %@", text)
            if let result = try? container.viewContext.fetch(request){
                if result.count != 1 {
                    throw "More than one result of querying"
                }
                switch action{
                case .done: result.first!.isDone = !result.first!.isDone
                case .delete: container.viewContext.delete(result.first!)
                }
                try? container.viewContext.save()
                delegate?.updateTableView()
            }
        }
    }
    
    func addAffrairs(text: String, context: NSManagedObjectContext){
        let request: NSFetchRequest<Affairs> = Affairs.fetchRequest()
        request.predicate = NSPredicate(format: "text = %@", text)
        let result = try? context.fetch(request)
        if result?.count == 0{
            let affair = Affairs(context: context)
            affair.text = text
            affair.created = Date()
            
            try? context.save()
        }
    }
    
    enum Status{
        case done
        case toDo
        case all
    }
}
