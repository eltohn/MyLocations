//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/10/21.
//

import UIKit

class LocationDetailsViewController: UITableViewController {

//    var tableView: UITableView = {
//        let tableView = UITableView()
//        return tableView
//    }()
    private let textView: UITextView = {
       let textView = UITextView()
       return textView
    }()
    
    private let latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Latitude:"
        return label
    }()
    
    private let longtitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "Longtitude:"
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category:"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Address"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Date"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

}
