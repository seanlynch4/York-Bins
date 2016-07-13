//
//  ViewController.swift
//  York Bin Collection
//
//  Created by Sean on 12/07/2016.
//  Copyright © 2016 Sean. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JSONJoy

class ViewController: UIViewController {

    
    
    @IBOutlet var userPostcode: UITextField!
    @IBOutlet var changeAddressButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    var properties = [Home]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func submitPostcode(sender: AnyObject) {
        if userPostcode.text != ""
        {
            let postcode = userPostcode.text
            let rmws = postcode!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            var myStringArr = rmws.componentsSeparatedByString(" ")
            if myStringArr.count < 2 || myStringArr.count > 2
            {
                errorMessage("Poscode Missing",message: "Please Enter a Valid Postcode                e.g YO1 6DS")
            }
            else
            {
                let first: String = myStringArr [0]
                let second: String = myStringArr [1]
                let formattedPostcode = (first) + "%20" + (second)
                getAddresses(formattedPostcode)
                
            }
        }
        else
        {
            errorMessage("Poscode Missing",message: "Please Enter a Postcode")
        }
    }
    
    func getAddresses(formattedPostcode: String)
    {
        let url = "https://doitonline.york.gov.uk/BinsApi/EXOR/getPropertiesForPostCode?postcode="+(formattedPostcode)
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    /*for item in json
                    {
                        let property = Home(shortAddress: item["ShortAddress"].string, uprn: item["Uprn"].string)
                        self.properties.append(property)
                    }
                    print(self.properties)*/
                }
            case .Failure(let error):
                print(error)
            }
        }    }

    func errorMessage(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func showContainerPicker(sender: AnyObject) {
    }
    
    @IBAction func hideContainerPicker(sender: AnyObject) {
    }
}

struct Home
{
    let shortAddress: String?
    let uprn: String?
}