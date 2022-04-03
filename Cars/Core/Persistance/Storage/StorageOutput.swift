//
//  StorageOutput.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

protocol StorageOutput {

    associatedtype T

    @available(iOS 15, *)
    func fetch() async -> [T]?

    @available(iOS, deprecated: 15)
    func fetch(completion: @escaping ([T]?) -> Void)
}
