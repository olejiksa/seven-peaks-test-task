//
//  EntityDirector.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import CoreData

struct EntityDirector<U: Unique, T: NSManagedObject & Absorber> {

    func findOrInsert(_ object: U, in context: NSManagedObjectContext) throws where U == T.O {
        if let entity = try find(by: object.identifier, in: context) {
            let absorber = AnyAbsorber<U>(entity)
            absorber.absorb(object)
        } else {
            insert(object, into: context)
        }
    }
}

private extension EntityDirector {

     func find(by identifier: Int64, in context: NSManagedObjectContext) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
        fetchRequest.predicate = NSPredicate(format: "identifier = %ld", identifier as CVarArg)
        let entities = try context.fetch(fetchRequest)
        return entities.first
    }

    func insert(_ object: U, into context: NSManagedObjectContext) where U == T.O {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "\(T.self)", in: context),
              let entity = NSManagedObject(entity: entityDescription, insertInto: context) as? T
        else { return }

        let absorber = AnyAbsorber<U>(entity)
        absorber.absorb(object)
    }
}
