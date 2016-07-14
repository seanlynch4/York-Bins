//
//  ViewController2.swift
//  
//
//  Created by Sean on 13/07/2016.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import JSONJoy


class ViewController2: UIViewController {

    @IBOutlet var label: UILabel!
    var collections = [Waste]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let retrive = NSUserDefaults.standardUserDefaults()
        if let address = retrive.stringForKey("shortAddress") {
            label.text = address
        }
        if let uprn = retrive.stringForKey("uprn")
        {
           getData(uprn)
        }
        

    }

    func getData(uprn: String)
    {
        let url = "https://doitonline.york.gov.uk/BinsApi/EXOR/getWasteCollectionDatabyUprn?uprn="+(uprn)
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if let JSON = json.array
                    {
                        if JSON.count != 0
                        {
                            for item in JSON
                            {
                                let collection = Waste(
                                    WasteTypeDescription: item["WasteTypeDescription"].string, WasteType: item["WasteType"].string, CollectionDay: item["CollectionDay"].string, MaterialsCollected: item["MaterialsCollected"].string, LastCollection: item["LastCollection"].string, NextCollection: item["NextCollection"].string, CollectionAvailable: item["CollectionAvailable"].string, BinType: item["BinType"].string)
                                self.collections.append(collection)
                                print(collection,"\n")
                            }
      
                            self.sortCollectionData()
                        }
                        else
                        {
                            self.errorMessage("No Data",message: "There is No Data For this Postcode")
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    func sortCollectionData()
    {
        
    }
    
    
    //error message function can be called pass a title and a string
    func errorMessage(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


   
}

struct Waste {
    var WasteTypeDescription: String?
    var WasteType: String?
    var CollectionDay: String?
    var MaterialsCollected: String?
    var LastCollection: String?
    var NextCollection: String?
    var CollectionAvailable: String?
    var BinType: String?
}

extension NSDate {
    convenience init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        // Check for correct format:
        if jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) {
            // Extract the number as a string:
            let from = jsonDate.startIndex.advancedBy(prefix.characters.count)
            let to = jsonDate.endIndex.advancedBy(-suffix.characters.count)
            // Convert milleseconds to double
            guard let milliSeconds = Double(jsonDate[from ..< to]) else {
                return nil
            }
            // Create NSDate with this UNIX timestamp
            self.init(timeIntervalSince1970: milliSeconds/1000.0)
        } else {
            return nil
        }
    }
}
