//
//  MiCompraTableViewController.swift
//  Fluctuacion
//
//  Created by jorge on 15/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MiCompraTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore()
    var misProductos = [Producto]()
    
    var completionHandler: ((Bool) -> Swift.Void)?
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func guardarCompra(_ sender: Any) {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd_HHmmss"
        
        let timestamp = dateFormatterGet.string(from: Date())
        
        for producto in misProductos{
            
            var miCompra = ["fecha": timestamp]
            
        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("compras").document(timestamp).setData(miCompra) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    miCompra["precio"] = producto.precio
                    miCompra["nombre"] = producto.nombre
                self.db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("compras").document(timestamp).collection("historial").document(producto.nombre).setData(miCompra) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            self.completionHandler!(err == nil ? true : false)
                            /*let title = (err == nil) ? "Productos guardados" : "Error al guardar productos"
                            let mensaje = (err == nil) ? "Se ha registrado correctamente la compra en su historial" : "No se ha podido guardar la compra, intentalo más tarde"
                            let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
                            alerta.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alerta, animated: false, completion: nil)*/
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return misProductos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductoTableViewCell
        
        // Configure the cell...
        cell.nombre.text? = misProductos[indexPath.row].nombre
        cell.descripcion.text? =  misProductos[indexPath.row].descripcion!
        cell.marca.text? =  misProductos[indexPath.row].marca!
        cell.precio.text = misProductos[indexPath.row].precio! + " €"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func agregar(_ sender: Any) {
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
                    self.performSegue(withIdentifier: "selectProducto", sender: productos)
                }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectProducto" {
            let productos = sender as! [Producto]
            let vc = segue.destination as! SelectProductoViewController
            vc.productos = productos
            vc.completionHandler = {(producto) in
                self.misProductos.append(producto)
                self.tableView.reloadData()
            }
        }
    }
    

}
