//
//  DetailedCardViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

protocol DetailedCardViewProtocol {
    
    func cardWillClose(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String)
    
    func deleteTask(preciseDate: String)
}

class DetailedCardViewController: UIViewController {
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: DetailedCardViewProtocol?
    
    
    var taskTitle: String?
    var taskDescription: String?
    var taskIsDone: Bool = false
    var preciseDate: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDeleteButton()
        titleField.text = preciseDate
        configure()
    }
    
    func configureTaskFields(taskTitle: String?, taskDescription: String?, taskStatus: Bool, preciseDate: String) {
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.taskIsDone = taskStatus
        self.preciseDate = preciseDate
    }
    
    private func configure() {
        self.titleField.text = taskTitle
        self.descriptionField.text = taskDescription
        self.statusIcon.text = taskIsDone ? "✔️" : "🔲"
    }
    
    private func configureDeleteButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(image, for: .normal)
        deleteButton.tintColor = .black
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        guard let deletionDate = preciseDate else { return }
        delegate?.deleteTask(preciseDate: deletionDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.cardWillClose(taskTitle: titleField.text,
                                taskDescription: descriptionField.text,
                                taskIsDone: statusIcon.text == "✔️" ? true : false,
                                taskPresiceDate: DateManager().preciseDate)
    }
}
