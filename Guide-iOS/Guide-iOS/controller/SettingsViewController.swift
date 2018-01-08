import UIKit
import SwiftyBeaver

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var sectionModelItemArray = [SectionItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appSettings = AppSettingsSectionItem(appSettings: AppManager.shared.appSettings)
        let gpsSettings = GpsSettingsSectionItem(gpsSettings: AppManager.shared.gpsSettings)
        sectionModelItemArray.append(appSettings)
        sectionModelItemArray.append(gpsSettings)
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    private func setupTableView() {
        tableView.register(SwitchCell.nib, forCellReuseIdentifier: SwitchCell.identifier)
        tableView.register(PickerCell.nib, forCellReuseIdentifier: PickerCell.identifier)
        
        tableView.dataSource = SettingsDataSource(sectionModalItemArray: sectionModelItemArray)
    }
}

fileprivate class SettingsDataSource: NSObject, UITableViewDataSource {
    
    private var sectionModalItemArray: [SectionItem]
    
    init(sectionModalItemArray: [SectionItem]) {
        self.sectionModalItemArray = sectionModalItemArray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModalItemArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModalItemArray[section].sectionCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentModelItem = sectionModalItemArray[indexPath.section].sectionCellArray[indexPath.row]
        switch currentModelItem.type {
        case .binary:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell,
                let modelItem = currentModelItem as? SwitchCellItem {
                    cell.item = modelItem
                    return cell
            } else {
                SwiftyBeaver.error("Type doesn't match to Cell")
            }
            
        case .picker:
            if  let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.identifier, for: indexPath) as? PickerCell,
                let modelItem = currentModelItem as? PickerCellItem {
                    cell.item = modelItem
                    return cell
            } else {
                SwiftyBeaver.error("Type doesn't match to Cell")
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionModalItemArray[section].sectionTitle
    }
    
    
    
    
    
    
}
