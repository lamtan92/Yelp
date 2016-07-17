//
//  FilterViewController.swift
//  Yelp
//
//  Created by Lam Tran on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate{
    optional func filterViewController(filterVC : FilterViewController, didUpdateFilter filters: [String:AnyObject])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var filterTable: UITableView!
    
    let sectionHeaders = ["Deal","Distance","Sort By","Category"]
    
    var radiusFloat: [Float?]!
    
    let categories = [
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
    
    var filters = [String:AnyObject]()
    var switchStates = [Int:Bool]()
    weak var delegate : FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if filters["switchStates"] != nil {
            switchStates = filters["switchStates"] as! [Int:Bool]
        }
        
        radiusFloat = [nil, 0.3, 1, 5, 20]
        
        filterTable.delegate = self
        filterTable.dataSource = self
        filterTable.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelBarButtonHandle(sender: UIBarButtonItem) {
        
    }

    @IBAction func onCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        var category = [String]()
    
        for (row, isSelected) in switchStates {
            if(isSelected){
                category.append(categories[row]["code"]!)
            }
        }
        
        filters["category"] = category
        filters["switchStates"] = switchStates
        
        delegate?.filterViewController?(self, didUpdateFilter: filters)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource, FilterCategoryTableViewCellDelegate, SelectTableViewCellDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return radiusFloat.count
            
        case 2:
            return 3
            
        case 3:
            return categories.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //  Deals
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as! FilterCategoryTableViewCell
            
            cell.categoryNameLabel.text = "Offering a Deal"
            
            cell.categorySwitch.on = self.filters["Deal"] as? Bool ?? false
            cell.delegate = self
            return cell
        
            
        case 1:
            //  Distance
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell") as! SelectTableViewCell
            
            if indexPath.row == 0 {
                cell.selectLabel.text = "Auto"
            } else if indexPath.row == 1 {
                 cell.selectLabel.text =  String(format: "%g", radiusFloat[indexPath.row]!) + " mile"
            } else {
                cell.selectLabel.text =  String(format: "%g", radiusFloat[indexPath.row]!) + " miles"
            }
            
            if filters["radius"] != nil {
                if radiusFloat[indexPath.row] == filters["radius"] as? Float {
                    cell.stateButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
                } else {
                    cell.stateButton.setBackgroundImage(UIImage(named: "unCheck"), forState: .Normal)
                }
                
            } else {
                if indexPath.row == 0 {
                    cell.stateButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
                } else {
                    cell.stateButton.setBackgroundImage(UIImage(named: "unCheck"), forState: .Normal)
                }
            }
            
            cell.delegate = self
            return cell
            
        case 2:
            //  Sort
            let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell") as! SelectTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.selectLabel.text = "BestMatched"
                break
            
            case 1:
                cell.selectLabel.text = "Distance"
                break
            
            case 2:
                cell.selectLabel.text = "HighestRated"
                break
                
            default:
                break
            }
            
            if filters["sort"] != nil {
                if filters["sort"] as! UInt == UInt(indexPath.row) {
                    cell.stateButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
                } else {
                    cell.stateButton.setBackgroundImage(UIImage(named: "unCheck"), forState: .Normal)
                }
            } else {
                cell.stateButton.setBackgroundImage(UIImage(named: "unCheck"), forState: .Normal)
            }
            
            cell.delegate = self
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as! FilterCategoryTableViewCell
            
            cell.categoryNameLabel.text = categories[indexPath.row]["name"]
            
            cell.categorySwitch.on = switchStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func filterCategoryTableViewCell(filterCategoryTableViewCell: FilterCategoryTableViewCell, didChangedValue value: Bool) {
        
        let indexPath = filterTable.indexPathForCell(filterCategoryTableViewCell)
        
        switch indexPath!.section {
        case 0:
            self.filters["Deal"] = value
            return
            
        case 3:
            switchStates[indexPath!.row] = value
            return
            
        default:
            return
        }
        
    }
    
    func selectCell(selectCell: SelectTableViewCell, didSelect currentImg: UIImage) {
        let indexPath = filterTable.indexPathForCell(selectCell)
        
        if indexPath != nil {
            switch indexPath!.section {
            case 1:
                filters["radius"] = radiusFloat[indexPath!.row]
                break
            
            case 2:
                filters["sort"] = UInt(indexPath!.row)
                
            default:
                break
            }
            
            filterTable.reloadData()
        }
    }
    
}