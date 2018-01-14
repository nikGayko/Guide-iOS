//
//  TableViewController.swift
//  Guide-iOS
//
//  Created by Admin on 10.01.2018.
//  Copyright © 2018 Nikita Gayko. All rights reserved.
//

import UIKit
import SwiftyBeaver

class TableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SettingsChildController {

    @IBOutlet weak var tableView: UITableView!
    var selectableCellItem: SelectableCellItem?
    var currentSelectedCell: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(isLarge: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellItem = selectableCellItem {
            return cellItem.availableValueArray.count
        } else {
            return 0
        }
    }
    
    let cellID = "BasicCell"
    let cellLabelTag = 99
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let cellValue = selectableCellItem!.availableValueArray[indexPath.row]
        
        if let label = cell.viewWithTag(cellLabelTag) as? UILabel {
            label.text = cellValue
            
            if (cellValue == selectableCellItem?.getCurrentValue()) {
                cell.accessoryType = .checkmark
                currentSelectedCell = indexPath
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath != currentSelectedCell) {
            if let currentSelectedCell = currentSelectedCell {
                if let cell = tableView.cellForRow(at: currentSelectedCell) {
                    cell.accessoryType = .none
                }
            }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                currentSelectedCell = indexPath
                
                if let cellLabel = cell.viewWithTag(cellLabelTag) as? UILabel, let labelText = cellLabel.text {
                    selectableCellItem?.valueDidChange(newValue: labelText)
                }
            }
         
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
