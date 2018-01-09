//
//  YWSignUpVC.swift
//  Instagram
//
//  Created by 于武 on 2017/12/23.
//  Copyright © 2017年 于武. All rights reserved.
//

import UIKit
import NotificationCenter
class YWSignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
     //滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    //根据视图需要，设置滚动视图的高度
    var scrollViewHight: CGFloat = 0
    //获取键盘的大小和高度
    var keyboard: CGRect = CGRect()
    
    //imageView 用于头像显示
    @IBOutlet weak var avaImg: UIImageView!
    
    //用户名、密码、重复密码、电子邮件
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    //姓名、简介、网站
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    //为按钮创建关联
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //按钮点击事件
    @IBAction func signUpBtn_clicked(_ sender: UIButton) {
        //隐藏键盘
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty||passwordTxt.text!.isEmpty||repeatPasswordTxt.text!.isEmpty||emailTxt.text!.isEmpty||fullnameTxt.text!.isEmpty||bioTxt.text!.isEmpty||webTxt.text!.isEmpty {
            //弹出警示框
            let alert = UIAlertController (title:"请注意",message: "请填写好所有字段" ,preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel, handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true, completion: nil)
            
        }
        
        //检测两次输入的密码是否一致
        if passwordTxt.text != repeatPasswordTxt.text {
            //弹出警示框
            let alert = UIAlertController (title:"请注意",message: "两次输入的密密码不一致" ,preferredStyle: .alert)
            let ok = UIAlertAction(title:"OK", style: .cancel, handler:nil)
            alert.addAction(ok)
            self.present(alert,animated: true, completion: nil)
            
            return
        }
        
        //发送数据到服务器相关的列
        let user  = AVUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text?.lowercased()
        
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["bio"] = bioTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["gender"] = ""
        
        //转换头像数据并发送到服务器
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = AVFile(name: "ava.jpg",data: avaData!)
        user["ava"] = avaFile
        //注册成功后立刻进行登录
        user.signUpInBackground { (success:Bool, error: Error?) in
            //如果登录成功
            if success {
                print("注册成功！")
                AVUser.logInWithUsername(inBackground: user.username!, password: user.password!, block: { (user: AVUser?, error: Error?) in
                    
                    if let user = user //如果右边user拆包后不为nil,则将其赋值给左边的user并执行if中的代码
                    {
                        //记住用户
                        UserDefaults.standard.set(user.username, forKey: "username")
                        UserDefaults.standard.synchronize()
                        //从appdelegate调用登录方法
                        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.login()
                        
                    }
                    
                })
                
    
         }else{
                print(error?.localizedDescription as Any )
             }
            
        }
    }
    @IBAction func cancelBtn_clicked(_ sender: UIButton) {
        
        //以动画方式除去通过modally方式添加进来的控制器
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置背景图片
        let bgImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        bgImageView.image = UIImage.init(named: "backImage.jpg")
        bgImageView.layer.zPosition = -1
        self.view.addSubview(bgImageView)
     
        //滚动视图的窗口尺寸
         scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //定义滚动视图的内容尺寸与窗口尺寸一样
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHight = self.view.frame.height
        
        //检测键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        //添加手势
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //添加图片手势
        let imgTap = UITapGestureRecognizer(target:self, action: #selector(loadImg))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
        
        //改变avaImg的外观为圆形
        avaImg.layer.cornerRadius = avaImg.frame.width/2
        avaImg.clipsToBounds = true
        
        //UI元素布局
         avaImg.frame = CGRect.init(x: self.view.frame.width/2 - 40, y: 40, width: 80, height: 80)
        
        let viewWidth = self.view.frame.width
       
        
        usernameTxt.frame = CGRect.init(x: 10, y: avaImg.frame.origin.y + 90, width: viewWidth - 20, height: 30)
        passwordTxt.frame = CGRect.init(x: 10, y: usernameTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
        repeatPasswordTxt.frame = CGRect.init(x: 10, y: passwordTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
       
        emailTxt.frame = CGRect.init(x: 10, y: repeatPasswordTxt.frame.origin.y + 60, width: viewWidth - 20, height: 30)
        fullnameTxt.frame = CGRect.init(x: 10, y: emailTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
        bioTxt.frame = CGRect.init(x: 10, y: fullnameTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
        webTxt.frame = CGRect.init(x: 10, y: bioTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
        
        signUpBtn.frame = CGRect.init(x: 20, y: webTxt.frame.origin.y + 50, width: viewWidth/4, height: 30)
        cancelBtn.frame = CGRect.init(x: viewWidth - viewWidth/4 - 20, y: signUpBtn.frame.origin.y, width: viewWidth/4, height: 30)
        
        
    }
  
/// 当键盘出现时调用的方法
    ///
    /// - Returns:
    @objc func showKeyboard(notification: Notification)  {
        
        //定义键盘的大小
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        //当虚拟键盘出现后，滚动视图的实际高度缩小为屏幕减去键盘的高度
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHight - self.keyboard.size.height
        }
        
    }
    
    /// 当键盘消失时调用的方法
    ///
    /// - Returns:
    @objc func hideKeyboard(notification: Notification)  {
        
        //当虚拟键盘消失后，滚动视图高度恢复为屏幕高度
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.size.height
        }
    }
    
    //触摸手势的方法
    /// 隐藏视图中的虚拟键盘
    ///
    /// - Parameter recognizer: 触摸手势
    @objc func hideKeyboardTap(recognizer: UITapGestureRecognizer)  {
        
        self.view.endEditing(true)
    }
    
    @objc func loadImg(recognizer: UITapGestureRecognizer)  {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true, completion: nil)
        
    }
    
    
    /// 选择图片完成
    ///
    /// - Parameters:
    ///   - picker: 选择器对象
    ///   - info: 用户信息
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// 取消选择
    ///
    /// - Parameter picker: 选择器对象
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    
}



