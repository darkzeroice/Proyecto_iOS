//
//  AddProductTableViewController.swift
//  Fluctuacion
//
//  Created by jorge on 17/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase

class AddProductTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var producto: Producto?
    var completionHandler: ((Producto) -> Swift.Void)?
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var descripcion: UITextField!
    @IBOutlet weak var marca: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if producto != nil
        {
            nombre.text = producto?.nombre
            descripcion.text = producto?.descripcion
            marca.text = producto?.marca
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   


    @IBAction func guardar(_ sender: Any) {
    db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("productos").document(nombre.text!).setData([
            "nombre": nombre.text!,
            "descripcion": descripcion.text!,
            "marca": marca.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                if self.producto == nil{
                    self.producto = Producto(nombre: self.nombre.text!, descripcion: self.descripcion.text!, marca: self.marca.text!, precio: "")
                }else{
                    self.producto?.nombre = self.nombre.text!
                    self.producto?.descripcion = self.descripcion.text!
                    self.producto?.marca = self.marca.text!
                }
                self.completionHandler!(self.producto!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        print("Hola")
        self.dismiss(animated: true, completion: nil)
    }
    

}
