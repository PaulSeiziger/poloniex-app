//
//  ModelProtocol.swift
//  poloniex-app
//
//  Created by Павел Дреманович on 05.07.17.
//  Copyright © 2017 Павел Дреманович. All rights reserved.
//

import Foundation

protocol ModelProtocol {    
    init(configuration: ApiConfiguration)
    func start()
    func stop()
}
