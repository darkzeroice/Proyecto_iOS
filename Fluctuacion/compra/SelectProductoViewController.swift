//
//  SelectProductoViewController.swift
//  Fluctuacion
//
//  Created by jorge on 15/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit

class SelectProductoViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var productos: [Producto]!
    var completionHandler: ((Producto) -> Swift.Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductoTableViewCell
        
        // Configure the cell...
        cell.nombre.text? = self.productos[indexPath.row].nombre
        cell.descripcion.text? = self.productos[indexPath.row].descripcion!
        cell.marca.text? = self.productos[indexPath.row].marca!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let producto = self.productos[indexPath.row]
        let alert = UIAlertController(title: producto.nombre, message: "Ingrese el precio", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Aceptar", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            producto.precio = textField.text
            //devolvemos producto
            self.completionHandler!(producto)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .default) { (alertAction) in
            //let textField = alert.textFields![0] as UITextField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Precio"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated:true, completion: nil)
    }
    

}
