//
//  SignUpViewController.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    let db = Firestore.firestore()

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

        nameTextField.attributedPlaceholder = NSAttributedString(string: "Nombre", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Correo", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Contraseña", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            
            //NSAttributedString(string:"Test Data for place holder", attributes:[NSForegroundColorAttributeName: UIColor.blueColor(),NSFontAttributeName :UIFont(name: "Arial", size: 10)!])
        
        //self.title = "Sign Up"
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        //Validamos los campos
        guard let name = nameTextField.text, name != "",
            let emailAddress = emailTextField.text, emailAddress != "",
            let password = passwordTextField.text, password != "" else {
                //Alertar al usuario
                let alert = UIAlertController(title: "Error de Registro", message: "Comprueba que no hay ningún campo vacío", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                return
        }
        
        //Registrar al usuario en Firebase!
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (user, error) in
            //Error
            if let error = error {
                //Alertar al usuario
                let alert = UIAlertController(title: "Error de Registro", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                let uid = Auth.auth().currentUser?.uid
                self.db.collection("users").document((uid)!).setData([
                    "nombre": self.nameTextField.text!,
                    "email": self.emailTextField.text!,
                    "uid": Auth.auth().currentUser?.uid
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            //Guardamos el nombre del usuario
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Error al cambiar el display name: \(error.localizedDescription)")
                    }
                })
            }
            
            //Ocultar el teclado
            self.view.endEditing(true)
            
            //Volvemos a la vista principal
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
