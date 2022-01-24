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
    
    var handler = DetailedViewControllerHandler()
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
    func configureTaskFields(taskTitle: String?, taskDescription: String?, taskStatus: Bool, preciseDate: String, isNewTask: Bool) {
        handler.title = taskTitle
        handler.description = taskDescription
        handler.isDone = taskStatus
        handler.preciseDate = preciseDate
        handler.isNewTask = isNewTask
    }
    
    //MARK: Setting-up subscribers
   private func setupTittleFieldSubscriber() {
        titleFieldSubscriber = handler.isTitleEmpty
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isEmpty in
                self.highlightTitleField(isEmpty: isEmpty)
            })
    }
    
   private func setupButtonSibscriber() {
        buttonSubscriber = handler.isValidToSave
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: saveButton)
    }
    
   private func setupStatusLabelSubscriber() {
        statusImageSubscriber = handler.statusImage
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
    
    private func configureStatusLabel() {
        statusLabel.text = Localization.Label.status
    }
    
    private func configureTitleTextField() {
        titleField.delegate = self
        self.titleField.text = handler.title
    }
    
    private func configureDescriptionTextField() {
        self.descriptionField.text = handler.description
        self.descriptionField.delegate = self
    }
    
    private func configureDeleteButton() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        
        deleteButton.setTitle("", for: .normal)
        deleteButton.setImage(image, for: .normal)
        deleteButton.tintColor = .black
    }
    
    private func configureSaveButton() {
        saveButton.setTitle(Localization.Label.save, for: .normal)
    }
    
    private func highlightTitleField(isEmpty: Bool) {
        if isEmpty {
            titleField.backgroundColor = .red
        } else {
            titleField.backgroundColor = .white
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: Localization.Delete.deleteTask, message: Localization.Delete.deleteTaskConfirmation, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localization.UserChoice.cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Localization.UserChoice.yes, style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteButtonAction() {
        handler.isValidToSave.sink { [self] isEmpty in
            if isEmpty {
                self.dismiss(animated: true, completion: nil)
            } else if !isEmpty && handler.isNewTask {
                presentAlert()
            } else if (!isEmpty && !handler.isNewTask) || (isEmpty && !handler.isNewTask) {
                guard let date = handler.preciseDate else { return }
                delegate?.deleteTask(preciseDate: date)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func saveButtonAction() {
        delegate?.saveTask(taskTitle: handler.title,
                           taskDescription: handler.description,
                           taskIsDone: handler.isDone,
                           taskPresiceDate: handler.preciseDate)
        handler.isNewTask = false
    }
    
    private func checkboxButtonAction() {
        handler.isDone.toggle()
    }
    
    @IBAction func onButtonTap(_ sender: UIButton) {
        switch sender {
        case deleteButton:
            deleteButtonAction()
        case checkBoxButton:
            checkboxButtonAction()
        case saveButton:
            saveButtonAction()
        default:
            Void()
        }
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
            handler.title = text
            return true
        case descriptionField:
            handler.description = text
            return true
        default:
            return false
        }
    }
}
