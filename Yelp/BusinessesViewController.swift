//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, FilterViewControllerDelegate {

    @IBOutlet weak var businessTable: UITableView!
    var businesses: [Business]!
    lazy   var searchBar:UISearchBar = UISearchBar()
    var switchStates = [Int:Bool]()
    var filters = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Business.searchWithTerm("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        businessTable.delegate = self
        businessTable.dataSource = self
        businessTable.estimatedRowHeight = 150
        businessTable.rowHeight = UITableViewAutomaticDimension

        Business.searchWithTerm("Thai", sort: .Distance, categories: [], distance: nil, deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.businessTable.reloadData()
        }
        
        
        

        searchBar.placeholder = "Restaurant"
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }

    func filterViewController(filterVC: FilterViewController, didUpdateFilter filters: [String:AnyObject]) {
        var sortMode : YelpSortMode?
        if filters["sort"] != nil {
            switch filters["sort"] as! UInt {
            case 0:
                sortMode = YelpSortMode.BestMatched
                break
            case 1:
                sortMode = YelpSortMode.Distance
                break
            case 2:
                sortMode = YelpSortMode.HighestRated
                break
            default:
                break
            }
        } else {
            sortMode = nil
        }
        Business.searchWithTerm("", sort: sortMode, categories: filters["category"] as? [String], distance: filters["radius"] as? Float, deals: filters["deal"] as? Bool) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.businessTable.reloadData()
        }
        self.filters = filters
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navController = segue.destinationViewController as! UINavigationController
        
        let filterVC = navController.topViewController as! FilterViewController
        
        filterVC.delegate = self
        filterVC.filters = self.filters
    }
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        Business.searchWithTerm(searchText, sort: .Distance, categories: [], distance: nil, deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.businessTable.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
