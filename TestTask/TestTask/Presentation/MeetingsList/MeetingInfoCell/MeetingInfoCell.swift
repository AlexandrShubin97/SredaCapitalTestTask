//
//  MeetingInfoCell.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit

final class MeetingInfoCell: UITableViewCell {
    
    // MARK: - Private nested

    private enum Constants {
        static let removeButtonSize: CGFloat = 15
    }

    // MARK: - Views

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let purposeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete.png")?.withTintColor(.red), for: .normal)
        button.addTarget(self, action: #selector(removeTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private properties

    private var removeAction: (() -> Void)?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialSetup()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal methods
extension MeetingInfoCell {

    func setup(model: MeetingInfoCellModel) -> Self {
        nameLabel.text = model.name
        dateLabel.text = model.date
        purposeLabel.text = model.purpose
        removeAction = model.removeAction

        return self
    }
}

// MARK: - Private methods
private extension MeetingInfoCell {

    func initialSetup() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(removeButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(purposeLabel)
        contentView.addSubview(dividerView)
        
    }
    
    @objc
    func removeTap() {
        removeAction?()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                removeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
                removeButton.heightAnchor.constraint(equalToConstant: Constants.removeButtonSize),
                removeButton.widthAnchor.constraint(equalToConstant: Constants.removeButtonSize)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                nameLabel.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -12)
            ]
        )

        NSLayoutConstraint.activate(
            [
                dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12)
            ]
        )

        NSLayoutConstraint.activate(
            [
                purposeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
                purposeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                purposeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            ]
        )

        NSLayoutConstraint.activate(
            [
                dividerView.heightAnchor.constraint(equalToConstant: 1),
                dividerView.topAnchor.constraint(equalTo: purposeLabel.bottomAnchor, constant: 10),
                dividerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                dividerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
                dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ]
        )
    }
}
