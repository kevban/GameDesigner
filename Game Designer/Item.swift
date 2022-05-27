//
//  Item.swift
//  Game Designer
//
//  Created by jhp on 2018-08-20.
//  Copyright © 2018 Papaya. All rights reserved.
//

import Foundation
import UIKit

struct Item : Codable{
    var name : String
    var description : String
    var amount : [Int] = [0,0]
    var iconName : String
    init (_ name : String, _ description : String, icon : String){
        self.name = name
        self.description = description
        self.iconName = icon
    }
}


