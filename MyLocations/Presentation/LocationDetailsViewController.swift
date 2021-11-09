//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 27/10/21.
//

import UIKit
import SnapKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

struct CellBlueprint {
    let titles: [String]
}

class LocationDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tagTableView = UITableView()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
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
    

    let cellArray = [CellBlueprint(titles: ["Description",""]),
                     CellBlueprint(titles: ["Category","","Add Photo",""]),
                     CellBlueprint(titles: ["Latitude","Longtitude","Address","Date"])]
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    
    //MARK:- CoreData references
    var managedObjectContext: NSManagedObjectContext!
    
    var date = Date()
    
    //MARK:- CATEGORYController PROPERTIES
    var categoryName = "No Category"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTableView.delegate = self
        tagTableView.dataSource = self
        
        detailViewLabel.text = categoryName
        
        setupUI()
        
        timeLabel.text = format(date: date)
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
            cell.textLabel?.text = cellArray[indexPath.section].titles[indexPath.row]
            if indexPath.row == 1{
                descriptionTextView.font = UIFont.systemFont(ofSize: 20)
                cell.contentView.addSubview(descriptionTextView)
                descrTextViewConstraint(descriptionTextView)
            }
            return cell
        }else if (indexPath.section == 1){
            if indexPath.row == 0{
                cell.textLabel?.text = cellArray[indexPath.section].titles[indexPath.row]
                cell.contentView.addSubview(detailViewLabel)
                detailViewLabel.textAlignment = .center
                cellDetailLabelConstraint(detailViewLabel)
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 2 {
                cell.textLabel?.text = cellArray[indexPath.section].titles[indexPath.row]
                cell.accessoryType = .disclosureIndicator
            }
            return cell
        }else{
            cell.textLabel?.text = cellArray[indexPath.section].titles[indexPath.row]
            
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
                if let placemark = placemark{
                    locationPlacemarkLabel.text = String.placemarkToString(from: placemark)
                }else{
                    locationPlacemarkLabel.text = "Address not found"
                }
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
        return cellArray[section].titles.count
    }
}


extension LocationDetailsViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
          }
        
        if indexPath.section == 1 && indexPath.row == 0{
            let vc = CategoryPickerViewController()
            vc.modalPresentationStyle = .currentContext
            vc.selectedCategoryName = categoryName
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
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
        
        let gestureRegognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRegognizer.cancelsTouchesInView = false
        tagTableView.addGestureRecognizer(gestureRegognizer)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        
    }
    
    @objc func cancelButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonPressed(){
        guard let mainView = navigationController?.parent?.view else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        hudView.text = "Tagged"
        // 1
        let location = Location(context: managedObjectContext)
        // 2
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        // 3
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch { // 4
            fatalCoreDataError(error)
        }
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer){
        let point = gestureRecognizer.location(in: tagTableView)
        let indexPath = tagTableView.indexPathForRow(at: point)
          if indexPath != nil && indexPath!.section == 0 &&
          indexPath!.row == 0 {
        return
        }
          descriptionTextView.resignFirstResponder()
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
    
    func descrTextViewConstraint(_ textView: UITextView){
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func format(date: Date) ->String{
        return dateFormatter.string(from: date)
    }
    
    func afterDelay(_ seconds: Double, run:  @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
    }
     
}

 


extension LocationDetailsViewController: CategoryType{
    func didChoseCategoryName(category: String) {
        detailViewLabel.text = category
        categoryName = category
        
        print(category)
    }
}
