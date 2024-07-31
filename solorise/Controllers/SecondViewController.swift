//
//  SecondViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 31/07/2024.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos


class SecondViewController: UIViewController{
    
    //capture session
    var session :  AVCaptureSession?
    
    //Photo output
    let output  = AVCapturePhotoOutput()
    
    //Video Preview
    let previewLayer  =  AVCaptureVideoPreviewLayer()
    
    
    let shutturButton  :  UIButton = {
        let button  =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        button.layer.cornerRadius  = 50
        button.layer.borderWidth  =  3
        button.layer.borderColor   = UIColor.white.cgColor
        button.layer.borderWidth = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutturButton)
        checkCameraPermission()
        
        shutturButton.addTarget(self, action: #selector(didTapTakePhoto) , for: .touchUpInside)
        
    }
    
    private func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] granted in
                guard  granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame =  view.bounds
        
        shutturButton.center =  CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height  - 100)
    }
    
    
    
    private func setUpCamera(){
        let session =  AVCaptureSession()
        if let device =  AVCaptureDevice.default(for: .video){
            do{
                let input =  try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                    
                previewLayer.videoGravity =  .resizeAspectFill
                previewLayer.session =  session
                session.startRunning()
                self.session =  session
                
                
            }catch{
                print(error)
            }
        }
        
    }
    
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }


}

extension SecondViewController :  AVCapturePhotoCaptureDelegate{
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data =  photo.fileDataRepresentation()  else{
            return
        }
        
        session?.stopRunning()
        
        let image  =  UIImage(data: data)
        
        let imageView  =  UIImageView(image: image)
        imageView.contentMode =  .scaleAspectFill
        imageView.frame =  view.bounds
        view.addSubview(imageView)
    }
    
}
