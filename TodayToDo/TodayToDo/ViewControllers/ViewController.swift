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
    
    private let cellHeight:CGFloat = 50
    
    private var taskManager = TaskManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    
    //MARK: - UITableView setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: tableViewCellName, bundle: Bundle.main), forCellReuseIdentifier: tableViewCellID)
        
        tableView.register(ToDoTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: tableViewHeaderId)
        
    }
}

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
    
    //Configuring custom header to display current date, weather.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                    tableViewHeaderId) as! ToDoTableViewHeaderView
        headerView.dateLabel.text = "Today, October 26"
        headerView.temperature.text = "26º"
        
        let image = UIImage(named: "weatherIcon")
        headerView.weatherImage.image = image
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
    
}

extension ViewController: SettingsTappedProtocol {
    func onSettingsTap() {
//        taskManager.createTestTasks()
//        print(taskManager.userTasks)
    }
}

extension ViewController: ToDoCellProtocol {
    func cellTapped(preciseDate: String) {
        let viewController = ViewControllerFactory.viewController(for: .detailedCard) as! DetailedCardViewController
        viewController.delegate = self //DetailedCardViewProtocol
        
        let task = taskManager.getTask(preciseTaskDate: preciseDate)
        
        viewController.configureTaskFields(taskTitle: (task.taskTitle as! String),
                                           taskDescription: (task.taskDescription as! String),
                                           taskStatus: task.taskIsDone as! Bool,
                                           preciseDate: (task.tasksDate as! String))
        present(viewController, animated: true, completion: nil)
    }
}

extension ViewController: DetailedCardViewProtocol {
    func deleteTask(preciseDate: String) {
        taskManager.removeEntry(for: preciseDate)
        tableView.reloadData()
    }
    
    func cardWillClose(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String?) {
        
        guard let title = taskTitle, let description = taskDescription else { return }
        let preciseDate = taskPresiceDate ?? DateManager().preciseDate
        
        taskManager.createNewTask(title: title,
                                  description: description,
                                  taskIsDone: taskIsDone,
                                  preciseDate: preciseDate)
        
    }
}
