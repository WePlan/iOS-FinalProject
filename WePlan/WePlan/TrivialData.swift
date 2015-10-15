//
//  TrivialData.swift
//  WePlan
//
//  Created by xi su on 5/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
extension NSDate {
    func yearsDiff(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsDiff(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksDiff(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysDiff(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: []).day
    }
    func addDays(days:Int)-> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: days, toDate: self, options: [])!
    }
    func addMonths(months: Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: months, toDate: self, options: [])!
    }
}