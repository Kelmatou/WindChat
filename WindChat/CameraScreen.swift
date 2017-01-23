//
//  CameraScreen.swift
//  WindChat
//
//  Created by Antoine Clop on 12/8/16.
//  Copyright © 2016 clop_a. All rights reserved.
//

/*import UIKit
import AVFoundation

class CameraScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var capture_session : AVCaptureSession?
    var still_image_output : AVCaptureStillImageOutput?
    var preview_layer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet var camera: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        capture_session = AVCaptureSession()
        capture_session?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        var back_camera = AVCaptureDevice.defaultDevice(withMediaType: "video")
        var error : NSError?
        var input = AVCaptureDeviceInput(device: back_camera, error : &error)
        
        if error == nil && capture_session?.canAddInput(input)
        {
            capture_session?.addInput(input)
            still_image_output = AVCaptureStillImageOutput()
            still_image_output?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if capture_session?.canAddOutput(still_image_output)
            {
                capture_session?.addOutput(still_image_output)
                preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)
                preview_layer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                camera.layer.addSublayer(preview_layer)
                capture_session?.startRunning()
            }
        }
    }
}*/
