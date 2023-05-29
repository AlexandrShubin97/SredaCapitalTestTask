//
//  AddMeetingViewController.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit

final class AddMeetingViewController: UIViewController {

    // MARK: - Views

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameTextField: TextField = {
        let textField = TextField(insets: 10)
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Название встречи"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var dateTextField: TextField = {
        let textField = TextField(insets: 10)
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Начало и конец встречи"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.inputView = datesTimePickerManager.inputView
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let purposeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Опишите цель встречи:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let purposeTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 12
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Добавить встречу", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightText, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(addMeetingTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private properties

    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared

    private lazy var datesTimePickerManager: DatesTimePickerManager = {
        let picker = DatesTimePickerManager()
        picker.setup()
        picker.didSelectDates = { [weak self] dayDate, startTime, endTime in
            self?.dateTextField.text = Date.buildTimeRangeString(
                day: dayDate,
                startTime: startTime,
                endTime: endTime
            )
        }
        return picker
    }()

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setupConstraints()
        setupGestures()
    }
}

// MARK: - Private methods
private extension AddMeetingViewController {

    func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(nameTextField)
        contentView.addSubview(dateTextField)
        contentView.addSubview(purposeTitleLabel)
        contentView.addSubview(purposeTextView)
        contentView.addSubview(addButton)
    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func addMeetingTap() {
        let name = nameTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let purpose = purposeTextView.text ?? ""

        guard !name.isEmpty, !date.isEmpty else {
            presentCheckDataAlert()
            return
        }

        if coreDataManager.checkIfMeetingExists(name: name) {
            presentMeetingAlreadyExistsAlert(
                name: name,
                date: date,
                purpose: purpose
            )
            return
        }

        addMeeting(name: name, date: date, purpose: purpose)
    }

    func addMeeting(name: String, date: String, purpose: String) {
        coreDataManager.addMeeting(name: name, date: date, purpose: purpose)
        presentMeetingAddedAlert()
    }

    func updateMeeting(name: String, date: String, purpose: String) {
        coreDataManager.updateMeeting(name: name, date: date, purpose: purpose)
        presentMeetingUpdatedAlert()
    }

    func presentCheckDataAlert() {
        let alert = AlertBuilder.build(
            title: "Необходимо заполнить все данные",
            description: nil,
            actionTitles: ["Понятно"],
            actionHandlers: [nil]
        )
        present(alert, animated: true)
    }

    func presentMeetingAlreadyExistsAlert(name: String, date: String, purpose: String) {
        let alert = AlertBuilder.build(
            title: "Такая встреча уже существует",
            description: "Можно обновить существующую или добавить еще одну",
            actionTitles: ["Добавить", "Обновить", "Отмена"],
            actionHandlers: [
                { [weak self] in
                    self?.addMeeting(
                        name: name,
                        date: date,
                        purpose: purpose
                    )
                },
                { [weak self] in
                    self?.updateMeeting(
                        name: name,
                        date: date,
                        purpose: purpose
                    )
                },
                nil
            ]
        )
        present(alert, animated: true)
    }

    func presentMeetingUpdatedAlert() {
        let alert = AlertBuilder.build(
            title: "Встреча обновлена",
            description: nil,
            actionTitles: ["Хорошо"],
            actionHandlers: [nil]
        )
        present(alert, animated: true)
    }

    func presentMeetingAddedAlert() {
        let alert = AlertBuilder.build(
            title: "Встреча добавлена",
            description: nil,
            actionTitles: ["Хорошо"],
            actionHandlers: [nil]
        )
        present(alert, animated: true)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
                scrollView.leftAnchor.constraint(
                    equalTo: view.leftAnchor
                ),
                scrollView.rightAnchor.constraint(
                    equalTo: view.rightAnchor
                ),
                scrollView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor.constraint(
                    greaterThanOrEqualTo: scrollView.heightAnchor
                ),
                contentView.widthAnchor.constraint(
                    equalTo: scrollView.widthAnchor
                ),
                contentView.topAnchor.constraint(
                    equalTo: scrollView.topAnchor
                ),
                contentView.leftAnchor.constraint(
                    equalTo: scrollView.leftAnchor
                ),
                contentView.rightAnchor.constraint(
                    equalTo: scrollView.rightAnchor
                ),
                contentView.bottomAnchor.constraint(
                    equalTo: scrollView.bottomAnchor
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                nameTextField.heightAnchor.constraint(
                    equalToConstant: 72
                ),
                nameTextField.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: 20
                ),
                nameTextField.leftAnchor.constraint(
                    equalTo: contentView.leftAnchor,
                    constant: 12
                ),
                nameTextField.rightAnchor.constraint(
                    equalTo: contentView.rightAnchor,
                    constant: -12
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                dateTextField.heightAnchor.constraint(
                    equalToConstant: 72
                ),
                dateTextField.topAnchor.constraint(
                    equalTo: nameTextField.bottomAnchor,
                    constant: 20
                ),
                dateTextField.leftAnchor.constraint(
                    equalTo: contentView.leftAnchor,
                    constant: 12
                ),
                dateTextField.rightAnchor.constraint(
                    equalTo: contentView.rightAnchor,
                    constant: -12
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                purposeTitleLabel.topAnchor.constraint(
                    equalTo: dateTextField.bottomAnchor,
                    constant: 20
                ),
                purposeTitleLabel.leftAnchor.constraint(
                    equalTo: contentView.leftAnchor,
                    constant: 12
                ),
                purposeTitleLabel.rightAnchor.constraint(
                    equalTo: contentView.rightAnchor,
                    constant: -12
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                purposeTextView.heightAnchor.constraint(
                    equalToConstant: 200
                ),
                purposeTextView.topAnchor.constraint(
                    equalTo: purposeTitleLabel.bottomAnchor,
                    constant: 10
                ),
                purposeTextView.leftAnchor.constraint(
                    equalTo: contentView.leftAnchor,
                    constant: 12
                ),
                purposeTextView.rightAnchor.constraint(
                    equalTo: contentView.rightAnchor,
                    constant: -12
                )
            ]
        )

        NSLayoutConstraint.activate(
            [
                addButton.heightAnchor.constraint(
                    equalToConstant: 72
                ),
                addButton.topAnchor.constraint(
                    greaterThanOrEqualTo: purposeTextView.bottomAnchor,
                    constant: 20
                ),
                addButton.leftAnchor.constraint(
                    equalTo: contentView.leftAnchor,
                    constant: 12
                ),
                addButton.rightAnchor.constraint(
                    equalTo: contentView.rightAnchor,
                    constant: -12
                ),
                addButton.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -20
                )
            ]
        )
    }
}
