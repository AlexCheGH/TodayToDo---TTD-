//
//  SegmentedControlTableViewCell.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/12/22.
//

import UIKit

protocol SettingsTableViewCellProtocol {
    func segmentedControlOption(value: Int)
    func dropDownHides(cellIndex: Int?)
    func onDatePickerElement(date: Date, cellIndex: Int?, cellType: SettingsViewCellType)
}


enum SettingsViewCellType {
    case withDatePicker
    case withoutDatePicker
}

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerStackView: UIStackView!
    
    //Tells delegate the index of a cell = delegate.dropDownHides()
    private var index: Int?
    //Helps to configure cell - what needs to be drawn.
    private var cellType: SettingsViewCellType = .withoutDatePicker
    
    var delegate: SettingsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    ///Main function to setup a cell. cellType decides whether DatePicker or other elements shoud be presented or not. Toggler position determines the deault toggler position, 0 = Off, 1 = On; 0 = C, 1 = F.
    func configureCell(labelText: String, segment0Title: String, segment1Title: String, cellType: SettingsViewCellType = .withoutDatePicker, index: Int, togglerPosition: Int) {
        
        label.text = labelText
        self.dateLabel.text = Localization.Settings.selectTime
        
        self.index = index
        self.cellType = cellType
        
        if cellType == .withoutDatePicker {
            datePickerStackView.isHidden = true
        } else if cellType == .withDatePicker && togglerPosition == 1 {
            datePickerStackView.isHidden = true
        } else if cellType == .withDatePicker && togglerPosition == 0 {
            datePickerStackView.isHidden = false
        }
        
        segmentedControl.selectedSegmentIndex = togglerPosition
        segmentedControl.setTitle(segment0Title, forSegmentAt: 0)
        segmentedControl.setTitle(segment1Title, forSegmentAt: 1)
    }
    
    @IBAction func onSegmentedControlTap(_ sender: UISegmentedControl) {
        delegate?.segmentedControlOption(value: sender.selectedSegmentIndex)
        delegate?.dropDownHides(cellIndex: index)
    }
    
    @IBAction func onDatePicker(_ sender: UIDatePicker) {
        delegate?.onDatePickerElement(date: sender.date, cellIndex: index, cellType: cellType)
    }
    
}
