//
//  Emitter.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import CoreData

protocol Emitter {

    associatedtype O
    func emit() -> O
}
