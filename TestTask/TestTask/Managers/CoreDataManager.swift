//
//  CoreDataManager.swift
//  TestTask
//
//  Created by Александр Шубин on 29.05.2023.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {

    /// Проверить существует ли встреча с указанным именем
    func checkIfMeetingExists(name: String) -> Bool

    /// Добавить встречу
    func addMeeting(
        name: String,
        date: String,
        purpose: String
    )

    /// Обновить существующую встречу
    func updateMeeting(
        name: String,
        date: String,
        purpose: String
    )

    /// Получить все встречи
    func fetchMeetings() -> [MeetingModel]
    
    /// Удалить встречу
    func removeMeeting(_ item: MeetingModel)

    /// Сохранить
    func save()
}

final class CoreDataManager {

    // MARK: - Static properties

    static let shared = CoreDataManager()

    // MARK: - Private properties

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestTask")
        container.loadPersistentStores { _, _ in }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Initialization

    private init() {}
}

// MARK: - CoreDataManagerProtocol
extension CoreDataManager: CoreDataManagerProtocol {

    func checkIfMeetingExists(name: String) -> Bool {
        let request = MeetingModel.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let meetingModel = try? context.fetch(request).first
        return meetingModel != nil
    }

    func addMeeting(name: String, date: String, purpose: String) {
        let meetingModel = MeetingModel(context: context)
        meetingModel.name = name
        meetingModel.date = date
        meetingModel.purpose = purpose

        context.insert(meetingModel)

        postNotification()
    }

    func updateMeeting(name: String, date: String, purpose: String) {
        let request = MeetingModel.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)

        if let meetingModel = try? context.fetch(request).first {
            meetingModel.name = name
            meetingModel.date = date
            meetingModel.purpose = purpose
        }

        postNotification()
    }

    func fetchMeetings() -> [MeetingModel] {
        let request = MeetingModel.fetchRequest()
        let meetingModels = try? context.fetch(request)
        return meetingModels?.sorted { $0.unwrappedName < $1.unwrappedName } ?? []
    }
    
    func removeMeeting(_ meeting: MeetingModel) {
        context.delete(meeting)
    }

    func save() {
        context.hasChanges ? try? context.save() : ()
    }
}

// MARK: - Private methods
private extension CoreDataManager {

    func postNotification() {
        NotificationCenter.default.post(
            Notification(name: .updateMeetingList)
        )
    }
}
