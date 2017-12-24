import Foundation
import UIKit
import SwiftyBeaver

class SightViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sightTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
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
        
        //config cell
    }
}

