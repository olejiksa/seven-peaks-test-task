//
//  Reflexible.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

import CoreData

protocol Absorber {

    associatedtype O
    var identifier: Int64 { get }
    func absorb(_ object: O)
}
