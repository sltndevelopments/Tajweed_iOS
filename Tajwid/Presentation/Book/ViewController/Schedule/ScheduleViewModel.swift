//
//  ScheduleViewModelInterface.swift
//  Tajwid
//
//  Created by Ilnaz Mannapov on 15.10.2022.
//  Copyright © 2022 teorius. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ScheduleViewModelInterface {
    func getScheduleData(cl: @escaping ([Group]) -> ())
}

class ScheduleViewModel: ScheduleViewModelInterface {
    func getScheduleData(cl: @escaping ([Group]) -> ()) {
        
        var ref = Database.database().reference()
        
        let gr = ref.observe(.value, with: { data in
            let groups = (data.value as? [String:Any?])?["groups"] as? Array<Any>
            
            cl(groups?.map { gr in
                let g = gr as? [String:Any?]
                
                let schedule = ((g?["schedule"] as? Array<Any>)?.map {dt in
                    
                    let s = dt as? [String: Any?]
                    
                    return Schedule(time: s?["time"] as? String ?? "",
                             day: s?["day"] as? String ?? "",
                             teacher: s?["teacher"] as? String ?? "")
                }) ?? []
                
                return Group(name: g?["name"] as? String ?? "",
                                  link: g?["link"] as? String ?? "",
                                  price: g?["price"] as? String ?? "",
                             schedule: schedule as? [Schedule] ?? [])
            } ?? [])
        })
    
        
        //stub
//        return [
//            Group(name: "Мужской", link: "test", price: "600", schedule: [
//                Schedule(time: "20:30", day: "Вторник", teacher: "ХаджиМурат хазрат"),
//                Schedule(time: "20:30", day: "Четверг", teacher: "ХаджиМурат хазрат"),
//                Schedule(time: "20:30", day: "Суббота", teacher: "ХаджиМурат хазрат"),
//            ]),
//            Group(name: "Женский", link: "test", price: "test", schedule: []),
//        ]
    }
    
    
}
