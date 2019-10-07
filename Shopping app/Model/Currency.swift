//
//  Currency.swift
//  Shopping app
//
//  Created by KOVIGROUP on 06/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

struct Currency : Decodable {
    let rates: String
    let rate: String
    func getString() {
        print( "rates: \(rates), rate: \(rate)" )
    }
}
