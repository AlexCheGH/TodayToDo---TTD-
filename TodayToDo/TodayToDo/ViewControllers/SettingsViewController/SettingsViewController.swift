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
                                         localization.fahrenheitCompact]
    private let pushSegmentOptions = [localization.off,
                                      localization.on]
    
    private let notificationsManager = LocalNotificationManager()
    private let userDefaults = TodayTodoUserDefaults()
    
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
        
        //Row 0 = Weather preference
        if indexPath.row == 0 {
            cell.configureCell(labelText: cellTitles[0],
                               segment0Title: weatherSegmentOptions[0],
                               segment1Title: weatherSegmentOptions[1],
                               index: indexPath.row,
                               togglerPosition: userDefaults.userWeatherFormatPreference.rawValue)
        }
        //Row 1 = Local push message preference
        else if indexPath.row == 1 {
            cell.configureCell(labelText: cellTitles[1],
                               segment0Title: pushSegmentOptions[0],
                               segment1Title: pushSegmentOptions[1],
                               cellType: .withDatePicker,
                               index: 1,
                               togglerPosition: userDefaults.isDailyStatsNotificationEnabled,
                               datePickerDate: DateManager().localNotificationTime)
        }
        cell.delegate = self
        return cell
    }
}

extension SettingsViewController: SettingsTableViewCellProtocol {
    func segmentedControlOption(value: Int, cellIndex: Int?) {
        guard let cellIndex = cellIndex else { return }
        switch cellIndex {
        case 0:
            userDefaults.updateWeatherPreference(value: value)
        case 1:
            userDefaults.updateDailyStatsNotificationPreference(value: value)
            if value == 1 {
                let dateComponent = DateManager().returnDateComponent(from: DateManager().localNotificationTime, with: .HHmmFormat)
                notificationsManager.requestNotificationAuthorization()
                notificationsManager.sendNotification(notificationType: .dailyStatistics, for: dateComponent)
            } else {
                //if toggler is inactive - kills the notitfication, resets saved notification time
                notificationsManager.updateNotification(notificationType: .dailyStatistics)
                userDefaults.updateNotificationTimePreference(stringDate: nil)
            }
        default:
            return
        }
    }
    
    func dropDownHides(cellIndex: Int?) {
        guard let index = cellIndex else { return }
        if index == 1 {
            let indexPath = IndexPath(item: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func onDatePickerElement(date: Date, cellType: SettingsViewCellType) {
        switch cellType {
        case .withDatePicker:
            let stringDate = DateManager().transformToString(date: date, format: .HHmmFormat)
            guard let value = stringDate else { return }
            //Adds prefered stat to userDefaults as String
            userDefaults.updateNotificationTimePreference(stringDate: value)
            //initiates notification sending for the specific time
            let dateComponent = DateManager().returnDateComponent(from: date)
            notificationsManager.sendNotification(notificationType: .dailyStatistics, for: dateComponent)
        default:
            return
        }
    }
}
