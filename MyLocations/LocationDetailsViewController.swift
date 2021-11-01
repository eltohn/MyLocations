//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/10/21.
//

import UIKit
import SnapKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

struct CellBlueprint {
    let title: [String]
    let numberOfCells: Int
}

class LocationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tagTableView = UITableView()
    
    var detailViewLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var locationPlacemarkLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var longitudeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var latitudeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var timeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    let cellArray = [CellBlueprint(title: ["1","1"], numberOfCells: 2),
                     CellBlueprint(title: ["Category","","Add Photo",""], numberOfCells: 4),
                     CellBlueprint(title: ["Latitude","Longtitude","Address","Date"], numberOfCells: 4)]
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
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
        
        let cell = tagTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if (indexPath.section == 0){
            if indexPath.row == 0{
                cell.textLabel?.text = "Description"
            }else{
                let descriptionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
                descriptionTextView.font = UIFont.systemFont(ofSize: 20)
                cell.contentView.addSubview(descriptionTextView)
            }
            return cell
        }else if (indexPath.section == 1){
            if indexPath.row == 0{
                cell.textLabel?.text = cellArray[indexPath.section].title[indexPath.row]
                cell.contentView.addSubview(detailViewLabel)
                detailViewLabel.text = "BookstoreVVV"
                detailViewLabel.textAlignment = .center
                cellDetailLabelConstraint(detailViewLabel)
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 2 {
                cell.textLabel?.text = cellArray[indexPath.section].title[indexPath.row]
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }else{
            cell.textLabel?.text = cellArray[indexPath.section].title[indexPath.row]
            
            if indexPath.row == 0{
                cell.contentView.addSubview(latitudeLabel)
                cellDetailLabelConstraint(latitudeLabel)
                latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
            }else if indexPath.row == 1{
                cell.contentView.addSubview(longitudeLabel)
                cellDetailLabelConstraint(longitudeLabel)
                longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
            }else if indexPath.row == 2{
                cell.contentView.addSubview(locationPlacemarkLabel)
                cellDetailLabelConstraint(locationPlacemarkLabel)
                locationPlacemarkLabel.text = String.placemarkToString(from: placemark!)
            }else{
                cell.contentView.addSubview(timeLabel)
                cellDetailLabelConstraint(timeLabel)
                timeLabel.text = format(date: Date())
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0
        if indexPath.section == 0 && indexPath.row == 1{
            height = 100
        }else if indexPath.section == 2{
            height = 80
        }else{
            height = 40
        }
        return CGFloat(height)
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
        
        tagTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}



extension LocationDetailsViewController{
    func cellDetailLabelConstraint(_ label: UILabel){
        label.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func format(date: Date) ->String{
        return dateFormatter.string(from: date)
    }
}
