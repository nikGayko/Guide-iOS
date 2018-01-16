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
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(isLarge: true)
    }
    
    private func setupSightTable() {
        sightTableView.register(SightCell.nib, forCellReuseIdentifier: SightCell.identifier)
        
        sightTableView.delegate = self
        sightTableView.dataSource = self
    }
    
    //MARK: AppManagerDelegate
    func nearbySightDidChange(newValue value: [Sight]) {
        OperationQueue.main.addOperation {
            self.tableContent = value
        }
    }
    
    //MARK: tableView datasource & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sightCell = tableView.dequeueReusableCell(withIdentifier: SightCell.identifier, for: indexPath) as? SightCell else {
            SwiftyBeaver.error("Sight cell doesn't exist")
            fatalError()
        }
        
        return sightCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sightCell = cell as? SightCell else {
            SwiftyBeaver.error("Sight cell doesn't exist")
            return
        }
        
        sightCell.sight = tableContent[indexPath.row]
    }
}

