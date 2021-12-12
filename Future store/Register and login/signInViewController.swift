//
//  signInViewController.swift
//  Future store
//
//  Created by Mohammed Abdullah on 08/05/1443 AH.
//

import UIKit

class User {
var name:String = ""
var age:Int = 0
var password:Int = 0

init(name:String, age:Int, userPassword:Int){
    self.name = name
    self.age = age
    self.password = userPassword
}
}
class signInViewController: UIViewController {
   
        
        @IBOutlet weak var userName: UITextField!
        @IBOutlet weak var password: UITextField!
        @IBOutlet weak var signIn: UIButton!
        
        
        var userAm = User(name: "mohammed", age: 26, userPassword: 10730)
        var userRm = User(name: "raed",age: 30, userPassword: 21209)
        var userFm = User(name: "faisal", age: 18, userPassword: 48901)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        
        
        
        
        
        @IBAction func signInAction(_ sender: UIButton) {
            guard let userName = userName.text else {return}
            guard let userPassword = Int(password.text ?? "0")else {return}
            if userAm.name == userName && userAm.password == userPassword {
                //displayAlert(withTitle: "Done", message: "", isLogin: true)
                performSegue(withIdentifier: "homePage", sender: nil)
            }else{
                displayAlert(withTitle: "The username or password is incorrect", message: "", isLogin: false)
            }
            
        }
        
        
        
        func displayAlert(withTitle title:String, message:String, isLogin:Bool) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Fine", style: .default, handler: {
                action in if isLogin {
                    self.performSegue(withIdentifier: "homeScreen", sender: nil)
                }else{
                    
                }
            })
            alert.addAction(okAction)
            self.present(alert,animated: true)
        }
        func userLogin() {
            
            
            guard let userName = userName.text else {return}
            guard let userPassword = Int(password.text ?? "0")else {return}
            if userAm.name == userName && userAm.password == userPassword {
                displayAlert(withTitle: "Done", message: "", isLogin: true)
            }else{
                displayAlert(withTitle: "fail", message: "", isLogin: false)
            }
        }
        
    }
