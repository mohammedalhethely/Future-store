//
//  signUpViewController.swift
//  Future store
//
//  Created by Mohammed Abdullah on 08/05/1443 AH.


import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class signUpViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Phonenumber : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UserApi.getUser(uid: Auth.auth().currentUser?.uid ?? "") { user in
        //            print(user.email ?? "")
        //        }
    }
    
    @IBAction func enterBotton(_ sender: Any) {
        SignUp(email: email.text ?? "", password: password.text ?? "", phon: Phonenumber.text ?? "", name: name.text ?? "")
    }
    //Go from the registration page to Augomented realty
    
    func presentSwiftUIView() {
        let swiftUIView = ContentView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
    
    func SignUp(email: String,password:String,phon:String,name:String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            print("email:\(String(describing: authResult?.user.email))")
            print("uid:\(String(describing: authResult?.user.uid))")
            
            UserApi.addUser(name: name, uid: authResult?.user.uid ?? "", phone: phon, email: email) { check in
                
                if check {
                    print("Done saving in Database")
                    
                    self.presentSwiftUIView()
                    
                } else {
               }
              }
             }
            }
           }
