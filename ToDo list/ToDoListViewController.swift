//
//  ToDoListViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/10/21.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, toDoCellDelegate {
    
    private var model = ToDoModel()
    private var document: ToDoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("ToDoList.json"){
            document = ToDoData(fileURL: url)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        document?.open{success in
            if success{
                self.model = self.document?.toDoList ?? ToDoModel()
                self.table.reloadData()
            }
        }
    }
    
    //MARK: - cell Delegate
    
    /*func done(indexPath: IndexPath) {
        model.toDoList[indexPath.item].isDone = !model.toDoList[indexPath.item].isDone
        table.reloadData()
        documentSave()
    }
    
    func delete(indexPath: IndexPath) {
        model.toDoList.remove(at: indexPath.item)
        table.reloadData()
        documentSave()
    }*/
    
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell) {
        let text = cell.label.text
        var index = 0
        while model.toDoList[index].thingToDo != text {
            index += 1
        }
        switch action{
        case .done: model.toDoList[index].isDone = !model.toDoList[index].isDone
        case .delete: model.toDoList.remove(at: index)
        }
        table.reloadData()
        documentSave()
    }
    
    //MARK: - tableView delegate
    
    private var dataSource: [ToDoModel.ToDoInfo]{
        if displayingSheet.selectedSegmentIndex == 0{
            
            return model.toDoList
        }else if displayingSheet.selectedSegmentIndex == 1{
            return model.toDoList.filter{$0.isDone == false}
        }else{
            return model.toDoList.filter{$0.isDone == true}
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(36))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        if let toDoCell = cell as? ToDoTableViewCell {
            let text = NSAttributedString(string: dataSource[indexPath.item].thingToDo, attributes: [.font: font])
            toDoCell.label.attributedText = text
            toDoCell.label.textColor = !dataSource[indexPath.item].isDone ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            toDoCell.delegate = self
        }
        return cell
    }
    
    //MARK: - Navigation
    
    private var allNames: [String]{
        var names = [String]()
        for toDoInfo in model.toDoList{
            names.append(toDoInfo.thingToDo)
        }
        return names
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Case"{
            if let destination = segue.destination as? AddCaseViewController{
                destination.addCase = { [weak self] (text) in
                    if self?.allNames.contains(text) == false{
                        self?.model.toDoList.append(ToDoModel.ToDoInfo(thingToDo: text))
                    }
                    self?.table.reloadData()
                    self?.documentSave()
                }
            }
        }
    }
    
    private func documentSave(){
        document?.toDoList = model
        document?.updateChangeCount(.done)
    }
    
    //MARK: - Action
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource = self
            table.delegate = self
        }
    }
    
    
    @IBAction func removeAll(_ sender: UIButton) {
        model.toDoList.removeAll()
        table.reloadData()
        documentSave()
    }
    
    
    @IBAction func doneAll(_ sender: UIButton) {
        for index in model.toDoList.indices{
            model.toDoList[index].isDone = true
        }
        table.reloadData()
        documentSave()
    }
    
        
    @IBOutlet weak var menu: UIStackView!
    @IBOutlet weak var tableSafeArea: NSLayoutConstraint!
    @IBOutlet weak var displayingSheet: UISegmentedControl!
    
    @IBAction func menuVisibility(_ sender: UIBarButtonItem) {
        menu.isHidden = !menu.isHidden
        tableSafeArea.constant = menu.isHidden ? CGFloat(0) : menu.frame.height
    }
    
    @IBAction func changeDisplaying(_ sender: UISegmentedControl) {
        table.reloadData()
    }
}

