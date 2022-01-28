//
//  ToDoTableFooterView.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/15/22.
//

import UIKit

protocol FooterViewDelegate {
    func onAddButtonTap()
}

class ToDoTableFooterView: UITableViewHeaderFooterView {
    
    let addButton = UIButton()
    
    var delegate: FooterViewDelegate?
    

    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)
        
        addButton.setImage(image, for: .normal)
        addButton.setTitle("", for: .normal)
        addButton.addTarget(self, action: #selector(onAddButtonTap), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    @objc private func onAddButtonTap() {
        delegate?.onAddButtonTap()
    }
    
}
