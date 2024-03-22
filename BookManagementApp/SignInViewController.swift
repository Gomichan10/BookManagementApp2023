//
//  SignInViewController.swift
//  BookManagementApp
//
//  Created by Gomi Kouki on 2023/11/09.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func SignInButton(_ sender: Any) {
        auth()
    }
    
    private func auth(){
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self){ [unowned self] user,error in
            if let error = error {
                print("GIDSignInError:\(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.user,
                  let idToken = authentication.idToken?.tokenString else{return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken.tokenString)
            Auth.auth().signIn(with: credential){(authResult,error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: "main", sender: nil)
                }
            }
            
        }
    }

}
