//
//  AddCaseViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/15/21.
//

import UIKit
import CoreData

class AddCaseViewController: UIViewController, UITextFieldDelegate {
    
    var container: NSPersistentContainer?
    var presenter = Presenter()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add"{
            if let context = container?.viewContext{
                self.presenter.addAffrairs(text: textField.text ?? "", context: context)
            }
        }
        presentingViewController?.dismiss(animated: true)
    }
    
}
