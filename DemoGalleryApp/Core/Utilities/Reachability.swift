//
//  Reachability.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation
import Network

final class Reachability {

    static let shared = Reachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Reachability")

    private(set) var isConnected = false
    
    private init() {

        monitor.pathUpdateHandler = { [weak self] path in

            let connected = path.status == .satisfied
            self?.isConnected = connected

            print("Reachability:", connected)
        }

        monitor.start(queue: queue)
    }
    
}
