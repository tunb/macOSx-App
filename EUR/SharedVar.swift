//
//  SharedVar.swift
//  EUR
//
//  Created by Ajai Nair on 7/27/19.
//  Copyright © 2019 mrb. All rights reserved.
//

import Foundation

class SharedVar {
    static let sharedInstance = SharedVar()
    
    var fCurrency: Float
    private init() {
        fCurrency = 0.0
    }
    
    public func setCurrency(cur: Float) {
        fCurrency = cur
    }
    
    public func getCurrency() -> Float {
        return fCurrency
    }
}
