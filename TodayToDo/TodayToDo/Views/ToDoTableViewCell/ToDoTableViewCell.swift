//
//  ToDoTableViewCell.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    private let statusDoneString = "✔️"
    private let statusNotDoneString = "🔲"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addStatusChangeTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(taskName: String, isDone: Bool) {
        taskNameLabel.text = taskName
        changeStatusLabel(isDone: isDone)
    }
    
    
    private func addStatusChangeTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:#selector(onTapGesture))
        statusLabel.isUserInteractionEnabled = true
        statusLabel.addGestureRecognizer(tap)
    }
    
    @objc private func onTapGesture(_ sender: UITapGestureRecognizer) {
        print("test")
    }
    
    private func changeStatusLabel(isDone: Bool) {
        switch isDone {
        case true:
            statusLabel.text = statusDoneString
            markCellDone()
        case false:
            statusLabel.text = statusNotDoneString
        }
    }
    
    
    private func markCellDone() {
        guard let text = taskNameLabel.text else { return }
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        taskNameLabel.attributedText = attributedString
        
        self.backgroundColor = .gray
    }
    
    
    
    
}
