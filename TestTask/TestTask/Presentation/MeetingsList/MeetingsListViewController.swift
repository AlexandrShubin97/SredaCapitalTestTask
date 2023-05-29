//
//  MeetingsListViewController.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import Foundation
import UIKit

final class MeetingsListViewController: UIViewController {

    // MARK: - Private nested

    private enum Constants {
        static let cellReuseIdentifier = "MeetingInfoCell"
    }

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MeetingInfoCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет запланированных встреч"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Private properties

    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    private var cellModels: [MeetingInfoCellModel] = []

    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        
        updateData()
        subscribeOnNotification()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setupConstraints()
    }
}

// MARK: - UITableViewDataSource
extension MeetingsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let favouriteCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.cellReuseIdentifier,
                for: indexPath
            ) as? MeetingInfoCell
        else {
            return UITableViewCell()
        }

        return favouriteCell.setup(model: cellModels[indexPath.row])
    }

}

// MARK: - Private methods
private extension MeetingsListViewController {

    func initialSetup() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(placeholderLabel)
    }

    func subscribeOnNotification() {
        NotificationCenter.default.addObserver(
            forName: .init(.updateMeetingList),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.updateData()
            }
        }
    }

    func updateData() {
        cellModels = coreDataManager.fetchMeetings().compactMap { meeting -> MeetingInfoCellModel? in
            guard
                let name = meeting.name,
                let date = meeting.date,
                let purpose = meeting.purpose
            else {
                return nil
            }

            return MeetingInfoCellModel(
                name: name,
                date: date,
                purpose: purpose,
                removeAction: { [weak self] in
                    self?.presentDeleteAlert(for: meeting)
                }
            )
        }

        tableView.reloadData()
        tableView.isHidden = cellModels.isEmpty

        placeholderLabel.isHidden = !cellModels.isEmpty
    }
    
    func presentDeleteAlert(for model: MeetingModel) {
        let alertController = AlertBuilder.build(
            title: "Удалить?",
            description: nil,
            actionTitles: ["Да", "Отмена"],
            actionHandlers: [
                { [weak self] in
                    self?.coreDataManager.removeMeeting(model)
                    self?.updateData()
                },
                nil
            ]
        )
        present(alertController, animated: true)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )

        NSLayoutConstraint.activate(
            [
                placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                placeholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
                placeholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            ]
        )
    }
}
