//
//  TabBarController.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Overrided methods

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        addItems()
    }
}

// MARK: - Private methods
private extension TabBarController {

    func initialSetup() {
        view.backgroundColor = .white
    }

    func addItems() {
        let firstItem = UITabBarItem(
            title: "Новая встреча",
            image: UIImage(named: "add.png"),
            tag: 0
        )
        let firstViewController = AddMeetingViewController()
        firstViewController.tabBarItem = firstItem

        let secondItem = UITabBarItem(
            title: "Список встреч",
            image: UIImage(named: "list.png"),
            tag: 1
        )
        let secondViewController = MeetingsListViewController()
        secondViewController.tabBarItem = secondItem

        viewControllers = [firstViewController, secondViewController]
    }
}
