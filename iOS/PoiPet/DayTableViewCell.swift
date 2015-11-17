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
    
    @IBOutlet weak var petImageView: UIImageView!
    
//    @IBOutlet weak var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.borderWidth = 3.0

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(poiModel:PoiModel){
        self.timeLabel.text = poiModel.time
        self.placeLabel.text = poiModel.place
        self.backView.layer.borderColor = poiModel.color.CGColor
        
        self.petImageView.backgroundColor = poiModel.color
        
    }

    
}
