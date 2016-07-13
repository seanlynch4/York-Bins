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
    var userUprn: String?
    var userShortAddress: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return properties.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return properties[row].shortAddress
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        userUprn = properties[row].uprn
        userShortAddress = properties[row].shortAddress
    }

    


    @IBAction func submitPostcode(sender: AnyObject) {
        properties.removeAll()
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
                    if let JSON = json.array
                    {
                        for item in JSON
                        {
                            let property = Home(uprn: String(item["Uprn"].int), shortAddress: item["ShortAddress"].string)
                            self.properties.append(property)
                        }
                    }
                    self.showContainerPicker()
                    
                    
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

    @IBAction func showContainerPicker() {
        
        self.addressPicker.delegate = self
        self.addressPicker.dataSource = self
        
        addressLabel.hidden = false
        changeAddressButton.hidden = false
        containerViewAddressPicker.hidden = false
        sumbitPostcodeButton.setTitle("Change Postcode", forState: .Normal)
        pickerView(self.addressPicker, didSelectRow: 0, inComponent: 0)
        
    }
    
    @IBAction func setAddress(sender: AnyObject)
    {
        print("Uprn:",userUprn, " ShortAddress:", userShortAddress)
    }
    
    
    @IBAction func hideContainerPicker()
    {
        addressLabel.numberOfLines = 0;
        addressLabel.text = userShortAddress
        self.containerViewAddressPicker.hidden = true
        self.setAddress.hidden = false
    
    }
}

struct Home
{
    let uprn: String?
    let shortAddress: String?
}