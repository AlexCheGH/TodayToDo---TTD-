//
//  ViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let tableViewCellName = "ToDoTableViewCell"
    private let tableViewCellID = "todoCellID"
    private let tableViewHeaderId = "sectionHeader"
    private let tableViewFooterId = "sectionFooter"
    
    private let cellHeight: CGFloat = 50
    private let footerHeaderHeight: CGFloat = 100
    
    private var taskManager = TaskManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(taskManager.userTasks)
        setupTableView()
    }
    
    //MARK: UITableView setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: tableViewCellName, bundle: Bundle.main), forCellReuseIdentifier: tableViewCellID)
        
        tableView.register(ToDoTableHeaderView.self, forHeaderFooterViewReuseIdentifier: tableViewHeaderId)
        tableView.register(ToDoTableFooterView.self, forHeaderFooterViewReuseIdentifier: tableViewFooterId)
    }
    
    private func createDetailedCardVC(preciseDate: String?) -> DetailedCardViewController {
        let viewController = ViewControllerFactory.viewController(for: .detailedCard) as! DetailedCardViewController
        viewController.delegate = self //DetailedCardViewProtocol
        
        if let preciseDate = preciseDate {
            let task = taskManager.getTask(preciseTaskDate: preciseDate)
            viewController.configureTaskFields(taskTitle: (task.taskTitle as! String),
                                               taskDescription: (task.taskDescription as! String),
                                               taskStatus: task.taskIsDone as! Bool,
                                               preciseDate: (task.tasksDate as! String),
                                               isNewTask: false)
        } else {
            let date = DateManager().preciseDate
            viewController.handler.preciseDate = date
        }
        return viewController
    }
    
}
// MARK: UITableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskManager.userTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskManager.userTasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! ToDoTableViewCell
        
        cell.configureCell(taskName: task.taskTitle as! String,
                           isDone: task.taskIsDone as! Bool,
                           preciseDate: task.tasksDate as! String)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let indexPath = IndexPath(item: indexPath.row, section: indexPath.section)
            taskManager.removeEntry(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            Void()
        }
    }
    
    //MARK: Header configuration
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderId) as! ToDoTableHeaderView
        headerView.dateLabel.text = DateManager().compactDate
        headerView.temperature.text = "26º"
        
        let image = UIImage(named: "weatherIcon")
        headerView.weatherImage.image = image
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        footerHeaderHeight
    }
    
    //MARK: Footer configuration
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewFooterId) as! ToDoTableFooterView
        footerView.delegate = self
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        footerHeaderHeight
    }
}
// MARK: SettingTappedProtocol
extension ViewController: SettingsTappedProtocol {
    func onSettingsTap() {
        
        print(taskManager.userTasks)
        
    }
}

//MARK: FooterViewDelegate
extension ViewController: FooterViewDelegate {
    func onAddButtonTap() {
        let viewController = createDetailedCardVC(preciseDate: nil)
        present(viewController, animated: true, completion: nil)
    }
}

//MARK: TODOCellProtocol
extension ViewController: ToDoCellProtocol {
    func cellCheckBoxTapped(preciseDate: String, taskIsDone: Bool) {
        
        let task = taskManager.getTask(preciseTaskDate: preciseDate)
        taskManager.createNewTask(title: task.taskTitle as! String,
                                  description: (task.taskDescription as! String),
                                  taskIsDone: taskIsDone,
                                  preciseDate: preciseDate)
    }
    
    func cellLabelTapped(preciseDate: String) {
        let viewController = createDetailedCardVC(preciseDate: preciseDate)
        present(viewController, animated: true, completion: nil)
    }
}

//MARK: DetailedCardViewProtocol
extension ViewController: DetailedCardViewProtocol {
    
    func deleteTask(preciseDate: String) {
        let task = taskManager.getTask(preciseTaskDate: preciseDate)
        let index = taskManager.userTasks.firstIndex(of: task)
        
        guard let index = index else { return }
        let indexPath = IndexPath(item: index, section: 0)
        taskManager.removeEntry(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .middle)
        
    }
    
    func saveTask(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String?) {
        if let title = taskTitle {
            let preciseDate = taskPresiceDate ?? DateManager().preciseDate
            taskManager.createNewTask(title: title,
                                      description: taskDescription,
                                      taskIsDone: taskIsDone,
                                      preciseDate: preciseDate)
            
            let task = taskManager.getTask(preciseTaskDate: preciseDate)
            let index = taskManager.userTasks.firstIndex(of: task)
            guard let index = index else { return }
            
            let indexPath = IndexPath(item: index, section: 0)
            
            if tableView.hasRowAtIndexPath(indexPath: indexPath) {
                tableView.reloadRows(at: [indexPath], with: .middle)
            }
            else {  tableView.insertRows(at: [indexPath], with: .middle) }
        }
    }
}
