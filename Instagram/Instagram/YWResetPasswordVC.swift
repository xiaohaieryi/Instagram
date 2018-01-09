//
//  YWResetPasswordVC.swift
//  Instagram
//
//  Created by 于武 on 2017/12/23.
//  Copyright © 2017年 于武. All rights reserved.
//

import UIKit

class YWResetPasswordVC: UIViewController {
    //电子邮箱
    @IBOutlet weak var emailTxt: UITextField!
    //重置密码按纽
    @IBOutlet weak var resetBtn: UIButton!
    //取消重置按钮
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //设置背景图片
        let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        bgImageView.image = UIImage.init(named: "backImage.jpg")
        bgImageView.layer.zPosition = -1
        self.view.addSubview(bgImageView)
        // UI元素布局
        let viewWidth = self.view.frame.width
        
      emailTxt.frame = CGRect.init(x: 10, y: 120, width:viewWidth, height: 30)
      resetBtn.frame = CGRect.init(x: 20, y: emailTxt.frame.origin.y + 50, width:viewWidth/4, height: 30)
      cancelBtn.frame = CGRect.init(x: viewWidth/4*3 - 20, y:resetBtn.frame.origin.y, width:viewWidth/4, height: 30)
  
        //隐藏键盘手势
        let hideTap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTouchesRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }
   
    //重置按钮点击方法
    @IBAction func resetBtn_clicked(_ sender: UIButton) {
        
        //隐藏键盘
        self.view.endEditing(true)
        //空输入提示框
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController.init(title: "请注意", message: "电子邮件不能为空！", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //重置密码到服务器
        AVUser.requestPasswordResetForEmail(inBackground: "请注意！") { (success: Bool, error:Error?) in
            //发送成功
            if success {
                let alert = UIAlertController.init(title: "请注意", message: "重置密码链接已发送到您电子邮件！", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "OK", style: .default, handler: ({ (_) in
                    self.dismiss(animated: true, completion: nil )}))
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            //请求失败
            }else {
                
                print(error?.localizedDescription ?? "无")
            }
            
            
        }
        
    }
    //取消按钮点击方法
    @IBAction func cancelbtn_clicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    //触摸手势的方法
    /// 隐藏视图中的虚拟键盘
    ///
    /// - Parameter recognizer: 触摸手势
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer)  {
        
        self.view.endEditing(true)
    }

}
