//
//  ScheduleData.swift
//  Tajwid
//
//  Created by Ilnaz Mannapov on 15.10.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation

//class OnlineLearning{
//    let groups: [Group]
//
//    init(groups: [Group]) {
//        self.groups = groups
//    }
//}


class Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.name == rhs.name
    }
    
    let name: String
    let link: String
    let price: String
    let schedule: [Schedule]
    
    init(name: String, link: String, price: String, schedule: [Schedule]) {
        self.name = name
        self.link = link
        self.price = price
        self.schedule = schedule
    }
}

class Schedule {
    let time: String
    let day: String
    let teacher: String
    
    init(time: String, day: String, teacher: String) {
        self.time = time
        self.day = day
        self.teacher = teacher
    }
}
