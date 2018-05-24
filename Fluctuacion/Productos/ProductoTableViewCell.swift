//
//  ProductoTableViewCell.swift
//  Fluctuacion
//
//  Created by jorge on 17/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var precio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
