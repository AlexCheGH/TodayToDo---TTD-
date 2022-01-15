//
//  DetailedCardViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

protocol DetailedCardViewProtocol {
    
    func cardWillClose(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String?)
    func deleteTask(preciseDate: String)
}

class DetailedCardViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
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
        titleField.delegate = self
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
        
        titleField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    /// Check new user inputs for titleField
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        highlightTitleField(isEmpty: text.isEmpty)
    }
    
    private func highlightTitleField(isEmpty: Bool) {
        isEmpty ? (titleField.backgroundColor = .red) : (titleField.backgroundColor = .white)
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
    
    @IBAction func onTextFieldTap(_ sender: UITextField) {
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.cardWillClose(taskTitle: titleField.text,
                                taskDescription: descriptionField.text,
                                taskIsDone: statusIcon.text == "✔️" ? true : false,
                                taskPresiceDate: preciseDate)
    }
}

extension DetailedCardViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let _ = textField.text else { return false }
    
        textField.resignFirstResponder()
        return true
    }
    
}
