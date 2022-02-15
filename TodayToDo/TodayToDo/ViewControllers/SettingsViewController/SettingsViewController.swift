//
//  SettingsViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 2/12/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let tableViewCellName = "SettingsTableViewCell"
    private let tableViewCellID = "settingsTableViewCellID"
    
    private static let localization = Localization.Settings.self
    
    private let titleText = localization.settingsTitle
    private let cellTitles = [localization.temperatureFormat,
                              localization.pushMessages]
    
    private let weatherSegmentOptions = [localization.celsiusCompact,
                                         localization.fahrenheitCompact
    ]
    private let pushSegmentOptions = [localization.on,
                                      localization.off
    ]
    
    
    private var isDateViewPresented = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureDoneButton()
        configureTableView()
    }
    
    private func configureTitle() {
        titleLabel.text = titleText
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(Localization.Label.done, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 30)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: tableViewCellName, bundle: Bundle.main), forCellReuseIdentifier: tableViewCellID)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        //Resolves an issue highlighted on storyboard - height error; the height of tableView depends on the content
        var frame = tableView.frame
        frame.size.height = tableView.contentSize.height
        tableView.frame = frame
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
        
        
    }
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        switch sender {
        case doneButton:
            self.dismiss(animated: true, completion: nil)
        default:
            print("Error")
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! SettingsTableViewCell
        
        
        if indexPath.row == 0 {
            cell.configureCell(labelText: cellTitles[0],
                               segment0Title: weatherSegmentOptions[0],
                               segment1Title: weatherSegmentOptions[1],
                               index: indexPath.row,
                               togglerPosition: 0)
        } else if indexPath.row == 1 {
            cell.configureCell(labelText: cellTitles[1],
                               segment0Title: pushSegmentOptions[0],
                               segment1Title: pushSegmentOptions[1],
                               cellType: .withDatePicker,
                               index: 1,
                               togglerPosition: isDateViewPresented == true ? 0 : 1)
            
        }
        cell.delegate = self
        return cell
    }
}

extension SettingsViewController: SettingsTableViewCellProtocol {
    func dropDownHides(cellIndex: Int?) {
        guard let index = cellIndex else { return }
        let indexPath = IndexPath(item: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func segmentedControlOption(value: Int) {
        value == 0 ? (isDateViewPresented = true) : (isDateViewPresented = false)
    }
    
    func onDatePickerElement(date: Date, cellIndex: Int?, cellType: SettingsViewCellType) {
        print(date)
    }
    
}
