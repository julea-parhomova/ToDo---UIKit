//
//  DoneViewController.swift
//  ToDo list
//
//  Created by Julea Parkhomava on 3/17/21.
//

import UIKit
import CoreData

class DoneViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var presenter: Presenter!
    var container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var fetchedResultsController: NSFetchedResultsController<Affairs>?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Done List"
        if managedObjectContext == nil{
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: managedObjectContext)
        }
        updateUI()
    }
    
    @objc
    func managedObjectContextDidSave(notification: NSNotification) {
        updateUI()
    }
    
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource = self
            table.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter = Presenter()
        presenter.delegate = self
    }
    
    private func updateUI(){
        if let context = container?.viewContext {
            let request: NSFetchRequest<Affairs> = Affairs.fetchRequest()
            //?
            request.sortDescriptors = [NSSortDescriptor(
                key: "created",
                ascending: true
            )]
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
            fetchedResultsController = NSFetchedResultsController<Affairs>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            table.reloadData()
        }
    }
    
    @IBAction func removeAll(_ sender: UIButton) {
        if let currContainer = container{
            presenter.removeElements(removeFor: .done, container: currContainer)
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Add Case"{
            if let destination = segue.destination as? AddCaseViewController{
                destination.container = container
            }
        }
    }
    
}


extension DoneViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(36))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        if let toDoCell = cell as? ToDoTableViewCell {
            if let toDo = fetchedResultsController?.object(at: indexPath) {
                toDoCell.label.attributedText = NSAttributedString(string: toDo.text ?? "", attributes: [.font: font])
                toDoCell.label.textColor = !toDo.isDone ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                toDoCell.delegate = self
            }
        }
        return cell
    }
}

extension DoneViewController: ToDoCellDelegate{
    
    func action(for cell: ToDoTableViewCell, action: ToDoTableViewCell.ActionForCell) {
        if let curContainer = container{
            try? presenter.actionWithCell(for: cell, action: action, container: curContainer)
        }
    }
    
    
}

extension DoneViewController: PresenterDelegate{
    func updateTableView() {
        updateUI()
        table.reloadData()
    }
}
