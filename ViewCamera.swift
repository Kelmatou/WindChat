//
//  ViewCamera.swift
//  WindChat
//
//  Created by Antoine Clop on 12/9/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

import UIKit
import AVFoundation

class ViewCamera: UIViewController,
                  UIImagePickerControllerDelegate,
                  UINavigationControllerDelegate,
                  UIPickerViewDataSource,
                  UIPickerViewDelegate
{
    @IBOutlet var cameraScreen: UIView!
    @IBOutlet weak var error: UIButton!
    @IBOutlet weak var screenButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var timeSelection: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var touchTheScreen: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var takeAWind: UILabel!
    var openPhoto : Bool = true
    let pickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeSelection.delegate = self
        timeSelection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if (openPhoto)
        {
            openCamera()
            openPhoto = false
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func windOpen(_ sender: UIButton)
    {
        openCamera()
    }
    
    func openCamera()
    {
        timeSelection.isHidden = true
        error.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = chosenImage
        cameraScreen.backgroundColor = UIColor.black
        screenButton.isHidden = true
        touchTheScreen.isHidden = true
        to.isHidden = true
        takeAWind.isHidden = true
        retakeButton.isHidden = false
        sendButton.isHidden = false
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func sendWind(_ sender: Any)
    {
        let newWind = Wind()
        error.isHidden = true
        timeSelection.isHidden = true
        if imagePicked != nil && Wind.recipients.characters.count > 0
        {
            error.backgroundColor = UIColor(red: 253/255, green: 217/255, blue: 0, alpha: 1)
            error.setTitle("Sending...", for: UIControlState.normal)
            error.isHidden = false
            newWind.duration = 7
            let picture: UIImage = resizeImage(original: imagePicked.image!)
            let pictureData = UIImagePNGRepresentation(picture)
            newWind.image64 = pictureData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
            newWind.send()
            error.backgroundColor = UIColor(red: 105/255, green: 158/255, blue: 74/255, alpha: 1)
            error.setTitle("Wind sent!", for: UIControlState.normal)
        }
        else
        {
            error.backgroundColor = UIColor(red: 196/255, green: 57/255, blue: 56/255, alpha: 1)
            error.setTitle("No receiver specified", for: UIControlState.normal)
            error.isHidden = false
        }
    }
    
    func resizeImage(original: UIImage) -> UIImage
    {
        var actualHeight: Float = Float(original.size.height)
        var actualWidth: Float = Float(original.size.width)

        let ratio:Float = 720.0  //makes the picture smaller
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = 1
        
        if (actualHeight > ratio) || (actualWidth > ratio)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = ratio / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = ratio;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = ratio / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = ratio;
            }
            else
            {
                actualHeight = ratio;
                actualWidth = ratio;
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0,y: 0.0,width: CGFloat(actualWidth),height: CGFloat(actualHeight) )
        UIGraphicsBeginImageContext(rect.size)
        original.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        timeButton.setTitle(pickerData[row], for: UIControlState.normal)
        Wind.time = Int(pickerData[row])!
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 40.0)!,NSForegroundColorAttributeName:UIColor.black])
        return myTitle
    }
    
    @IBAction func openSelectTime(_ sender: Any)
    {
        timeSelection.isHidden = !timeSelection.isHidden
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}
}
