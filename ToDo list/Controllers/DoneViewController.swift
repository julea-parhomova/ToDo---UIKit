//
//  DoneViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/17/21.
//

import UIKit

class DoneViewController: UIViewController{
    
    var presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Done List"
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter = Presenter()
        presenter?.delegate = self
    }
    
    /*override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     presenter.close()
     }*/
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func removeAll(_ sender: UIButton) {
        presenter?.removeDone()
    }
    
}


extension DoneViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.done.count ?? 0
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(36))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        if let toDoCell = cell as? ToDoTableViewCell {
            let text = NSAttributedString(string: presenter!.done[indexPath.item].thingToDo, attributes: [.font: font])
            toDoCell.label.attributedText = text
            toDoCell.label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            toDoCell.delegate = self
        }
        return cell
    }
    
}

extension DoneViewController: ToDoCellDelegate{
    
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell) {
        presenter?.actionWithCell(for: cell, action: action)
    }
    
}

extension DoneViewController: PresenterDelegate{
    
    func updateTableView() {
        table.reloadData()
    }
    
}

