import Foundation
import UIKit
import SwiftyBeaver

class SightViewController: BaseViewController, AppManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sightTableView: UITableView!
    
    private var tableContent: [Sight]! {
        didSet {
            sightTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableContent = AppManager.shared.nearbySightArray
        AppManager.shared.setDelegate(self)
        
        setupSightTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private let cellID = "sightCellID"
    private func setupSightTable() {
        sightTableView.register(UINib(nibName: "SightCellView", bundle: nil), forCellReuseIdentifier: cellID)
        sightTableView.delegate = self
        sightTableView.dataSource = self
    }
    
    //MARK: AppManagerDelegate
    func nearbySightDidChange(newValue value: [Sight]) {
        tableContent = value
    }
    
    //MARK: tableView datasource & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sightCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SightCellController else {
            SwiftyBeaver.error("Sight cell doesn't exist")
            fatalError()
        }
        
        return sightCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sightCell = cell as? SightCellController else {
            SwiftyBeaver.error("Sight cell doesn't exist")
            return
        }
        
        sightCell.sight = tableContent[indexPath.row]
    }
}

