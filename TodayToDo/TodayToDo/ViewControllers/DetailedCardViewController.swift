//
//  DetailedCardViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

class DetailedCardViewController: UIViewController {
    
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello")
    }

    func configure(tittle: String?, description: String?, isDone: Bool) {
        self.tittle.text = tittle
        self.descriptionField.text = description
        self.statusIcon.text = isDone ? "✔️" : "🔲"
    }
    

}
