//
//  TrackingViewController.swift
//  Mr Ride
//
//  Created by Sarah on 5/24/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import UIKit
import CoreData

class TrackingViewController: UIViewController{
    
    @IBOutlet weak var calBurnedLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var buttonRingView: UIView!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBAction func recordButtonDidClicked(sender: AnyObject) {
        stopwatch()
    }
    
    let calorieCalculator = CalorieCalculator()
    let gradientLayer = CAGradientLayer()
    var timer = NSTimer()
    var hours = 0
    var minutes = 0
    var seconds = 0
    var fractions = 0
    var calTime = 0.0
    var totalFraction = 0
    var date = ""

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRecordButton()
        setupRecordLabel()
        setupGradientView()
        mapViewController.myLocations.removeAll()
        mapViewController.showUserLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    private var mapViewController: MapViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapView = segue.destinationViewController as? MapViewController where segue.identifier == "EmbedSegueFromTrackingPage"{
            self.mapViewController = mapView
            mapViewController.trackingViewController = self
        }
    }
}



//MARK: - Stopwatch
extension TrackingViewController{
    
    func stopwatch(){
        
        if !timer.valid{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            mapViewController.currentLocation = mapViewController.locationManager.location
        }else{
            timer.invalidate()
        }
    }
    
    @objc func updateTime(timer: NSTimer){

        fractions += 1
        totalFraction += 1
        
        if fractions == 100{
            calTime += 1
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60{
            hours += 1
            minutes = 0
        }
        
        updateTimerLabels()
        updateKcalLabel()
        mapViewController.startUpdateUI()

    }
}



//MARK: - Setup UI
extension TrackingViewController{

    func setupNavigationBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedCancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.clickedFinish))
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.translucent = false
        
        setupDate()
    }
    
    func clickedCancel(){
        
        //navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func clickedFinish(){
        saveRide()
        
        do {
            try self.moc.save()
        }catch{
            fatalError("Failure to save context: \(error)")
        }
        
        let statisticViewController = self.storyboard!.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.setupNavigationBar(Mode.closeMode)
        mapViewController.locationManager.stopUpdatingLocation()
        self.navigationController?.pushViewController(statisticViewController, animated: true)
    }
    
    
    func setupRecordButton(){
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        buttonRingView.backgroundColor = UIColor.clearColor()
        buttonRingView.layer.cornerRadius = buttonRingView.frame.width / 2
        buttonRingView.layer.borderWidth = 4
        buttonRingView.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    func setupRecordLabel(){
        recordTimeLabel.text = "00:00:00.00"
        recordTimeLabel.textColor = UIColor.mrWhiteColor()
        recordTimeLabel.font = UIFont.mrRobotoMonoLightFon(30)
    }
    
    func updateTimerLabels(){
        let strHours = String(format: "%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fractions)
        
        recordTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds).\(strFraction)"
    }
    
    func updateKcalLabel(){
        let averageSpeed = (mapViewController.distance/1000) / (calTime/3600)
        
        let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: averageSpeed, weight: 50.0, time: calTime/3600)
        if (kCalBurned >= 0.01){
            calBurnedLabel.text = String(format: "%.2f kcal", kCalBurned)
        }
    }
    
    func setupGradientView(){
        
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor.mrBlack60Color().CGColor as CGColorRef
        let color2 = UIColor.mrBlack40Color().CGColor as CGColorRef
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 0.5]
        self.gradient.layer.addSublayer(gradientLayer)
    }
    
    func setupDate(){
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        date = dateFormatter.stringFromDate(currentDate)
        self.navigationItem.title = date
  
    }

}


//MARK: - Core Data
extension TrackingViewController{
    func saveRide(){
        print("locations: \(mapViewController.myLocations.count)")
        
        let saveRide = NSEntityDescription.insertNewObjectForEntityForName("RideHistory", inManagedObjectContext: moc) as! RideHistory
        saveRide.date = NSDate()
        saveRide.distance = mapViewController.distance
        saveRide.tatalTime = totalFraction
        saveRide.weight = 50.0
        
        print("mapViewController.distance: \(mapViewController.distance)")
        print("totalFraction: \(totalFraction)")
        
        let locations = mapViewController.myLocations
        var savedLocations = [Locations]()
        for location in locations{
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Locations", inManagedObjectContext: self.moc) as! Locations
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longtitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        
        saveRide.locations = NSOrderedSet(array: savedLocations)
    }
    

}







