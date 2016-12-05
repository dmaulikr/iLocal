
//  ViewController.swift
//  iLocal
//
//  Created by Frazy Nondo on 2016-11-22.
//  Copyright © 2016 Frazy Nondo. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    

//    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var scroView: UIScrollView!
    
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!

    
    var zeroTime = NSTimeInterval()
    var timer : NSTimer = NSTimer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()


        } else {
            print("Need to Enable Location")
        }
        
        // We cannot access the user's HealthKit data without specific permission.
        getHealthKitPermission()
        
        
        //ANIMATION CODE
        // Do any additional setup after loading the view, typically from a nib.
//        startButton.center.x = self.view.frame.width + 30
//        timerLabel.center.x =  self.view.frame.width + 30
        
        scroView.center.x = self.scroView.frame.width + 30
         timerLabel.center =  CGPoint(x: 200, y: 90)
        
        startButton.center = CGPoint(x: 200, y: 90)
        cityLabel.center = CGPoint(x: 200, y: 90)
        
//        
     UIView.animateWithDuration(3.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0, options: [], animations: {
        
        self.cityLabel.center = CGPoint(x: 200, y: 90 + 200)
        
        }, completion: nil)
        
        UIView.animateWithDuration(8.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 8.0, options: [], animations: {
            
            self.timerLabel.center = CGPoint(x: 200, y: 90 + 200)
            

            
            }, completion: nil)
        

     UIView.animateWithDuration(7.0, delay: 2, usingSpringWithDamping: 5.0, initialSpringVelocity: 2.0, options: [], animations: {
            
            self.scroView.center.x = self.view.frame.width/2
            
            }, completion: nil)

 
//
//        UIView.animateWithDuration(10.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6.0, options: [], animations: {
//            
//            self.cityLabel.center.x = self.view.frame.width/2
//            
//            }, completion: nil)
        
//        UIView.animateWithDuration(7.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [], animations: {
//            
//            self.timerLabel.center.x = self.view.frame.width/2
//            
//            }, completion: nil)
        
        UIView.animateWithDuration(8.0, delay: 0.9, usingSpringWithDamping: 0.2, initialSpringVelocity: 8.0, options: [], animations: {
            
//            self.startButton.center.x = self.view.frame.width/2
            self.startButton.center = CGPoint(x: 200, y: 90 + 200)
//            self.cityLabel.center.x = self.view.frame.width/2
            
            }, completion: nil)
        
        //scroll view vertical code 
//        
//        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/8)
//        let scrollViewHeight = self.scrollView.frame.height
//        let scrollViewWidth = self.view.frame.width
//        
//        let img1 = UIImageView(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
//        let img2 = UIImageView(frame: CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight))
//        let img3 = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0, scrollViewWidth, scrollViewHeight))
//        let img4 = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0, scrollViewWidth, scrollViewHeight))
//        
//        img1.image = UIImage(named:"Group 4")
//        img2.image = UIImage(named: "Group 2")
//        img3.image = UIImage(named: "Circle")
//        img4.image = UIImage(named: "Path 2")
//        
//        
//        
//        self.scrollView.addSubview(img1)
//        self.scrollView.addSubview(img2)
//        self.scrollView.addSubview(img3)
//        self.scrollView.addSubview(img4)
//        
//        
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*4, self.scrollView.frame.height)
        


    }
    
    
    func getHealthKitPermission() {
        
        // Seek authorization in HealthKitManager
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                
                // Get and set the user's height.
                self.setHeight()
            } else {
                if error != nil {
                    print(error)
                }
                print("Permission denied.")
            }
        }
    }
    

    @IBAction func startButton(sender: AnyObject) {
        
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = NSDate.timeIntervalSinceReferenceDate()
        print(zeroTime)
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()

    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var timePassed: NSTimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= NSTimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
        
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
            
        } else {
            let lastDistance = lastLocation.distanceFromLocation(locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            let speed = manager.location?.speed
            
            print("my current speed is \(speed!)")
            
            
            
            speedLabel.text = "Speed: \(speed) m/s"
            
            milesLabel.text = "Miles: \(trimmedDistance)"
        }
        
        lastLocation = locations.last as CLLocation!
        
        
        let currentLoc = locations[locations.count-1]
        
        speedLabel.text = "Speed: \(currentLoc.speed)"
        
        CLGeocoder().reverseGeocodeLocation(currentLoc) { (myPlacements, myError) in
            
            if myError != nil {
                // handle error
            }
            
            if let myPlacement = myPlacements?.first {
                
                let myAddress = "\(myPlacement.locality!)"
                
                self.cityLabel.text = myAddress
                
                print(myAddress)
            }
        }
        
    }

    
    
    func setHeight() {
        // Create the HKSample for Height.
        let heightSample = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
        
        // Call HealthKitManager's getSample() method to get the user's height.
        self.healthManager.getHeight(heightSample!, completion: { (userHeight, error) -> Void in
            
            if( error != nil ) {
                print("Error: \(error.localizedDescription)")
                return
            }
            
//            var heightString = ""
//            
//            self.height = userHeight as? HKQuantitySample
//            
//            // The height is formatted to the user's locale.
//            if let meters = self.height?.quantity.doubleValueForUnit(HKUnit.meterUnit()) {
//                let formatHeight = NSLengthFormatter()
//                formatHeight.forPersonHeightUse = true
//                heightString = formatHeight.stringFromMeters(meters)
//            }
            
            // Set the label to reflect the user's height.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.heightLabel.text = heightString
            })
        })
        
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }

    @IBAction func share(sender: AnyObject) {
        healthManager.saveDistance(distanceTraveled, date: NSDate())
        
        
        let alert = UIAlertController(title: "Greetings", message: "Your travelled distance of :\(distanceTraveled) milles has been saved to health store at: \(NSDate())", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }

}

