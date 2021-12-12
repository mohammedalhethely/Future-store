//
//  signUpViewController.swift
//  Future store
//
//  Created by Mohammed Abdullah on 08/05/1443 AH.
//

import UIKit

class signUpViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Phonenumber : UITextField!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
    
    }
    func SignUp(name: String ,email: String,password:String,phonenumber:Int) {
    Auth.auth().createUser(withName: name, Email: email, password: password,phonenumber:phonenumber ) { authResult, error in

    print("email:\(String(describing: authResult?.user.email))")
    print("uid:\(String(describing: authResult?.user.uid))")
    
   UserApi.addUser(name: "mohammed", uid: authResult?.user.uid ?? "", phone: "7117", email: email) { check in
    if check {
    print("Done saving in Database")
    } else {
    
       }
      }
     }
    }
   }
