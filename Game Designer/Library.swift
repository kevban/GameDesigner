//
//  Library.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//
import UIKit
import Foundation
var userLimitQuests : [Quest] = []
var userMainQuests : [Quest] = []
var userDailyQuests : [Quest] = []
var userRepeatQuests : [Quest] = []
var userItems : [Item] = []
var userShop : [Item] = []
var userInventory : [Item] = [cash]
var status : String = ""
var cash = Item.init("Cash", "", icon:  "dollarsignicon")
var bank = [0,0,0]//fund, save, interest
var tax = [0,20,600]//current amount, cost/minute, buffer

var seconds = 0
var minutes = 25
var timerStarted = 0
var timerData : [Date] = [Date(),Date()]
var timerType : Int = 2
var timerTitle : String = ""
var weekdayTimers : [[TimerData]] = [[],[],[],[],[],[],[]]
var taxableStartTime = Date()
var dailyRecord = DailyRecord.init()
var weeklyRecord : [DailyRecord] = [DailyRecord.init(),DailyRecord.init(),DailyRecord.init(),DailyRecord.init(),DailyRecord.init(),DailyRecord.init(),DailyRecord.init()]


var images = ["arms", "bluecard","redcard","orangecard","purplecard","yellowcard",
              "bluechest","redchest","brownchest","greenchest",
              "bluegiftbox","giftbox","greengiftbox",
              "bluehardcard","orangehardcard","purplehardcard","redhardcard",
              "bluekey","greenkey","brownkey","redkey",
              "diamondcard","spadecard","heartcard","clubcard",
              "ocard","sadcard","happycard","xdcard",
              "diamond","yellowdiamond","pueplediamond",
              "shield","heart","sword","cannon",
              "bluewand","greenwand","purplewand","redwand"]





func saveData () {
    if let encodedLimitQuests = try? JSONEncoder().encode(userLimitQuests) {
        UserDefaults.standard.set(encodedLimitQuests, forKey: "limitQuests")
    }
    if let encodedMainQuests = try? JSONEncoder().encode(userMainQuests) {
        UserDefaults.standard.set(encodedMainQuests, forKey: "mainQuests")
    }
    if let encodedDailyQuests = try? JSONEncoder().encode(userDailyQuests) {
        UserDefaults.standard.set(encodedDailyQuests, forKey: "dailyQuests")
    }
    if let encodedDailyQuests = try? JSONEncoder().encode(userRepeatQuests) {
        UserDefaults.standard.set(encodedDailyQuests, forKey: "repeatQuests")
    }
    if let encodedInventory = try? JSONEncoder().encode(userInventory) {
        UserDefaults.standard.set(encodedInventory, forKey: "inventory")
    }
    if let encodedItems = try? JSONEncoder().encode(userItems) {
        UserDefaults.standard.set(encodedItems, forKey: "items")
    }
    if let encodedItems = try? JSONEncoder().encode(userShop) {
        UserDefaults.standard.set(encodedItems, forKey: "shop")
    }
    if let encodedItems = try? JSONEncoder().encode(bank) {
        UserDefaults.standard.set(encodedItems, forKey: "fund")
    }
    if let encodedItems = try? JSONEncoder().encode(tax) {
        UserDefaults.standard.set(encodedItems, forKey: "tax")
    }
    UserDefaults.standard.set(taxableStartTime, forKey: "daystart")
    if let encodedItems = try? JSONEncoder().encode(dailyRecord) {
        UserDefaults.standard.set(encodedItems, forKey: "dailyrecord")
    }
    
    
}

func saveTimerData() {
    if let encodedItems = try? JSONEncoder().encode(timerData) {
        UserDefaults.standard.set(encodedItems, forKey: "timerData")
    }
    UserDefaults.standard.set(timerType, forKey: "timerType")
    UserDefaults.standard.set(timerTitle, forKey: "timerTitle")
    UserDefaults.standard.set(timerStarted, forKey: "timerStarted")
    if let encodedItems = try? JSONEncoder().encode(weekdayTimers) {
        UserDefaults.standard.set(encodedItems, forKey: "weekdayTimers")
    }
}

func loadData() {
    if let x = UserDefaults.standard.data(forKey: "limitQuests") {
        userLimitQuests = try! JSONDecoder().decode([Quest].self, from: x)
    }
    if let y = UserDefaults.standard.data(forKey: "dailyQuests") {
        userDailyQuests = try! JSONDecoder().decode([Quest].self, from: y)
    }
    if let z = UserDefaults.standard.data(forKey: "mainQuests") {
        userMainQuests = try! JSONDecoder().decode([Quest].self, from: z)
    }
    if let y = UserDefaults.standard.data(forKey: "repeatQuests") {
        userRepeatQuests = try! JSONDecoder().decode([Quest].self, from: y)
    }
    if let h = UserDefaults.standard.data(forKey: "inventory") {
        userInventory = try! JSONDecoder().decode([Item].self, from: h)
    }
    if let i = UserDefaults.standard.data(forKey: "items") {
        userItems = try! JSONDecoder().decode([Item].self, from: i)
    }
    if let j = UserDefaults.standard.data(forKey: "shop") {
        userShop = try! JSONDecoder().decode([Item].self, from: j)
    }
    if let k = UserDefaults.standard.data(forKey: "fund") {
        bank = try! JSONDecoder().decode([Int].self, from: k)
    }
    if let s = UserDefaults.standard.data(forKey: "tax") {
        tax = try! JSONDecoder().decode([Int].self, from: s)
    }
    taxableStartTime = UserDefaults.standard.object(forKey: "daystart") as! Date
    if let p = UserDefaults.standard.data(forKey: "dailyrecord") {
        dailyRecord = try! JSONDecoder().decode(DailyRecord.self, from: p)
    }
}

func loadTimers() {
    if let l = UserDefaults.standard.data(forKey: "timerData") {
        timerData = try! JSONDecoder().decode([Date].self, from: l)
    }
        timerType = UserDefaults.standard.integer(forKey: "timerType")
    timerTitle = UserDefaults.standard.string(forKey: "timerTitle") ?? ""
    timerStarted = UserDefaults.standard.integer(forKey: "timerStarted")
    if let l = UserDefaults.standard.data(forKey: "weekdayTimers") {
        weekdayTimers = try! JSONDecoder().decode([[TimerData]].self, from: l)
    }
}

extension Int {
    var randomNum :Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}

extension Date {
func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
}
