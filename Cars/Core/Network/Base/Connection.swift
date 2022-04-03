//
//  Connection.swift
//  Cars
//
//  Created by Oleg Samoylov on 03.04.2022.
//

import Reachability

protocol Connection {

    var hasConnectivity: Bool { get }
}

extension Connection {

    var hasConnectivity: Bool {
        do {
            let reachability = try Reachability()
            let networkStatus = reachability.connection

            switch networkStatus {
            case .wifi, .cellular:
                return true
            default:
                return false
            }
        }
        catch {
            return false
        }
    }
}
