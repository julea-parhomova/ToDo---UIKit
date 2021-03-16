//
//  ToDoTableViewCell.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/14/21.
//

import UIKit

protocol toDoCellDelegate{
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell)
}

class ToDoTableViewCell: UITableViewCell {
    
    var delegate: toDoCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttons(_ sender: UIButton) {
        //if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(for: self){
        if sender.restorationIdentifier == "doneButton"{
            delegate?.action(for: self, action: .done)
            //delegate?.done(indexPath: indexPath)
        }else if sender.restorationIdentifier == "deleteButton"{
            delegate?.action(for: self, action: .delete)
            //delegate?.delete(indexPath: indexPath)
        }
        //}
    }
    
    enum ActionForCell{
        case delete
        case done
    }
    
}
