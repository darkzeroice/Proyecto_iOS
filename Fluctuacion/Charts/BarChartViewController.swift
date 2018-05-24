//
//  BarChartViewController.swift
//  Fluctuacion
//
//  Created by jorge on 13/5/18.
//  Copyright © 2018 jorge. All rights reserved.
//

import UIKit
import Charts
import Firebase

class BarChartViewController: UIViewController {

    var Carne : String = "Carne"
    
    let db = Firestore.firestore()
    
    var productoChart: Producto?
    var completionHandler: ((Producto) -> Swift.Void)?
    
    @IBOutlet weak var nombreProducto: UILabel!
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBAction func Volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var months: [String]!

    var numberOfDownloadsDataEntries = [BarChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = productoChart?.nombre
        barChart.chartDescription?.text = productoChart?.nombre
        nombreProducto.text = productoChart?.nombre

        /*
        barChart.noDataText = "Necesita ingresar datos para la gráfica del historial"

        numberOfDownloadsDataEntries = [iOSDataEntry,MacDataEntry,abc,aaa]
        updateChartData()
         */
        /*
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
*/
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChart.noDataText = "Necesita ingresar datos para la gráfica del historial."
        
        var dataEntries: [BarChartDataEntry] = []
        
        var i : Double = 0

        db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("compras")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var productos = [Producto]()
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        print("\(document.data()["fecha"])")

                        self.db.collection("users").document((Auth.auth().currentUser?.uid)!).collection("compras").document(document.documentID).collection("historial").whereField("nombre", isEqualTo: self.productoChart?.nombre as! String)
                            .getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    //var productos = [Producto]()
                                    for document2 in querySnapshot!.documents {
                                        i = i + 1
                                        /*
                                        let producto = Producto(nombre: document.data()["nombre"] as! String, descripcion: document.data()["descripcion"] as! String, marca: document.data()["marca"] as? String, precio: document.data()["precio"] as? String)
                                        */
                                        //productos.append(producto)
                                        let dataEntry = BarChartDataEntry( x: i, y: Double((document2.data()["precio"] as! String))!)
                                        dataEntries.append(dataEntry)

                                        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Veces Compradas")
                                        let chartData = BarChartData(dataSet: chartDataSet)
                                        chartDataSet.colors = ChartColorTemplates.colorful()
                                        self.barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
                                        self.barChart.data = chartData

                                    }
                                }
                        }
                    }

                }

        }
        
       /*
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry( x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        */
        
        

    }
    
    func updateChartData() {
        let chartDataSet = BarChartDataSet(values: numberOfDownloadsDataEntries, label: nil)

        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        barChart.data = chartData
    }
    
    
    @IBAction func iosChange(_ sender: Any) {
    }
    
    @IBAction func macChange(_ sender: Any) {
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
