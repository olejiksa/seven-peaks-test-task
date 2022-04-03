//
//  AnyAbsorber.swift
//  Cars
//
//  Created by Oleg Samoylov on 04.04.2022.
//

struct AnyAbsorber<T>: Absorber {

    let identifier: Int64
    private let absorbClosure: (T) -> Void

    init<U: Absorber>(_ absorber: U) where U.O == T {
        identifier = absorber.identifier
        absorbClosure = absorber.absorb
    }

    func absorb(_ object: T) {
        absorbClosure(object)
    }
}
