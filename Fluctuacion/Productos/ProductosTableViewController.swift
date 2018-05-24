//
//  ProductosTableViewController.swift
//  Fluctuacion
//
//  Created by proyecto on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProductosTableViewController: UITableViewController{

    let db = Firestore.firestore()
    
    var productos: [Producto]!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //cambia este color
        self.navigationController?.view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 255/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductoTableViewCell
        
        // Configure the cell...
        cell.nombre.text? = self.productos[indexPath.row].nombre
        cell.descripcion.text? = self.productos[indexPath.row].descripcion!
        cell.marca.text? = self.productos[indexPath.row].marca!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexpath) in
            self.db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("productos").document(self.productos[indexPath.row].nombre)
                .delete(){ err in
                    let productosSaved = self.productos
                    //Falta probar si es una copia y no un puntero
                    self.productos.remove(at: indexPath.row)
                    if let err = err {
                        print("Error removing document: \(err)")
                        self.productos = productosSaved as! [Producto]
                    } else {
                        print("Document successfully removed!")
                    }
                    tableView.reloadData()
            }
            
        }
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detalle", sender: productos[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalle" {
            let producto = sender as? Producto
           
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! AddProductTableViewController
            vc.producto = producto
            vc.completionHandler = {(producto) in
               //Si he llegado aquí significa que firebase ha ido bien
               //En vez de actualizar todo de firebase, compruebo si es un producto que ya tuviera y lo actualizo, y sino añado un nuevo producto al array
                let index = self.productos.index(of: producto)
                if index == nil{
                    self.productos.append(producto)
                }else{
                    self.productos[index!] = producto
                }
                self.tableView.reloadData()
            }
            
        }
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

}
