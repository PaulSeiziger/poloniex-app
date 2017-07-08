//
//  CurrencyRateTableViewController.swift
//  poloniex-app
//
//  Created by Павел Дреманович on 02.07.17.
//  Copyright © 2017 Павел Дреманович. All rights reserved.
//

import Foundation
import UIKit

class CurrencyRateCell: UITableViewCell{
    @IBOutlet weak var currencyName: UILabel!

    @IBOutlet weak var currencyValue: UILabel!
}

class CurrencyRateTableViewController: UITableViewController {
    var data: [String: CurrencyRate] = [:]
    var dataIndexes: [String] = []
    
    let reuseCellIdentifier = "currencyRateCell"
    let currencyRateValueFormat = "%.8f"
    var model:CurrencyRatesModel?
    
    override func viewDidAppear(_ animated: Bool) {
        let config = ApiConfiguration()
        
        model = CurrencyRatesModel(configuration: config)
        model?.listen(callback: modelCallback)
        model?.start()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        model?.stop()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataIndexes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CurrencyRateCell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! CurrencyRateCell
        
        let itemKey = dataIndexes[indexPath.row]
        let item = data[itemKey]
        
        if let cellData = item{
            cell.currencyName.text = cellData.currencyName
            cell.currencyValue.text = String(format: currencyRateValueFormat, cellData.currencyValue)
            
            animateCell(cell: cell, item: cellData)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let createdCell = cell as! CurrencyRateCell
        
        let itemKey = dataIndexes[indexPath.row]
        let item = data[itemKey]
        
        if let cellData = item{
            createdCell.currencyName.text = cellData.currencyName
            createdCell.currencyValue.text = String(format: currencyRateValueFormat, cellData.currencyValue)
            
            animateCell(cell: createdCell, item: cellData)
        }
    }
    
    private func modelCallback(refName:String, name:String, currency:CurrencyRate){
        if (refName == "BTC"){
            if !(dataIndexes.contains(name)) {
                dataIndexes.append(name)
            }
            
            data[name] = currency
            
            self.tableView.reloadData()
        }
    }
    
    private func animateCell(cell: CurrencyRateCell, item: CurrencyRate){
        if !item.isShown{
            item.isShown = true
            
            UIView.animate(
                withDuration: 0.3,
                animations: { cell.backgroundColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)},
                completion: { state in
                    UIView.animate(
                        withDuration: 0.3,
                        animations: {cell.backgroundColor = UIColor.white}
                    )
                }
            )
        }
    }
}
