//
//  TabBarViewController.swift
//  Mall-E
//
//  Created by David Wibisono on 5/18/17.
//  Copyright © 2017 David Wibisono. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import FirebaseDatabase
import UserNotifications
import FirebaseAuth

class TabBarViewController: UITabBarController, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var locationManager: CLLocationManager!
    var bluetoothManager: CBCentralManager!
    var peripheral:CBPeripheral!
    var beaconRegions:[CLBeaconRegion] = []
    var UUID_CENTRAL = "9F4AE469-AD2C-47C7-8E18-23003F2F1483"
    var db:FIRDatabaseReference!
    var offerIsActive = false
    var beaconRegion : CLBeaconRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserPref.isLogin {
            FIRAuth.auth()?.signIn(withCustomToken: UserPref.token, completion: nil)
        }
        
        db = FIRDatabase.database().reference()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
        FetchBeaconOffers()
        SetupNotifications()
    }
    
    func SetupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge, .sound], completionHandler: { (granted, error) in
            if granted {
                print("User Notification granted")
            } else {
                
                print("User Notification not granted")
            }
        })
    }
    
    func BurstNotification(identifier:String, completion: @escaping (_ success: Bool) -> ()) {
        let notif = UNMutableNotificationContent()
        notif.title = "Local promotion found!"
        notif.subtitle = "You can scroll across the ads, great!"
        notif.body = "Yeah!"
        let request = UNNotificationRequest(identifier: identifier, content: notif, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if (error != nil) {
                print(error ?? "")
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Core Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey:"YES"]
            bluetoothManager.scanForPeripherals(withServices: nil, options: options)
        default:
            print("powered off")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
    
    
    //MARK : Core Location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Model.longitude = locations.last?.coordinate.longitude ?? 0.0
        Model.latitude = locations.last?.coordinate.latitude ?? 0.0
        locationManager.stopUpdatingLocation()
        UpdateNearbyBeaconOffer()
        
    }
    
    func UpdateNearbyBeaconOffer() {
        if let beaconOffer = Model.GetOfferNearbyBeacon() {
            Model.nearbyBeaconOffer = beaconOffer
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    StartScanning(uid: beaconOffer.UUID)
                }
            }
        }
    }
    
    
    func StartScanning(uid:String) {
        let uuid = UUID(uuidString: uid)!
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "com.davidcast.Mall-E")
        beaconRegion?.notifyOnEntry = true
        beaconRegion?.notifyOnExit = true
        beaconRegion?.notifyEntryStateOnDisplay = true
        
        
        self.beaconRegions.append(beaconRegion!)
        
        locationManager.startMonitoring(for: beaconRegion!)
        locationManager.startRangingBeacons(in: beaconRegion!)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter")
        if UserPref.allNotification {
            BurstNotification(identifier: "myNotification", completion: {(success) in
                if (success) {
                    print("User has been setup")
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("asd")
        locationManager.requestState(for: region)
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            manager.startRangingBeacons(in: self.beaconRegion!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if offerIsActive { return }
        if UserPref.allNotification {
            print("asdasdd")
            if beacons.count == 0 {
                print("none")
            } else {
                print("found")
                if let beaconOffer = Model.nearbyBeaconOffer {
                    var beaconOffers:[Beacon] = []
                    
                    for beacon in beacons {
                        if !UserPref.adsSeen.contains("\(beacon.major)\(beacon.minor)") && beaconOffer.FindBeacon(majorMinor: "\(beacon.major)\(beacon.minor)") {
                            beaconOffers.append(Beacon(majorMinor: "\(beacon.major)\(beacon.minor)"))
                        }
                    }
                    if beaconOffers.count > 0 {
                        if let offerVC = storyboard?.instantiateViewController(withIdentifier: "offer") as? OfferViewController {
                            offerVC.UUID = beaconOffer.UUID
                            offerVC.tabBarVC = self
                            offerVC.beacons = beaconOffers
                            self.show(offerVC, sender: nil)
                        }
                    }
                }
                
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    //MARK: Connectivity
    func FetchBeaconOffers() {
        db.child("offers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let offers = snapshot.value as? NSDictionary {
                for offer in offers {
                    if let offerValue = offer.value as? NSDictionary {
                        let newBeaconOffer = BeaconOffer(data: offerValue)
                        newBeaconOffer.UUID = offer.key as? String ?? ""
                        Model.beaconOffers.append(newBeaconOffer)
                        
                    }
                }
                self.UpdateNearbyBeaconOffer()
            }
        })
    }

}
