//
//  TestAnnotationView.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 30/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit

open class TestAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    open var titleLabel: UILabel?
    open var infoButton: UIButton?

    override open func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        if self.titleLabel == nil
        {
            self.loadUi()
        }
    }
    
    func loadUi()
    {
        // Title label
        self.titleLabel?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textColor = .black
        self.addSubview(label)
        self.titleLabel = label
        
        // Info button
        self.infoButton?.removeFromSuperview()
        let button = UIButton(type: UIButtonType.detailDisclosure)
        button.isUserInteractionEnabled = false   // Whole view will be tappable, using it for appearance
        self.addSubview(button)
        self.infoButton = button
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TestAnnotationView.tapGesture))
        self.addGestureRecognizer(tapGesture)
        
        // Other
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        if self.annotation != nil
        {
            self.bindUi()
        }
    }
    
    func layoutUi()
    {
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        
        self.titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - buttonWidth - 5, height: self.frame.size.height);
        self.infoButton?.frame = CGRect(x: self.frame.size.width - buttonWidth, y: self.frame.size.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight);
    }
    
    // This method is called whenever distance/azimuth is set
    override open func bindUi()
    {
        if let annotation = self.annotation, let title = annotation.title {
            let distance = annotation.distanceFromUser * 3.2808 //meters to feet
            
            let shotDistance = String(format: "%.f yd %.f ft", annotation.shotDistance / 3, annotation.shotDistance.truncatingRemainder(dividingBy: 3))
            let distanceToPin = String(format: "%.f yd %.f ft", distance / 3, distance.truncatingRemainder(dividingBy: 3))
            
            let text = String(format: "%@\nShot: %@\nDistance to Pin: %@", title, shotDistance, distanceToPin)
            self.titleLabel?.text = text
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layoutUi()
    }
    
    open func tapGesture()
    {
        if let annotation = self.annotation {
            let playerName = annotation.title
            let tournament = annotation.tournament!
            let year = annotation.year!
            let hole = annotation.hole!
            let round = annotation.round!
            let distance = annotation.distanceFromUser * 3.2808 //meters to feet
            
            let shotDistance = String(format: "%.f yd %.f ft", annotation.shotDistance / 3, annotation.shotDistance.truncatingRemainder(dividingBy: 3))
            let distanceToPin = String(format: "%.f yd %.f ft", distance / 3, distance.truncatingRemainder(dividingBy: 3))
            
            let alertString = "Tounament: \(tournament)\nYear: \(year)\nHole: \(hole)\nRound: \(round)\nShot Distance: \(shotDistance)\nDistance to Pin: \(distanceToPin)"
            
            let alertView = UIAlertView(title: playerName, message: alertString, delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }


}
