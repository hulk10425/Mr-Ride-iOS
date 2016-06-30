//
//  GAManager.swift
//  Mr Ride
//
//  Created by Sarah on 6/29/16.
//  Copyright © 2016 AppWorks School Sarah Lee. All rights reserved.
//

import Amplitude_iOS

class TrackingManager{

    static let sharedManager = TrackingManager()
    
    func createTrackingEvent(category: String, action: String){
        GACreateEvent(category: category, action: action)
        amplitudeLogEvent(event: action)
    }
    
    func createTrackingScreenView(viewName: String){
        GACreateScreenView(viewName: viewName)
        amplitudeLogEvent(event: viewName)
        
    }
}


//MARK: - Google Analytics
extension TrackingManager{

    private func GACreateEvent(category category: String, action: String){
        let tracker = GAI.sharedInstance().defaultTracker
        let eventTracker: NSObject = GAIDictionaryBuilder.createEventWithCategory(
            category,
            action: action,
            label: "",
            value: nil).build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
    }
    
    private func GACreateScreenView(viewName viewName: String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: viewName)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
}


//MARK: - Amplitude
extension TrackingManager{
    private func amplitudeLogEvent(event event: String){
        Amplitude.instance().logEvent(event)
    }
    
    
}