//
//  ARAnnotation.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 23/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation

/// Defines POI with title and location.
open class ARAnnotation: NSObject
{
    /// Title of annotation
    open var title: String?
    /// Location of annotation
    open var location: CLLocation?
    /// Tournament
    open var tournament: String?
    /// Tournament year
    open var year: String?
    /// Number of Hole
    open var hole: String?
    /// Tournament Round
    open var round: String?
    
    
    /// View for annotation. It is set inside ARViewController after fetching view from dataSource.
    internal(set) open var annotationView: ARAnnotationView?
    
    // Internal use only, do not set this properties
    internal(set) open var distanceFromUser: Double = 0
    internal(set) open var shotDistance: Double = 0
    internal(set) open var azimuth: Double = 0
    internal(set) open var verticalLevel: Int = 0
    internal(set) open var active: Bool = false

}
