//
//  CategoryPickerTableViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 02/11/21.
//

import UIKit
import SnapKit

 
protocol CategoryType: AnyObject {
    func didChoseCategoryName(category: String)
}

class CategoryPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: CategoryType?
    
    let categoryTableView = UITableView()
    var selectedCategoryName = ""
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<categories.count {
            if categories[i] == selectedCategoryName {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            } }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
     func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
        if indexPath.row != selectedIndexPath.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            
            delegate?.didChoseCategoryName(category: categories[indexPath.row])
            selectedIndexPath = indexPath
        }
    }
}


extension CategoryPickerViewController{
    func setupUI(){
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPressed))
        
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func cancelButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
}
