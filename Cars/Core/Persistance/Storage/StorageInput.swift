//
//  StorageInput.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

protocol StorageInput {

    associatedtype T
    func save(items: [T])
}
