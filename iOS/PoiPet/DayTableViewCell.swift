//
//  DayTableViewCell.swift
//  PoiPet
//
//  Created by koooootake on 2015/11/15.
//  Copyright © 2015年 koooootake. All rights reserved.
//


import UIKit

class DayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
//    @IBOutlet weak var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.borderWidth = 3.0
        backView.layer.borderColor = UIColor(red: 240.0/255.0, green: 125.0/255.0, blue: 50.0/255.0, alpha: 1.0).CGColor//オレンジ
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(Day:PoiModel){
        self.timeLabel.text = Day.time
        self.placeLabel.text = Day.place
        
    }

    
}
