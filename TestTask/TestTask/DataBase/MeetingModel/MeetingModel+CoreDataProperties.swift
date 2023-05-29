//
//  MeetingModel+CoreDataProperties.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//
//

import Foundation
import CoreData

extension MeetingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetingModel> {
        return NSFetchRequest<MeetingModel>(entityName: "MeetingModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: String?
    @NSManaged public var purpose: String?

    var unwrappedName: String {
        return name ?? ""
    }
}
