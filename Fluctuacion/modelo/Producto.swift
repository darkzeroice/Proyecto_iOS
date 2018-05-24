//
//  Producto.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit

class Producto: NSObject {
    var nombre: String!
    var descripcion: String?
    var marca: String?
    var precio: String?
    
    init(nombre: String, descripcion: String?, marca: String?, precio: String?){
        self.nombre = nombre
        self.descripcion = descripcion
        self.marca = marca
        self.precio = precio
    }
}
