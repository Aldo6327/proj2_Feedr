//
//  LoginVC.swift
//  AldoAProject2
//
//  Created by Aldo Ayala on 10/29/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: ViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
//        if let user = user {
//            let uid = user.uid
//            let email = user.email
//            let photoURL = user.photoURL
//            print(user.displayName, uid, email, photoURL)
        
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginbutton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userName.text!, password: password.text!) {
            (user, error) in
            
            if user != nil && error == nil {
                
                print("LOGIN : The user is logged in now as \(user?.email!)")
            } else {
                print("Here is the error: \(error)")
                print("Here is the user: \(user)")
            }
        }
    }
    @IBAction func signUp(_ sender: Any) {
        let alert = UIAlertController(title: "Signup", message: "Sign up", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                Auth.auth().signIn(withEmail: self.userName.text!, password: self.password.text!)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
