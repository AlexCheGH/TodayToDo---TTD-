//
//  DetailedCardViewController.swift
//  TodayToDo
//
//  Created by Alex Chekushkin on 1/8/22.
//

import UIKit
import Combine

class DetailedCardViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: DetailedCardViewProtocol?
    
    var viewControllerHandler = DetailedViewControllerHandler()
    private var buttonSubscriber: AnyCancellable?
    private var titleFieldSubscriber: AnyCancellable?
    private var statusImageSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
        
        setupButtonSibscriber()
        setupTittleFieldSubscriber()
        setupStatusLabelSubscriber()
    }
    
    
    ///Takes values to render the DetailedViewController
    func configureTaskFields(taskTitle: String?, taskDescription: String?, taskStatus: Bool, preciseDate: String) {
        viewControllerHandler.title = taskTitle
        viewControllerHandler.description = taskDescription
        viewControllerHandler.isDone = taskStatus
        viewControllerHandler.preciseDate = preciseDate
    }
    
    
    //MARK: Setting-up subscribers
   private func setupTittleFieldSubscriber() {
        titleFieldSubscriber = viewControllerHandler.isTitleEmpty
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isEmpty in
                self.highlightTitleField(isEmpty: isEmpty)
            })
    }
    
   private func setupButtonSibscriber() {
        buttonSubscriber = viewControllerHandler.isValidToSave
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: saveButton)
    }
    
   private func setupStatusLabelSubscriber() {
        statusImageSubscriber = viewControllerHandler.statusImage
            .receive(on: RunLoop.main)
            .sink(receiveValue: { text in
                self.checkBoxButton.setTitle(text, for: .normal)
            })
    }
    
    //MARK: UI elements configuration
    private func configureUIElements() {
        configureDeleteButton()
        configureTitleTextField()
        configureDescriptionTextField()
        configureSaveButton()
    }
    
    private func configureTitleTextField() {
        titleField.delegate = self
        self.titleField.text = viewControllerHandler.title
    }
    
    private func configureDescriptionTextField() {
        self.descriptionField.text = viewControllerHandler.description
    }
    
    private func configureDeleteButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(image, for: .normal)
        deleteButton.tintColor = .black
    }
    
    private func configureSaveButton() {
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func highlightTitleField(isEmpty: Bool) {
        if isEmpty {
            titleField.backgroundColor = .red
        } else {
            titleField.backgroundColor = .white
        }
    }
    
    @IBAction func onDeleteButton(_ sender: Any) {
        viewControllerHandler.isValidToSave.sink { isEmpty in
            if isEmpty {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to discard the task?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onCheckboxTap(_ sender: UIButton) {
        viewControllerHandler.isDone.toggle()
    }
}

extension DetailedCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let _ = textField.text else { return false }
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
        case titleField:
            viewControllerHandler.title = text
            return true
        case descriptionField:
            viewControllerHandler.description = text
            return true
        default:
            return false
        }
    }
}
