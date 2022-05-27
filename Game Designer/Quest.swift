//
//  Quest.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import Foundation

struct Quest : Codable{
    var name : String
    var type : Int
    var reward : [Item]
    var description : String
    var dueDate : Date?
    var dayRemaining : Int?
    var repeats : [String] = []
    var doneDate : Date?
    var done : Bool?
    var evenDays : Bool?
    var diminish : Bool?
    var dateStarted : Date?
    
    init (_ name : String, _ description : String,_ type : Int, reward : [Item]) {
        self.name = name
        self.description = description
        self.type = type
        self.reward = reward
    }
}
