//
//  FilterSourceAndFunc`s.swift
//  HDAugmentedRealityDemo
//
//  Created by Andrey Apet on 3/7/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
//

import UIKit

class Filter: NSObject {
    
    var tournaments = ["The Players Championship"]
    var golfers = ["Daniel Berger", "Kevin Chappell", "Jason Day", "Ken Duke", "Colt Knost", "Matt Kuchar", "Hideki Matsuyama", "Graeme McDowell", "Francesco Molinari", "Justin Thomas"]
    var years = ["2016"]
    var rounds = ["1", "2", "3", "4"]
    var holes = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18"]
    
    
    func filterByYear (data: DataRead, year: String) -> [InfoShot] {
        var filteredByYearArray = [InfoShot]()
        if data.allShotsObjectArray.count != 0 {
            for shotObject in 0...(data.allShotsObjectArray.count - 1) {
                if year == data.allShotsObjectArray[shotObject].tournament.year {
                    filteredByYearArray.append(data.allShotsObjectArray[shotObject])
                } else if year == "" {
                    filteredByYearArray = data.allShotsObjectArray
                }
            }
        }
        print("\(filteredByYearArray.count) obj sorted by Year")
        return filteredByYearArray
    }
    
    
    //MARK: Filtering by PLAYER NAME
    
    func filterByGolfer (data: [InfoShot], playerName: String) -> [InfoShot] {
        var filteredByGolferArray = [InfoShot]()
        if data.count == 0 {
            filteredByGolferArray = data
        } else {
            for shotObject in 0...(data.count - 1) {
                if playerName == data[shotObject].player.playerFullName {
                    filteredByGolferArray.append(data[shotObject])
                } else if playerName == "" {
                    filteredByGolferArray = data
                }
            }
        }
        print("\(filteredByGolferArray.count) obj sorted by GolferName")
        return filteredByGolferArray
    }
    
    //MARK: Filetering by ROUND
    
    func filterByRound (data: [InfoShot], round: String) -> [InfoShot] {
        var filteredByRoundArray = [InfoShot]()
        if data.count == 0 {
            filteredByRoundArray = data
        } else {
            for shotObject in 0...(data.count - 1) {
                if round == data[shotObject].shot.round {
                    filteredByRoundArray.append(data[shotObject])
                } else if round == "" {
                    filteredByRoundArray = data
                }
            }
        }
        print("\(filteredByRoundArray.count) obj sorted by Round")
        return filteredByRoundArray
    }
    
    //MARK: Filtering by HOLE
    
    func filterByHole (data: [InfoShot], hole: String) -> [InfoShot] {
        var filteredByHoleArray = [InfoShot]()
        if data.count == 0 {
            filteredByHoleArray = data
        } else {
            for shotObject in 0...(data.count - 1) {
                if hole == data[shotObject].shot.hole {
                    filteredByHoleArray.append(data[shotObject])
                } else if hole == "" {
                    filteredByHoleArray = data
                }
            }
        }
        print("\(filteredByHoleArray.count) obj sorted by Hole")
        return filteredByHoleArray
    }
    
    func filtering(year: String, playerName: String, round: String, hole: String) -> [InfoShot] {
        var filteredArray = [InfoShot]()
        filteredArray = filterByHole(data: filterByRound(data: filterByGolfer(data: filterByYear(data: DataRead(), year: year), playerName: playerName), round: round), hole: hole)
        print("Sorted \(filteredArray.count) obj")
        return filteredArray
    }
    
}
