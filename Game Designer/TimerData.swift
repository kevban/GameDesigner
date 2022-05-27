//
//  TimerData.swift
//  Game Designer
//
//  Created by jhp on 2018-12-21.
//  Copyright © 2018 Papaya. All rights reserved.
//

import Foundation
struct TimerData : Codable {
    var startTime : Date
    var endTime : Date
    var duration : String
    var minutes : Int
    var type : Int
    var title : String
    
    init (startTime : Date, endTime : Date, type: Int, title : String) {
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
        self.title = title
        self.minutes = -Int((self.startTime.timeIntervalSince(self.endTime)+1)/60)
        let hours = Int(minutes/60)
        if hours > 1 {
        self.duration = "\(hours) hours \(minutes-(hours*60)) minutes"
        } else if hours > 0{
            self.duration = "\(hours) hour \(minutes-(hours*60)) minutes"
        } else {
            self.duration = "\(minutes) minutes"
        }
    }
}
