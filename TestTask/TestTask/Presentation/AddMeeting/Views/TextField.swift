//
//  TextField.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit

final class TextField: UITextField {

    // MARK: - Private properties

    private let insets: CGFloat

    // MARK: - Initialization

    init(insets: CGFloat) {
        self.insets = insets

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrided methods

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insets, dy: insets)
    }
}
