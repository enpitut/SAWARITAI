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
    var image:UIImage

    
    init(time: String, place:String, color:UIColor, image:UIImage) {
        
        self.time = time
        self.place = place
        self.color = color
        self.image = image
        
    }
    
}
