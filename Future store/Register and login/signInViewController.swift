//  signInViewController.swift
//  Future store
//
//  Created by Mohammed Abdullah on 08/05/1443 AH.


import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class signInViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            presentSwiftUIView()
        }
       }
    @IBAction func signInAction(_ sender: UIButton) {
        
        SignIn(email: email.text ?? "", password: password.text ?? "")
        
    }
    
    //Go from the registration page to Augomented realty
    
    func presentSwiftUIView() {
        let swiftUIView = ContentView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
    func SignIn(email: String,password:String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                
                self.showAlert(withTitel: "please check your password and email", messege: "re-enter email and password", isLogin: false)
                
                print(error.localizedDescription)
            } else {
                self.presentSwiftUIView()
            }
            print("email:\(String(describing: authResult?.user.email))")
            print("uid:\(String(describing: authResult?.user.uid))")
            // ...
        }
       }
    func showAlert (withTitel titel:String,messege:String,isLogin:Bool){
        let alert = UIAlertController(title: "Erore", message: messege, preferredStyle: .alert)
        let okAcction = UIAlertAction(title: "ok", style: .default, handler: { action in if isLogin {
        }else{
        }
      })
        alert.addAction(okAcction)
        self.present(alert,animated: true)
      }
     }
