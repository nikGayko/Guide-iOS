import UIKit
import SwiftyBeaver

protocol SettingsChildController: class {
    var selectableCellItem: SelectableCellItem? { get set }
}

class SettingsViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableDataSource: UITableViewDataSource?

    private var sectionModelItemArray = [SectionItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModelItemArray()
        tableDataSource = SettingsDataSource(withItems: sectionModelItemArray)
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(isLarge: true)
    }
    
    private func setupModelItemArray() {
        let appSettings = AppSettingsSectionItem(appSettings: AppManager.shared.appSettings)
        let gpsSettings = GpsSettingsSectionItem(gpsSettings: AppManager.shared.gpsSettings)
        sectionModelItemArray.append(appSettings)
        sectionModelItemArray.append(gpsSettings)
    }
    
    private func setupTableView() {
        tableView.register(SwitchCell.nib, forCellReuseIdentifier: SwitchCell.identifier)
        tableView.register(PickerCell.nib, forCellReuseIdentifier: PickerCell.identifier)
        
        tableView.dataSource = tableDataSource
        tableView.delegate = self
    }
    
    private func pushChildController(withId id: String, eventSender: SelectableCellItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let childController = storyboard.instantiateViewController(withIdentifier: id) as? SettingsChildController {
            childController.selectableCellItem = eventSender
            
            if let vc = childController as? UIViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let currentCell = sectionModelItemArray[indexPath.section].sectionCellArray[indexPath.row]
        
        if currentCell.isSelectable {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectableCurrentCell = sectionModelItemArray[indexPath.section].sectionCellArray[indexPath.row] as? SelectableCellItem else {
            SwiftyBeaver.error("Cell is not compatible for selection")
            return
        }
        
        switch selectableCurrentCell.type {
        case .picker:
            pushChildController(withId: TableViewController.identifier, eventSender: selectableCurrentCell)
        case .binary:
            break
        }
    }
}

fileprivate class SettingsDataSource: NSObject, UITableViewDataSource {
    
    private var sectionModalItemArray: [SectionItem]
    
    init(withItems sectionModalItemArray: [SectionItem]) {
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
