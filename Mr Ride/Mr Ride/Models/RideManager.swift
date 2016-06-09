//
//  RunDataModel.swift
//  Mr Ride
//
//  Created by Sarah on 6/6/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class MyLocation: CLLocation{
    let longtitude: Double = 0.0
    let latitude: Double = 0.0
}


class RideData{
    var totalTime: Int = 0
    var distance: Double = 0.0
    
    init(){}
    
    init(totalTime: Int, distance: Double){
        self.totalTime = totalTime
        self.distance = distance
    }
}




class RideManager{
    
    static let sharedManager = RideManager()
    
    var myCoordinate = [MyLocation]()
    let rideData = RideData()
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: Get Data From Core Data
    func getDataFromCoreData() {
        
        let request = NSFetchRequest(entityName: "RideHistory")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        do {
            let results = try moc.executeFetchRequest(request) as! [RideHistory]
            for result in results {
                
                if let distance = result.distance as? Double,
                    let totalTime = result.tatalTime as? Int{

                    rideData.distance = distance
                    rideData.totalTime = totalTime

                }
                
                if let locations = result.locations!.array as? [Locations]{
                    for locaton in locations{
                        if let  _longtitude = locaton.longtitude?.doubleValue,
                            _latitude = locaton.latitude?.doubleValue{
                            
                            myCoordinate.append(
                                MyLocation(
                                    latitude: _latitude,
                                    longitude: _longtitude
                                )
                            )
                        }
                    }
                }
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }
}
