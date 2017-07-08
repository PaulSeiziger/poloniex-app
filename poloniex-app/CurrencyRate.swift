//
//  CurrencyRate.swift
//  poloniex-app
//
//  Created by Павел Дреманович on 14.06.17.
//  Copyright © 2017 Павел Дреманович. All rights reserved.
//

import Foundation
class CurrencyRate {
    var currencyName:String = "Undefined"
    var currencyValue:Double = 0.0
    var isShown:Bool = false
    
    init() {
        
    }
    
    init(currencyName:String, currencyValue:Double) {
        self.currencyName = currencyName
        self.currencyValue = currencyValue
    }
}
