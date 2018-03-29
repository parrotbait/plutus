//
//  DailyAxisChartFormatter.swift
//  plutus
//
//  Created by Eddie Long on 28/03/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import Charts

class PeriodAxisChartFormatter: NSObject, IAxisValueFormatter {
    
    let period : PricePeriod
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let unixTimestamp = NSDate(timeIntervalSince1970: value)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        switch (period) {
        case .last24:
            dateFormatter.dateFormat =  "HH:mm"
            break
        case .week:
            dateFormatter.dateFormat =  "E"
            break
        case .month:
            dateFormatter.dateFormat =  "dd.MM"
            break
        case .year:
            dateFormatter.dateFormat =  "MMMM"
            break
        case .allTime:
            dateFormatter.dateFormat =  "MMMM yyyy"
            break
        }
        return dateFormatter.string(from: unixTimestamp as Date)
    }
    
    init(period: PricePeriod) {
        self.period = period
        super.init()
    }
}
