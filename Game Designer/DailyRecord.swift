//
//  DailyRecord.swift
//  Game Designer
//
//  Created by jhp on 2019-01-21.
//  Copyright © 2019 Papaya. All rights reserved.
//

import Foundation
struct DailyRecord : Codable {
    var day : Date = Date()
    var description : [String] = []
    var amount : [Int] = []
    var weekRecord : [[Int]] = [[0],[0],[0],[0],[0],[0],[0]]
    //[change]
    init () {
    }
    mutating func add (description: String, amount: Int) {
        let currentWeekDay = Calendar.current.component(.weekday, from: Date())-1
        self.description += [description]
        self.amount += [amount]
        weekRecord[currentWeekDay][0] += amount
    }
    mutating func clear () {
        self.day = Date()
        let currentWeekDay = Calendar.current.component(.weekday, from: Date())-1
        self.description = []
        self.amount = []
        if weekRecord[currentWeekDay][0] != 0 {
            weekRecord[currentWeekDay][0] = 0
        }
    }
}
