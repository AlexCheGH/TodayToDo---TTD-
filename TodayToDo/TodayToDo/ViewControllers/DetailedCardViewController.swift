//
//  DetailedCardViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

protocol DetailedCardViewProtocol {
    func cardWillClose(taskTitle: String?, taskDescription: String?, taskIsDone: Bool, taskPresiceDate: String)
}

class DetailedCardViewController: UIViewController {
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UILabel!
    
    var delegate: DetailedCardViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.text = "siodjaosij"
    }

    func configure(tittle: String?, description: String?, isDone: Bool) {
        self.titleField.text = tittle
        self.descriptionField.text = description
        self.statusIcon.text = isDone ? "✔️" : "🔲"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.cardWillClose(taskTitle: titleField.text,
                                taskDescription: descriptionField.text,
                                taskIsDone: statusIcon.text == "✔️" ? true : false,
                                taskPresiceDate: DateManager().preciseDate)
    }
}
