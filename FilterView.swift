//
//  FilterView.swift
//  HDAugmentedRealityDemo
//
//  Created by Andrey Apet on 3/7/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
//

import UIKit

class FilterView: NSObject, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var view = UIView()
    var tableView: UITableView = UITableView()
    var picker: UIPickerView = UIPickerView()
    let toolBar = UIToolbar()
    
    let filterData = Filter()
    var pickerData = [[String]]()
    var pickerArray = [String]()
    var selectedTF: UITextField?
    
    var indexPicker = [0,0,0,0,0]
    var tagPicker = 0
    
    var nameForFilter  = ""
    var yearForFilter  = ""
    var roundForFilter = ""
    var holeForFilter  = ""
    
    var sortedData = [InfoShot]()
    
    var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        return button
    }()
    
    func update() {
        print("Update tapped")
        self.sort()
        
        dismissFilterView()
    }
    
    func sort() {
        self.sortedData = self.filterData.filtering(year: self.yearForFilter, playerName: self.nameForFilter, round: self.roundForFilter, hole: self.holeForFilter)
    }
    
    func showFilterView() {
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: CGRect(x: 0, y: keyWindow.frame.height / 2, width: keyWindow.frame.width, height: keyWindow.frame.height / 2))
            view.backgroundColor = .black
            view.frame = CGRect(x: 0, y: keyWindow.frame.height - 1, width: keyWindow.frame.width, height: 1)
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
            swipe.direction = UISwipeGestureRecognizerDirection.down
            
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height / 2 - 70))
            tableView.backgroundColor = .black
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.allowsSelection = false
            tableView.isScrollEnabled = false
            tableView.delegate      =   self
            tableView.dataSource    =   self
            tableView.register(FilterCell.self, forCellReuseIdentifier: "Cell")
            tableView.addGestureRecognizer(swipe)
            view.addSubview(tableView)
            
            picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height / 2))
            picker.backgroundColor = .black
            picker.tintColor = .white
            picker.showsSelectionIndicator = true
            picker.delegate = self
            picker.dataSource = self
            
            toolBar.barStyle = UIBarStyle.black
            toolBar.isTranslucent = true
            toolBar.tintColor = .white
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            updateButton.frame = CGRect(x: 0, y: keyWindow.frame.height / 2 - 70, width: keyWindow.frame.width, height: 70)
            updateButton.addTarget(self, action: #selector(update), for: UIControlEvents.touchUpInside)
            view.addSubview(updateButton)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: keyWindow.frame.height / 2, width: keyWindow.frame.width, height: keyWindow.frame.height)
            }, completion: { (completedAnimation) in
                
            })
            
            pickerData = [filterData.tournaments, filterData.golfers, filterData.years, filterData.rounds, filterData.holes]
        }
    }
    
    func swipeDown(_ gesture: UIGestureRecognizer) {
        dismissFilterView()
    }
    
    func dismissFilterView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: 0, y: UIApplication.shared.keyWindow!.frame.height - 1, width: UIApplication.shared.keyWindow!.frame.width, height: 1)
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterCell
        
        cell.label.textColor = .white
        cell.textField.inputView = picker
        cell.textField.inputAccessoryView = toolBar
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        
        switch indexPath.row {
        case 1:
            cell.label.text = "Golfer:"
            cell.textField.attributedPlaceholder = NSAttributedString(string: "Chose Golfer",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        case 2:
            cell.label.text = "Year:"
            cell.textField.attributedPlaceholder = NSAttributedString(string: "Chose Year",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        case 3:
            cell.label.text = "Round:"
            cell.textField.attributedPlaceholder = NSAttributedString(string: "Chose Round",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        case 4:
            cell.label.text = "Hole:"
            cell.textField.attributedPlaceholder = NSAttributedString(string: "Chose Hole",attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        default:
            cell.label.text = "Tournament:"
            cell.textField.text = "The Players Championship"
            cell.textField.font = UIFont.boldSystemFont(ofSize: 15)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIApplication.shared.keyWindow!.frame.height / 2 - 70) / 5
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerArray = pickerData[textField.tag]
        (textField.inputView as! UIPickerView).reloadAllComponents()
        selectedTF = textField
        tagPicker = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.selectedTF?.text = pickerArray[indexPicker[tagPicker]]
            self.nameForFilter = (self.selectedTF?.text)!
//            self.updateButton.setTitle("\(String(self.filterData.filtering(year: self.yearForFilter, playerName: self.nameForFilter, round: self.roundForFilter, hole: self.holeForFilter).count)) POI have for Show", for: .normal)
        } else if textField.tag == 2 {
            self.yearForFilter = (self.selectedTF?.text)!
//            self.updateButton.setTitle("\(String(self.filterData.filtering(year: self.yearForFilter, playerName: self.nameForFilter, round: self.roundForFilter, hole: self.holeForFilter).count)) POI have for Show", for: .normal)
        } else if textField.tag == 3 {
            if self.selectedTF?.text != "" {
                self.roundForFilter = "0\((self.selectedTF?.text)!)"
            }
//            self.updateButton.setTitle("\(String(self.filterData.filtering(year: self.yearForFilter, playerName: self.nameForFilter, round: self.roundForFilter, hole: self.holeForFilter).count)) POI have for Show", for: .normal)
        } else if textField.tag == 4 {
            if self.selectedTF?.text != "" {
                if Double((self.selectedTF?.text)!)! < 10.0 {
                    self.holeForFilter = "0\((self.selectedTF?.text)!)"
                } else if Double((self.selectedTF?.text)!)! > 10.0 {
                    self.holeForFilter = (self.selectedTF?.text!)!
                }
            }
//            self.updateButton.setTitle("\(String(self.filterData.filtering(year: self.yearForFilter, playerName: self.nameForFilter, round: self.roundForFilter, hole: self.holeForFilter).count)) POI have for Show", for: .normal)
        }
        // uncomment if need to show coount of sorted data on update button
    }
    
    //MARK: PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTF != nil {
            selectedTF!.text = pickerArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func donePicker(sender:UIBarButtonItem) {
        tableView.reloadData()
        
        self.picker.resignFirstResponder()
    }
    
    func cancelPicker(sender:UIBarButtonItem) {
        if selectedTF != nil {
            selectedTF!.text = ""
        }
        
        tableView.reloadData()
        
        self.picker.resignFirstResponder()
    }
    
}

