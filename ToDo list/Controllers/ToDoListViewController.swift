//
//  ToDoListViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/10/21.
//

//есть ли здесь memory cicle?
import UIKit

class ToDoListViewController: UIViewController {
    
    var presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All To Do List"
        table.dataSource = self
        table.delegate = self
    }
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter = Presenter()
        presenter?.delegate = self
    }
    
    //почему когда я закрываю документ все ломается?
    //ведь mvc создается каждый раз когда мы переходим к ней
    //а какждый раз когда мы из нее уходим я зыкравыю  документ
    //получается такая схема:
    //прихожу во вкладку - открывается документ
    //перехожу в другую вкладку: закрываю документ в прежней вкладке и открываю в новой mvc
    //нужно же документ закрывать?
    /*override func viewDidDisappear(_ animated: Bool) {
     super.viewDidDisappear(animated)
     presenter.close()
     }*/
    
    //MARK: - Action
    
    @IBAction func removeAll(_ sender: UIButton) {
        presenter?.removeAll()
    }
    
    
    @IBAction func doneAll(_ sender: UIButton) {
        presenter?.doneAll()
        table.reloadData()
    }
    
}


extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.model.toDoList.count ?? 0
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(36))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        if let toDoCell = cell as? ToDoTableViewCell {
            //мы же можем сделать здесь ащксу forced unwrapping? потому что если нет презентера - то количество элементтов = 0 и эта функция не вызовется
            let text = NSAttributedString(string: presenter!.model.toDoList[indexPath.item].thingToDo, attributes: [.font: font])
            toDoCell.label.attributedText = text
            toDoCell.label.textColor = !presenter!.model.toDoList[indexPath.item].isDone ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            toDoCell.delegate = self
        }
        return cell
    }
}

extension ToDoListViewController: ToDoCellDelegate{
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell) {
        presenter?.actionWithCell(for: cell, action: action)
    }
}


extension ToDoListViewController: PresenterDelegate{
    func updateTableView() {
        table.reloadData()
    }
}
