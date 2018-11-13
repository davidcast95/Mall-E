//
//  Product.swift
//  Mall-E
//
//  Created by David Wibisono on 10/19/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
class Object {
    var id = ""
    func Setup(dict:NSDictionary) {}
}

class UserPref {
    static private let user = UserDefaults()
    static var isFirstTime: Bool {
        set {
            user.set(newValue, forKey: "is-first-time")
        }
        get {
            return user.value(forKey: "is-first-time") as! Bool? ?? true
        }
    }
    static var isLogin: Bool {
        set {
            user.set(newValue, forKey: "is-login")
        }
        get {
            return user.value(forKey: "is-login") as! Bool? ?? false
        }
    }
    static var guest_id:String {
        set {
            user.set(newValue, forKey: "guest_id")
        }
        get {
            return user.value(forKey: "guest_id") as! String? ?? ""
        }
    }
    static var uid: String {
        set {
            user.set(newValue, forKey: "uid")
        }
        get {
            return user.value(forKey: "uid") as! String? ?? ""
        }
    }
    static var email: String {
        set {
            user.set(newValue, forKey: "email")
        }
        get {
            return user.value(forKey: "email") as! String? ?? ""
        }
    }
    static var token: String {
        set {
            user.set(newValue, forKey: "token")
        }
        get {
            return user.value(forKey: "token") as! String? ?? ""
        }
    }
    static var photoURL: URL? {
        set {
            user.set(newValue, forKey: "photoURL")
        }
        get {
            return user.value(forKey: "photoURL") as! URL? ?? nil
        }
    }
    static var adsSeen:String {
        set {
            user.set(newValue, forKey: "adsSeen")
        }
        get {
            return user.value(forKey: "adsSeen") as! String? ?? ""
        }
    }
    static var allNotification:Bool {
        set {
            user.set(newValue, forKey: "all-notification")
        }
        get {
            return user.value(forKey: "all-notification") as! Bool? ?? true
        }
    }
    static func Reset() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
}


class Model {
    static var latitude = 0.0, longitude = 0.0
    static var cities:[City] = []
    static var citiesName:[String] = []
    static var activeCity:City?
    static var beaconOffers:[BeaconOffer] = []
    static var nearbyBeaconOffer:BeaconOffer?
    static var nearbyOffer:[NearbyOffer] = []
    
    static func GetOfferNearbyBeacon() -> BeaconOffer? {
        let maxDistance = 100.0
        if beaconOffers.count > 0 {
            let dLat = abs(latitude - beaconOffers[0].lat)
            let dLong = abs(longitude - beaconOffers[0].long)
            var minimumDistance = sqrt(dLat + dLong)
            var indexMinDistance = 0
            for i in 1..<beaconOffers.count {
                let dLat = abs(latitude - beaconOffers[0].lat)
                let dLong = abs(longitude - beaconOffers[0].long)
                let newMin = sqrt(dLat + dLong)
                if newMin < minimumDistance {
                    minimumDistance = newMin
                    indexMinDistance = i
                }
            }
            if minimumDistance <= maxDistance {
                return beaconOffers[indexMinDistance]
            }
        }
        return nil
    }
    
    static var stores = [
        Store(name: "Tee-he", location: "Lt 3 T45", image: #imageLiteral(resourceName: "store1"), followed: false),
        Store(name: "Keep Calm Store", location: "Lt 3 T50", image: #imageLiteral(resourceName: "store2"), followed: false),
        Store(name: "Bounty", location: "Lt 3 T23", image: #imageLiteral(resourceName: "store3"), followed: false),
        
        Store(name: "Minipolis", location: "Lt 2 T45", image: #imageLiteral(resourceName: "store1"), followed: false),
        Store(name: "Emba", location: "Lt 2 T40", image: #imageLiteral(resourceName: "store2"), followed: false),
        Store(name: "Salvania", location: "Lt 2 T21", image: #imageLiteral(resourceName: "store3"), followed: false),
        
        Store(name: "Mango", location: "Lt 1 T21", image: #imageLiteral(resourceName: "store3"), followed: false),
        Store(name: "Kate Spade", location: "Lt 1 T21", image: #imageLiteral(resourceName: "store3"), followed: false)
    ]
    
    static var products = [
        Product(image: #imageLiteral(resourceName: "product1"), name: "Kiwanis Internasional", discount: 15, price: 250000, favourite: false, isOffered: true),
        Product(image: #imageLiteral(resourceName: "product2"), name: "Keep CALM and Carry On", discount: 20, price: 300000, favourite: false, isOffered: true),
        Product(image: #imageLiteral(resourceName: "product3"), name: "Blue Kiwanis", discount: 10, price: 300000, favourite: false, isOffered: true)
    ]
    
    static var favourites:[Favourite] = []
    
    static func GetOffer() -> [Offer] {
        let offers:[Offer] = []
//        for mall in malls {
//            for store in mall.stores {
//                let offer = Offer()
//                offer.store = store
//                for product in store.products {
//                    if product.isOffered == true {
//                        offer.product.append(product)
//                    }
//                }
//                if (offer.product.count != 0) {
//                    offers.append(offer)
//                }
//            }
//        }
        return offers
    }
    
    
}

class City : Object {
    var name = ""
    var malls:[Mall] = []
    
    init(data:NSDictionary) {
        self.name = data.value(forKey: "name") as? String ?? ""
        if let mallsValue = data.value(forKey: "malls") as? NSDictionary {
            for mall in mallsValue {
                if let mallValue = mall.value as? NSDictionary {
                    let newMall = Mall(data: mallValue)
                    newMall.id = mall.key as? String ?? ""
                    malls.append(newMall)
                }
            }
        }
    }
}


class Mall : Object {
    var name = ""
    var street = ""
    var linkImage = ""
    var featureImage:UIImage?
    var stores:[Store] = []
    
    init(data:NSDictionary) {
        self.name = data.value(forKey: "name") as? String ?? ""
        self.street = data.value(forKey: "street") as? String ?? ""
        self.linkImage = data.value(forKey: "feature_image") as? String ?? ""
        
    }
    
}

class Store : Object {
    //old
    var name:String!
    var image:UIImage!
    var location:String!
    var followed:Bool!
    var products:[Product]
    init(name:String,location:String,image:UIImage,followed:Bool) {
        self.name = name
        self.location = location
        self.image = image
        self.followed = followed
        self.products = []
    }
}


class Product : Object {
    var discount:Double!
    var price:Double!
    var favourite:Bool!
    var image:UIImage!
    var name:String!
    var isOffered:Bool!
    init(image:UIImage, name:String, discount:Double, price:Double,favourite:Bool,isOffered:Bool) {
        self.image = image
        self.name = name
        self.discount = discount
        self.price = price
        self.favourite = favourite
        self.isOffered = isOffered
    }
    
    
}

class Beacon {
    var majorMinor = ""
    var content = ""
    var feature_image:UIImage?
    init(majorMinor:String) {
        self.majorMinor = majorMinor
    }
    init(data:NSDictionary) {
        content = data.value(forKey: "content") as? String ?? ""
    }
}

class BeaconOffer {
    var UUID = ""
    var beacons:[Beacon] = []
    var lat = 0.0, long = 0.0
    init(data:NSDictionary) {
        if let beacons = data.value(forKey: "beacons") as? NSDictionary {
            for beacon in beacons {
                if let beaconValue = beacon.value as? NSDictionary {
                    let newBeacon = Beacon(data: beaconValue)
                    newBeacon.majorMinor = beacon.key as? String ?? ""
                    self.beacons.append(newBeacon)
                }
                
            }
        }
        lat = Double(data.value(forKey: "lat") as? String ?? "0") ?? 0.0
        long = Double(data.value(forKey: "long") as? String ?? "0") ?? 0.0
    }
    
    func FindBeacon(majorMinor:String) -> Bool {
        for beacon in beacons {
            if beacon.majorMinor == majorMinor {
                return true
            }
        }
        return false
    }
}

class Offer {
    var product:[Product] = []
    var store:Store!
}
class Favourite {
    var product:Product!
    var store:Store!
}

class NearbyOffer: Object {
    var title = ""
    var desc = ""
    var image_link = ""
    var bg_color:UIColor = .white
    var feature_image:UIImage?
    override func Setup(dict: NSDictionary) {
        self.title = dict.value(forKey: "title") as? String ?? ""
        self.desc = dict.value(forKey: "desc") as? String ?? ""
        self.image_link = dict.value(forKey: "image_link") as? String ?? ""
        var hex = dict.value(forKey: "bg_color") as? String ?? ""
        bg_color = UIColor(hex: hex)
    }
}


extension Array {
    func GetFavourite() -> [Product] {
        var products = Array<Product>()
        for element in self {
            if let product = element as? Product {
                if product.favourite == true {
                    products.append(product)
                }
            }
        }
        return products
    }
}



