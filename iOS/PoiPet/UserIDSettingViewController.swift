//
//  UserIDSettingViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/11/15.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class UserIDSettingViewController: UIViewController, UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate {

    @IBOutlet weak var UserIDLabel: UILabel!
    @IBOutlet weak var UserIDTextField: AkiraTextField!
    var userID: String = ""
    
    @IBOutlet weak var RegistrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserIDTextField.delegate=self
        
        RegistrationButton.enabled=false
        RegistrationButton.alpha=0.5
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let userIDNow:String = userDefault.objectForKey("ID") as! String
        UserIDLabel.text = "Now : \(userIDNow)"
        
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
        //print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        userID=textField.text!
        print("UserID:\(textField.text!)")
        
        if userID != ""{
            RegistrationButton.enabled=true
            RegistrationButton.alpha=1.0
        }else{
            RegistrationButton.enabled=false
            RegistrationButton.alpha=0.5
        }
        return true
    }
    
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func RegistrationButton(sender: AnyObject) {
        
        print("Change UserID")
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        userDefault.setObject("\(Int(userID)!)", forKey: "ID")
        userDefault.synchronize()
        
        UserIDLabel.text = "\(Int(userID)!)"
        
    }
    
    

}