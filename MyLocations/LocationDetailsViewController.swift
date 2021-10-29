//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/10/21.
//

import UIKit
import SnapKit

struct CellBlueprint {
    let title: [String]
    let numberOfCells: Int
}

class LocationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tagTableView = UITableView()
    
    private let descriptionTextView: UITextView = {
       let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 90, height: 20))
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .blue
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
    
    let cellArray = [CellBlueprint(title: ["1","1"], numberOfCells: 2),
                     CellBlueprint(title: ["2"], numberOfCells: 1),
                     CellBlueprint(title: ["A","B","C","D"], numberOfCells: 4)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTableView.delegate = self
        tagTableView.dataSource = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
            let cell = tagTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }else if (indexPath.section == 1){
            let cell = tagTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }else{
            let cell = tagTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = cellArray[indexPath.section].title[indexPath.row]
            cell.detailTextLabel?.text = cellArray[indexPath.section].title[indexPath.row]
            let detailViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            detailViewLabel.text = "DetailDetail"
            cell.accessoryView = detailViewLabel
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray[section].numberOfCells
    }

     
}


extension LocationDetailsViewController{
    
    func setupUI(){
        tagTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tagTableView)
//        view.addSubview(descriptionTextView)
        descriptionTextView.backgroundColor = .lightGray
        
//        descriptionTextView.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.height.equalTo(50)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
//        }
        
        tagTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
     
}
