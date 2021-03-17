//
//  ToDoTableViewCell.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/14/21.
//

import UIKit

protocol ToDoCellDelegate{
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell)
}

class ToDoTableViewCell: UITableViewCell {
    
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func buttons(_ sender: UIButton) {
        if sender.restorationIdentifier == "doneButton"{
            delegate?.action(for: self, action: .done)
        }else if sender.restorationIdentifier == "deleteButton"{
            delegate?.action(for: self, action: .delete)
        }
    }
    
    enum ActionForCell{
        case delete
        case done
    }
    
}
