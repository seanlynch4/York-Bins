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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    @IBOutlet var userPostcode: UITextField!
    @IBOutlet var changeAddressButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addressPicker: UIPickerView!
    @IBOutlet var containerViewAddressPicker: UIView!
    @IBOutlet var sumbitPostcodeButton: UIButton!
    @IBOutlet var setAddress: UIButton!

    var properties = [Home]()
    var userUprn: Int?
    var userShortAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Action listener on the submit postcode button
    @IBAction func submitPostcode(sender: AnyObject) {
        properties.removeAll() //removes all previous addresses
        if userPostcode.text != ""
        {
            let postcode = userPostcode.text //formats the postcode to add to the api url
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
    
    //connects to the APi with the postcode the user entered gets the JSON response filters out the Uprn and ShortAddress adds them to a array with a struct of Home
    func getAddresses(formattedPostcode: String)
    {
        let url = "https://doitonline.york.gov.uk/BinsApi/EXOR/getPropertiesForPostCode?postcode="+(formattedPostcode)
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
                                let property = Home(uprn: item["Uprn"].int, shortAddress: item["ShortAddress"].string)
                                self.properties.append(property)
                            }
                            self.showContainerPicker()
                        }
                        else
                        {
                            self.errorMessage("Poscode Missing",message: "Please Enter a Valid Postcode                e.g YO1 6DS")
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    
    //↓↓↓↓ Start of Picker Setup
    //sets how many pickers
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Sets the size of the picker based on the amount of properties linked to the Postcode
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return properties.count
    }
    
    //Sets what the user sees when scrolling through the picker
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return properties[row].shortAddress
    }
    
    //runs when the user selects a row in the picker gets the uprn and short address and sets them to variables
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        userUprn = properties[row].uprn
        userShortAddress = properties[row].shortAddress
    }
    //↑↑↑↑	End of Picker Setup
    
    
    
    //error message function can be called pass a title and a string
    func errorMessage(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //shows the picker pop up that allows the user to select an address
    @IBAction func showContainerPicker() {
        
        addressPicker.delegate = self
        addressPicker.dataSource = self
        addressLabel.hidden = false
        containerViewAddressPicker.hidden = false
        sumbitPostcodeButton.setTitle("Change Postcode", forState: .Normal)
        pickerView(self.addressPicker, didSelectRow: 0, inComponent: 0)
        
    }
    
    //hides the container when the user has selected a address
    @IBAction func hideContainerPicker()
    {
        addressLabel.numberOfLines = 0;
        addressLabel.text = userShortAddress
        containerViewAddressPicker.hidden = true
        setAddress.hidden = false
        changeAddressButton.hidden = false
    
    }
    
    //user confirms the address
    @IBAction func setAddress(sender: AnyObject)
    {
       
        var storedUprn: String!
        var storedShortAddress: String!
        if let uprn = userUprn
        {
           storedUprn =  String(uprn)
        }
        
        if let shortAddress = userShortAddress
        {
           storedShortAddress =  String(shortAddress)
        }
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("uprn")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("shortAddress")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(storedUprn, forKey: "uprn")
        defaults.setObject(storedShortAddress, forKey: "shortAddress")
        
        self.performSegueWithIdentifier("setAddress", sender: self)
    }
}

struct Home
{
    let uprn: Int?
    let shortAddress: String?
}