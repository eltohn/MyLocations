//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 08/11/21.
//

import UIKit
import SnapKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView = UITableView()
    
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Apple Store"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.alpha = 0.5
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationsUI()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerLabel.text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCells
        cell.topLabel.text = "Apple to Infinity"
        cell.bottomLabel.text = "2 Infinite Loop, Cupertino"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

class LocationCells: UITableViewCell{
    
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.5
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.equalTo(topLabel.snp.left)
            make.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension LocationsViewController{
    
    func  setupLocationsUI(){
        
        tableView.register(LocationCells.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed(){
        
    }
}





//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.addSubview(headerLabel)
//        headerLabel.snp.makeConstraints { make in
//            make.left.equalTo(20)
//            make.centerY.equalToSuperview()
//        }
//        return headerView
//    }
