//
//  YWSignInVC.swift
//  Instagram
//
//  Created by 于武 on 2017/12/23.
//  Copyright © 2017年 于武. All rights reserved.
//

import UIKit

class YWSignInVC: UIViewController {
   //标题lable
    @IBOutlet weak var lable: UILabel!
    //用户名输入框
    @IBOutlet weak var userNameTextFile: UITextField!
    //密码输入框
    @IBOutlet weak var passwordTxt: UITextField!
    //忘记密码按钮
    @IBOutlet weak var forgotBtn: UIButton!
    //登录按钮
    @IBOutlet weak var signInBtn: UIButton!
    //注册按钮
    @IBOutlet weak var signUpBtn: UIButton!
    

    
    //注册按钮方法
    @IBAction func signUpBtn(_ sender: UIButton) {
    }
    //忘记密码按钮方法
    @IBAction func forgotBtn(_ sender: UIButton) {
    }
    //登录按钮方法
    @IBAction func signInBtn(_ sender: UIButton) {
        //隐藏键盘
        self.view.endEditing(true)
      
        if userNameTextFile.text!.isEmpty || passwordTxt.text!.isEmpty  {
            
            //弹出警示框
            let alert = UIAlertController (title:"请注意",message: "请填写好所有字段" ,preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel, handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true, completion: nil)
            
            return
        }
        //实现用户登录功能
        AVUser.logInWithUsername(inBackground: userNameTextFile.text!, password: passwordTxt.text!) { (user: AVUser?, error: Error?) in
            if error == nil {
                
                //记住用户
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                //调用AppDelegate类的login方法
                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
                
            }
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //设置字体
        lable.font = UIFont.init(name: "Pacifico", size: 25)
        //设置背景图片
        let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        bgImageView.image = UIImage.init(named: "backImage.jpg")
        bgImageView.layer.zPosition = -1
        self.view.addSubview(bgImageView)
        
        //代码布局各控件
        lable.frame = CGRect.init(x: 10, y: 80, width: self.view.frame.width, height: 50)
        userNameTextFile.frame = CGRect.init(x: 10, y: lable.frame.origin.y + 70, width: self.view.frame.width - 20, height: 30)
        passwordTxt.frame = CGRect.init(x: 10, y: userNameTextFile.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        forgotBtn.frame = CGRect.init(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.width - 20, height: 30)
        signInBtn.frame = CGRect.init(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.width/4, height: 30)
        signUpBtn.frame = CGRect.init(x: self.view.frame.width - signInBtn.frame.width - 20, y: signInBtn.frame.origin.y, width: signInBtn.frame.width, height: 30)
       
        //隐藏键盘手势
        let hideTap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //触摸手势方法
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer)  {
        
        self.view.endEditing(true)
        
    }
    
    
}
