//
//  Request.swift
//  Shopping app
//
//  Created by KOVIGROUP on 06/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import Foundation

struct Request {
    struct ParameterCurrency {
        static let eruusd = "EUR/USD"
        static let gbpusd = "GBP/USD"
        static let usdjpy = "USD/JPY"
        static let audusd = "AUD/USD"
        static let usdchf = "USD/CHF"
        static let nzdusd = "NZD/USD"
        static let usdcad = "NZD/USD"
    }
    static let currencyURL = NSURL(string: "https://www.freeforexapi.com/api/live?pairs") 
}
