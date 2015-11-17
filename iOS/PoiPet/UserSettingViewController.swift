//
//  UserSettingViewController.swift
//  PoiPet
//
//  Created by koooootake on 2015/11/13.
//  Copyright © 2015年 koooootake. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController, UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate {
    
    @IBOutlet weak var RegistrationIDTextField: AkiraTextField!
    @IBOutlet weak var UserNameTextField: AkiraTextField!
    
    var registrationID: String = ""
    var userName: String = ""
    
    @IBOutlet weak var RegistrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RegistrationIDTextField.delegate=self
        RegistrationIDTextField.tag=0
        UserNameTextField.delegate=self
        UserNameTextField.tag=1
        
        
        RegistrationButton.enabled=false
        RegistrationButton.alpha=0.5
       
    }
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(textField: UITextField){
        RegistrationButton.enabled=false
        RegistrationButton.alpha=0.5
    }
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        switch textField.tag{
        case 0:
            registrationID=textField.text!
            print("RegistrationID:\(textField.text!)")
            
        case 1:
            userName=textField.text!
            print("UserName:\(textField.text!)")
        default:
            break
        }
        
        if Int(registrationID) != nil && registrationID.characters.count == 4 && userName != ""{
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
        
        print("Registration Start")
        
        let post="tmp_id=\(registrationID)&user_name=\(userName)"
        let postData=post.dataUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string:"http://poipet.ml/signup")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod="POST"
        request.HTTPBody=postData
        
        //let config:NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundTask")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(request)
        
        task.resume()
        
    }
    
    //通信終了
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        let userID:String = String(data: data, encoding: NSUTF8StringEncoding)!
        
        // バックグラウンドだとUIの処理が出来ないので、メインスレッドでUIの処理を行わせる.
        dispatch_async(dispatch_get_main_queue(), {
            
            //成功
            if Int(userID) != nil {
                print("UserID:\(Int(userID)!)")
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                
                userDefault.setObject("\(Int(userID)!)", forKey: "ID")
                userDefault.synchronize()
                
                print("Registration Finish")
                
                let alert:UIAlertController = UIAlertController(title: "登録完了！", message: "\(userID)\n\(self.registrationID)->\(self.userName)", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                    action in
                        self.dismissViewControllerAnimated(true, completion: nil)
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                //失敗
            }else{
                print("Error:\(userID)")
                
                let alert:UIAlertController = UIAlertController(title: "登録失敗！", message: "\(userID)\n\(self.registrationID)->\(self.userName)", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default) {
                action in
                
                }
                //alert.view.tintColor = UIColor(red: 240.0/255.0, green: 125.0/255.0, blue: 50.0/255.0, alpha: 1.0)//オレンジ
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })
        
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
}
