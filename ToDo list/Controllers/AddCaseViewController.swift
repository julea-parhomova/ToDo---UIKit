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
    
    var presenter = Presenter()
    
    @IBAction func close(_ sender: UIButton) {
        if sender.titleLabel?.text == "Add"{
            presenter.addCase(with: textField.text ?? "")
        }
        if let presentingController = self.presentingViewController as? UITabBarController, let navController = presentingController.selectedViewController as? UINavigationController{
            if let lowerController = navController.viewControllers.first as? ToDoListViewController{
                //я думаю это не лучший вариант
                //но пока не могу придумать другой вариант
                lowerController.presenter = self.presenter
                lowerController.updateTableView()
            } else if let lowerController = navController.viewControllers.first as? ToDoViewController{
                lowerController.presenter = self.presenter
                lowerController.updateTableView()
            }
        }
        presentingViewController?.dismiss(animated: true)
    }
    
}
