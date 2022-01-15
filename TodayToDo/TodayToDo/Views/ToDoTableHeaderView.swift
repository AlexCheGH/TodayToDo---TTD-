//
//  ToDoTableHeaderView.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit

protocol SettingsTappedProtocol {
    func onSettingsTap()
}

class ToDoTableHeaderView: UITableViewHeaderFooterView {
    
    let dateLabel = UILabel()
    let temperature = UILabel()
    let weatherImage = UIImageView()
    let settingsButton = UIButton()
    
    var delegate: SettingsTappedProtocol?
    

    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        //date label config
        dateLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        //setting button config
        let configuration = UIImage.SymbolConfiguration(pointSize: 72)
        let image = UIImage(systemName: "gear", withConfiguration: configuration)
        settingsButton.setImage(image, for: .normal)
        settingsButton.tintColor = .black
        
        settingsButton.addTarget(self, action: #selector(onSettingsTap), for: .touchUpInside)
        
        
        //constraints
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperature)
        contentView.addSubview(weatherImage)
        contentView.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            dateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temperature.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            temperature.heightAnchor.constraint(equalToConstant: 50),
            temperature.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            temperature.widthAnchor.constraint(equalToConstant: 30),
            
            weatherImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            weatherImage.heightAnchor.constraint(equalToConstant: 30),
            weatherImage.leadingAnchor.constraint(equalTo: temperature.trailingAnchor, constant: 8),
            weatherImage.widthAnchor.constraint(equalToConstant: 30),
            
            settingsButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            settingsButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func onSettingsTap() {
        delegate?.onSettingsTap()
    }
    
}
