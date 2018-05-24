//
//  ResetPasswordViewController.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Forgot Password"
        emailTextField.becomeFirstResponder()
    }

    @IBAction func resetPassword(_ sender: Any) {
        guard let emailAddress = emailTextField.text, emailAddress != "" else {
                //Alertar al usuario
                let alert = UIAlertController(title: "Input Error", message: "Comprueba que tu correo es correcto", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
                return
        }
        
        //Resetear Contraseña  
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            let title = (error == nil) ? "Password reseteado" : "Error al resetear"
            let mensaje = (error == nil) ? "Te hemos enviado un email para resetear tu contraseña" : error?.localizedDescription
            
            let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                if error == nil {
                    self.view.endEditing(true)
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            })
            alerta.addAction(ok)
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
