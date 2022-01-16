//
//  ToDoTableViewCell.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

protocol ToDoCellProtocol {
    func cellLabelTapped(preciseDate: String)
    func cellCheckBoxTapped(preciseDate: String, taskIsDone: Bool)
}

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    private let statusDoneString = "✔️"
    private let statusNotDoneString = "🔲"
    private var taskIsDone = false
    
    var delegate: ToDoCellProtocol?
    //to detect tapped cell to modify or delete it
    private var cellPreciseDate: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addStatusChangeTapGesture()
        addTaskLabelTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(taskName: String, isDone: Bool, preciseDate: String) {
        taskNameLabel.text = taskName
        changeStatusLabel(isDone: isDone)
        cellPreciseDate = preciseDate
        taskIsDone = isDone
    }
    
    private func addStatusChangeTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:#selector(onTapGesture))
        statusLabel.isUserInteractionEnabled = true
        statusLabel.addGestureRecognizer(tap)
    }
    
    @objc private func onTapGesture(_ sender: UITapGestureRecognizer) {
        taskIsDone.toggle()
        delegate?.cellCheckBoxTapped(preciseDate: cellPreciseDate, taskIsDone: taskIsDone)
        
        changeStatusLabel(isDone: taskIsDone)
        
    }
    
    private func addTaskLabelTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLabelTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @objc private func onLabelTap(_ sender: UITapGestureRecognizer) {
        delegate?.cellLabelTapped(preciseDate: cellPreciseDate)
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
