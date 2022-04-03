//
//  StorageManager.swift
//  Cars
//
//  Created by Oleg Samoylov on 03.04.2022.
//

import CoreData

final class Storage {

    // MARK: Private Types

    private enum Constants {
        static let name = "Model"
    }

    // MARK: Private Properties

    private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.name)
        container.loadPersistentStores { _, _ in }
        return container
    }()
}

// MARK: - Private

private extension Storage {

    var articleEntityFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(ArticleEntity.self)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ArticleEntity.identifier, ascending: false)]
        return fetchRequest
    }
}

// MARK: - StorageInput

extension Storage: StorageInput {

    func save(items: [Article]) {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true

        context.perform {
            let entityDirector = EntityDirector<Article, ArticleEntity>()

            for item in items {
                try? entityDirector.findOrInsert(item, in: context)
            }

            if context.hasChanges {
                try? context.save()
            }
        }
    }
}

// MARK: - StorageOutput

extension Storage: StorageOutput {

    @available(iOS 15, *)
    func fetch() async -> [Article]? {
        let entities = await container.viewContext.perform(schedule: .immediate) {
            try? self.container.viewContext.fetch(self.articleEntityFetchRequest) as? [ArticleEntity]
        }

        return entities?.map { $0.emit() }
    }

    @available(iOS, deprecated: 15)
    func fetch(completion: @escaping ([Article]?) -> Void) {
        container.viewContext.perform {
            let entities = try? self.container.viewContext.fetch(self.articleEntityFetchRequest) as? [ArticleEntity]
            let articles = entities?.map { $0.emit() }
            completion(articles)
        }
    }
}
