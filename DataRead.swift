//
//  DataRead.swift
//  HDAugmentedRealityDemo
//
//  Created by Andrey Apet on 3/6/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
//

import Foundation

public class DataRead {
    
    var allShotsObjectArray = [InfoShot]()
    public init() {
        readFile()
    }
    
    //MARK: Reading the txt file
    
    public func readFile () {
        if let path = Bundle.main.path(forResource: "top10_2016", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let shotStrings = data.components(separatedBy: .newlines)
                for stringNumber in 0...(shotStrings.count-1) {
                    var arrayOfWords = shotStrings[stringNumber].components(separatedBy: ";")
                    if arrayOfWords.count == 40 {
                        let info = InfoShot()
                        info.tournament.tourDescription = arrayOfWords[1].description
                        info.shot.round = arrayOfWords[9].description
                        info.tournament.year = arrayOfWords[2].description
                        info.player.playerID = arrayOfWords[4].description
                        info.player.playerFullName = "\(arrayOfWords[7].description) \(arrayOfWords[8].description)"
                        info.shot.hole = arrayOfWords[12].description
                        info.shot.shotNumber = arrayOfWords[16].description
                        info.shot.distance = arrayOfWords[23].description
                        info.shot.distanceToHoleAfterTheShot = arrayOfWords[28].description
                        info.shot.xCoordinate = arrayOfWords[33].description
                        info.shot.yCoordinate = arrayOfWords[34].description
                        info.shot.zCoordinate = arrayOfWords[35].description
                        
                        //                        print ("Tournament year: \(info.tournament.year), player ID: \(info.player.playerID), player first name: \(info.player.playerFirstName), player last name: \(info.player.playerLastName), hole: \(info.shot.hole), shot number: \(info.shot.shotNumber), distance: \(info.shot.distance), distance to hole after shot: \(info.shot.distanceToHoleAfterTheShot), X Coordinate: \(info.shot.xCoordinate), Y Coordinate: \(info.shot.yCoordinate), Z Coordinate \(info.shot.zCoordinate)")
                        
                        self.allShotsObjectArray.append(info)
                    }
                }
                print ("Readed and add \(self.allShotsObjectArray.count) objects")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
