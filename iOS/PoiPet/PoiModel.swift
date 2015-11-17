//
//  DayModel.swift
//  Pods
//
//  Created by koooootake on 2015/11/15.
//
//

import Foundation

class PoiModel : NSObject {
    var time:String
    var place:String
    
    var color:UIColor

    
    init(time: String, place:String, color:UIColor) {
        
        self.time = time
        self.place = place
        self.color = color
        
    }
    
}
