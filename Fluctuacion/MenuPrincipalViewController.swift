//
//  MenuPrincipalViewController.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MenuPrincipalViewController: ViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        Auth.auth().signIn(withEmail: "jromerof@gmail.com", password: "hikari") { (user, error) in
            if let error = error {
                return
            }
 
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    @IBAction func agregarCompra(_ sender: Any) {
        self.performSegue(withIdentifier: "addCompra", sender: nil)
    }


    
    @IBAction func historialCompras(_ sender: Any) {
        //self.performSegue(withIdentifier: "showCharts", sender: nil)
        //self.performSegue(withIdentifier: "showPreChart", sender: nil)
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("productos")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var productos = [Producto]()
                    for document in querySnapshot!.documents {
                        let producto = Producto(nombre: document.data()["nombre"] as! String, descripcion: document.data()["descripcion"] as! String, marca: document.data()["marca"] as? String, precio: nil)
                        productos.append(producto)
                    }
                    self.performSegue(withIdentifier: "showPreChart", sender: productos)
                }
        }
    }
    
    @IBAction func productos(_ sender: Any) {
        //cargarProductos(ventana: "productos")
        
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("productos")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var productos = [Producto]()
                    for document in querySnapshot!.documents {
                        let producto = Producto(nombre: document.data()["nombre"] as! String, descripcion: document.data()["descripcion"] as! String, marca: document.data()["marca"] as? String, precio: nil)
                        productos.append(producto)
                    }
                    self.performSegue(withIdentifier: "productos", sender: productos)
                }
        }

 }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productos" {
            let productos = sender as! [Producto]
            let vc = segue.destination as! ProductosTableViewController
            vc.productos = productos
        }else if segue.identifier == "showPreChart" {
            let productos = sender as! [Producto]
            let vc = segue.destination as! PreChartTableViewController
            vc.productos = productos
        }else if segue.identifier == "addCompra"{
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! MiCompraTableViewController
            vc.completionHandler = {(succes) in
                if succes == true{
                    self.perform(#selector(self.showSuccessAlert), with: nil, afterDelay: 0.1)
                }else{
                    self.perform(#selector(self.showErrorAlert), with: nil, afterDelay: 0.1)
                }
            }
        }
    }
    
    @objc func showSuccessAlert() {
        let alerta = UIAlertController(title: "Productos guardados", message: "Se ha registrado correctamente la compra en su historial", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
    @objc func showErrorAlert() {
        let alerta = UIAlertController(title: "Error al guardar productos", message: "No se ha podido guardar la compra, intentalo más tarde", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
    
    
}
