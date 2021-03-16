//
//  AddCaseViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/15/21.
//

import UIKit

class AddCaseViewController: UIViewController, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    
    var addCase: ((String) -> Void)?
    
    @IBAction func close(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add"{
            addCase?(textField.text ?? "")
        }
        presentingViewController?.dismiss(animated: true)
    }
    
}
