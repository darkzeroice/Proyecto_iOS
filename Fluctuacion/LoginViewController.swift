//
//  LogonViewController.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let db = Firestore.firestore()

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Correo", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //self.title = "Log In"
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = ""
    }
    
    @IBAction func login(_ sender: Any) {
        //Validar los campos
        guard let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                //Alertar al usuario
                let alert = UIAlertController(title: "Error de Login", message: "Comprueba que no hay ningún campo vacío", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                return
        }
        
        //Autenticamos al usuario a través de Firebase
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (user, error) in
            if let error = error {
                //Alertar al usuario
                let alert = UIAlertController(title: "Error de Login", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //Ocultamos el teclado
            self.view.endEditing(true)
            
            //Lanzamos al Main View
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
