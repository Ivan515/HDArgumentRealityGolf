//
//  ViewController.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 21/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, ARDataSource {
    
    var filterButton: UIButton?
    let filterView = FilterView()
    
    var sortedData = [InfoShot]()
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addFilterButton()
        self.locManager.requestWhenInUseAuthorization()
        self.assignCurrentLocation()
    }
    
    internal func showFilterView() {
        self.filterView.showFilterView()
    }
    
    /// Creates random annotations around predefined center point and presents ARViewController modally
    func showARViewController()
    {
        self.sortedData = filterView.sortedData
        
        let result = ARViewController.createCaptureSession()
        if result.error != nil
        {
            let message = result.error?.userInfo["description"] as? String
            let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
            alertView.show()
            return
        }
        
        let lat = self.currentLocation.coordinate.latitude
        let lon = self.currentLocation.coordinate.longitude
        let delta = 0.05
        
        let dummyAnnotations = self.getDummyAnnotations(centerLatitude: lat, centerLongitude: lon, delta: delta, count: self.sortedData.count)
   
        // Present ARViewController
        let arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(dummyAnnotations)
        arViewController.uiOptions.debugEnabled = true
        arViewController.uiOptions.closeButtonEnabled = true
        //arViewController.interfaceOrientationMask = .landscape
        arViewController.onDidFailToFindLocation =
        {
            [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
            self?.handleLocationFailure(elapsedSeconds: elapsedSeconds, acquiredLocationBefore: acquiredLocationBefore, arViewController: arViewController)
        }
        self.present(arViewController, animated: true, completion: nil)
    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView
    {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = TestAnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 150,height: 50)
        return annotationView;
    }
    
    fileprivate func getDummyAnnotations(centerLatitude: Double, centerLongitude: Double, delta: Double, count: Int) -> Array<ARAnnotation>
    {
        var annotations: [ARAnnotation] = []
        for data in sortedData
        {
            let deleteWhiteSpaceFromX = data.shot.xCoordinate.trimmingCharacters(in: .whitespaces)
            let deleteWhiteSpaceFromY = data.shot.yCoordinate.trimmingCharacters(in: .whitespaces)
            let getXFromArr = Double(deleteWhiteSpaceFromX.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!
            let getYFromArr = Double(deleteWhiteSpaceFromY.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil))!
            let lat = (30.19736606 + ((getXFromArr - 9720.476) * 0.00000276))
            let long = (-81.39221191 + ((getYFromArr - 10516.2) * 0.00000315))

            let annotation = ARAnnotation()
            annotation.location = CLLocation(latitude: lat, longitude: long)
            annotation.title = "POI \(data)"
            annotations.append(annotation)
        }
        return annotations
    }
    
    @IBAction func buttonTap(_ sender: AnyObject)
    {
        showARViewController()
    }
    
    func handleLocationFailure(elapsedSeconds: TimeInterval, acquiredLocationBefore: Bool, arViewController: ARViewController?)
    {
        guard let arViewController = arViewController else { return }
        NSLog("Failed to find location after: \(elapsedSeconds) seconds, acquiredLocationBefore: \(acquiredLocationBefore)")
        // Example of handling location failure
        if elapsedSeconds >= 20 && !acquiredLocationBefore
        {
            // Stopped bcs we don't want multiple alerts
            arViewController.trackingManager.stopTracking()
            let alert = UIAlertController(title: "Problems", message: "Cannot find location, use Wi-Fi if possible!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Close", style: .cancel)
            {
                (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.presentedViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////       @@@@@@@ CUSTOM SECTION @@@@@@@           //////////////////////////////////// ////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addFilterButton() {
        self.filterButton?.removeFromSuperview()
        let filterButton: UIButton = UIButton()
        filterButton.frame = CGRect(x: 0, y: self.view.bounds.size.height - 60, width: self.view.bounds.size.width, height: 60)
        filterButton.backgroundColor = .black
        filterButton.setTitle("FILTER", for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        filterButton.addTarget(self, action: #selector(self.showFilterView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(filterButton)
        self.filterButton = filterButton
    }
    
    func assignCurrentLocation(){
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            self.currentLocation = self.locManager.location
            print(self.currentLocation.coordinate.latitude)
            print(self.currentLocation.coordinate.longitude)
        }
    }

}
