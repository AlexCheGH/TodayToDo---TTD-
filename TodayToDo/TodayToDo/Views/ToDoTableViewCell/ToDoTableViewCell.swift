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
    
    private let checkmark = "✔️"
    private let emptyBox = "🔲"
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
        guard let text = taskNameLabel.text else { return }
        switch isDone {
        case true:
            markCellDone(text: text)
        case false:
            markCellUndone(text: text)
        }
    }
    
    private func markCellUndone(text: String) {
        statusLabel.text = emptyBox
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        taskNameLabel.attributedText = attributedString
        
        self.backgroundColor = .white
    }
    
    private func markCellDone(text: String) {
        statusLabel.text = checkmark
        
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        taskNameLabel.attributedText = attributedString
        
        self.backgroundColor = .gray
    }
}
