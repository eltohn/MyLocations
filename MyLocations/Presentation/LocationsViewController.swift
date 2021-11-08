//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 08/11/21.
//

import UIKit
import SnapKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    
    let arr = ["C"]
    let arr1 = ["B"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationsUI()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bar"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationCells
        cell.topLabel.text = "Top"
        cell.bottomLabel.text = "Bottom"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}



class LocationCells: UITableViewCell{
    
    
     var topLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var bottomLabel: UILabel = {
       let label = UILabel()
        label.alpha = 0.5
        label.font = UIFont.systemFont(ofSize: 13)
       return label
   }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(30)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.equalTo(30)
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
    }
}
