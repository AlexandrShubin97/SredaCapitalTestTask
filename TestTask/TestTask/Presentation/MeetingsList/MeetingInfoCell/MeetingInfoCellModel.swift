//
//  MeetingInfoCellModel.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit

struct MeetingInfoCellModel {
    let name: String
    let date: String
    let purpose: String
    let removeAction: () -> Void
}
