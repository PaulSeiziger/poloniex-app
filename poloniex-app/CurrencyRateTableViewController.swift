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
    var data: [CurrencyRate]?
    let reuseCellIdentifier = "currencyRateCell"
    let currencyRateValueFormat = "%.8f"
    
    override func viewDidAppear(_ animated: Bool) {
        data = [
            CurrencyRate(currencyName: "BTC", currencyValue: 0.98221223),
            CurrencyRate(currencyName: "XRP",currencyValue: 0.0122222)
        ]
        
//        self.tableView.register(CurrencyRateCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else {
            return 0
        }
        
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else {
            fatalError("Application error no cell data available")
        }
        
        let cellData = data[indexPath.row]
        
        let cell:CurrencyRateCell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! CurrencyRateCell
        
        cell.currencyName.text = cellData.currencyName
        cell.currencyValue.text = String(format: currencyRateValueFormat, cellData.currencyValue)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let createdCell = cell as! CurrencyRateCell
        
        guard let data = data else {
            fatalError("Application error no cell data available")
        }
        
        let cellData = data[indexPath.row]
        
        createdCell.currencyName.text = cellData.currencyName
        createdCell.currencyValue.text = String(format: currencyRateValueFormat, cellData.currencyValue)
    }
}
