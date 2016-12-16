//
//  ViewController.swift
//  Transprt
//
//  Created by Roman Sheydvasser on 12/15/16.
//  Copyright © 2016 RLabs. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signupMode = false
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var driverLbl: UILabel!
    @IBOutlet weak var passFld: UITextField!
    @IBOutlet weak var riderLbl: UILabel!
    @IBOutlet weak var isDriverSwitch: UISwitch!
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if signupMode {
            loginBtn.setTitle("Log In", for: [])
            signUpBtn.setTitle("Switch to Sign Up Mode", for: [])
            signupMode = false
        } else {
            loginBtn.setTitle("Sign Up", for: [])
            signUpBtn.setTitle("Switch to Log In Mode", for: [])
            signupMode = true
        }
    }
    
    @IBAction func riderSwitchPressed(_ sender: Any){
        let riderTxtColor = riderLbl.textColor
        riderLbl.textColor = driverLbl.textColor
        driverLbl.textColor = riderTxtColor
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        // sign up mode
        if signupMode {
            if emailFld.text == "" || passFld.text == "" {
                self.displayAlert(title: "Error in form", message: "Username and password are required.")
            } else {
                let user = PFUser()
                user.username = emailFld.text
                user.password = passFld.text
                user["isDriver"] = isDriverSwitch.isOn
                
                user.signUpInBackground(block: { (success, error) in
                    if let error = error as? NSError {
                        var displayedError = "Please try again later."
                        if let parseError = error.userInfo["error"] as? String {
                            displayedError = parseError
                        }
                        self.displayAlert(title: "Sign up failed.", message: displayedError)
                    } else {
                        print("Sign up successful.")
                    }
                })
            }
        // log in mode
        } else {
            PFUser.logInWithUsername(inBackground: emailFld.text!, password: passFld.text!, block: { (user, error) in
                if let error = error as? NSError {
                    var displayedError = "Please try again later."
                    if let parseError = error.userInfo["error"] as? String {
                        displayedError = parseError
                    }
                    self.displayAlert(title: "Log in failed.", message: displayedError)
                } else {
                    print("Log in successful.")
                }
                
            })
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

