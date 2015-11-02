//
//  CalendarCollectionViewCell.swift
//  Poi
//
//  Created by koooootake on 2015/08/20.
//  Copyright (c) 2015年 koooootake. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    var textLabel : UILabel?
    var numberLabel : UILabel?
    var iconImageView : UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //日付
        textLabel = UILabel(frame: CGRectMake(0, 0, frame.width/3, frame.height/3))
        textLabel?.text = "nil"
        textLabel?.font = UIFont.systemFontOfSize(frame.width/4)
        textLabel?.textAlignment = NSTextAlignment.Center
        //本数
        numberLabel = UILabel(frame: CGRectMake(0, 5, frame.width, frame.height))
        numberLabel?.font = UIFont.systemFontOfSize(frame.width/2)
        numberLabel?.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        numberLabel?.textColor = UIColor.whiteColor()
        numberLabel?.textAlignment = NSTextAlignment.Center
        //背景
        iconImageView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        
        // Cellに追加.
        self.contentView.addSubview(iconImageView!)
        self.contentView.addSubview(textLabel!)
        self.contentView.addSubview(numberLabel!)
    }
    
    
    
}
