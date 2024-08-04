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
    
    // Video output
    let videoOutput = AVCaptureMovieFileOutput()
    
    // Timer to handle long press
    var timer: Timer?
    var isRecording = false
    
    var activeInput: AVCaptureDeviceInput!

       var outputURL: URL!

    
    
    let shutturButton  :  UIButton = {
        let button  =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.backgroundColor =  .white
        
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTakePhoto))
           shutturButton.addGestureRecognizer(tapRecognizer)

           let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPressRecognizer.minimumPressDuration = 1 // Adjust as needed
        longPressRecognizer.delegate =  self
           shutturButton.addGestureRecognizer(longPressRecognizer)
        
//        shutturButton.addTarget(self, action: #selector(didTapTakePhoto) , for: .touchUpInside)
        
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
        
        DispatchQueue.global(qos: .userInitiated).async {
            let session =  AVCaptureSession()
            if let device =  AVCaptureDevice.default(for: .video){
                do{
                    let input =  try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input){
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self.output){
                        session.addOutput(self.output)
                    }
                    
                    
                    if session.canAddOutput(self.videoOutput) {
                                           session.addOutput(self.videoOutput)
                    }

                    
                    self.previewLayer.videoGravity =  .resizeAspectFill
                    self.previewLayer.session =  session
                    session.startRunning()
                    self.session =  session
                    
                    
                }catch{
                    print(error)
                }
            }
            
        }
        
    }
    
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
          switch gesture.state {
          case .began:
              startRecording()
          case .ended:
              print("emded")
              stopRecording()
              
          case .cancelled:
              print("Cancelled")
              stopRecording()
          case .failed:
              print("Failed")
              stopRecording()
          default:
              break
          }
      }

    
    private func startRecording() {
        guard let session = session, session.isRunning, !isRecording else { return }
        
        // Get a unique temporary file URL
        let outputPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(UUID().uuidString + ".mov")
        let outputFileURL = URL(fileURLWithPath: outputPath)
        
        videoOutput.startRecording(to: outputFileURL, recordingDelegate: self)
        isRecording = true
    }

      private func stopRecording() {
          guard isRecording else { return }
          videoOutput.stopRecording()
          isRecording = false
      }
  

    
    private func takePhoto() {
           let photoSettings = AVCapturePhotoSettings()
           output.capturePhoto(with: photoSettings, delegate: self)
       }

   





}

extension SecondViewController :  AVCapturePhotoCaptureDelegate{
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data =  photo.fileDataRepresentation()  else{
            return
        }
        
        session?.stopRunning()
        
//        let image  =  UIImage(data: data)
//        
//        let imageView  =  UIImageView(image: image)
//        imageView.contentMode =  .scaleAspectFill
//        imageView.frame =  view.bounds
//        view.addSubview(imageView)
//        
//        
        let controller  =  PreviewViewController()
        DispatchQueue.main.async {
            
            if let image = UIImage(data: data) {
               let photoEditorVC = PreviewViewController()
               photoEditorVC.image = image
                self.navigationController?.pushViewController(photoEditorVC, animated: true)
            }

        }
    }
    
}

extension SecondViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started recording to: \(fileURL)")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Finished recording to: \(outputFileURL)")
        session?.stopRunning()
        if let error = error {
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            let controller = PreviewViewController()
            controller.videoURL = outputFileURL
            print(outputFileURL)
            print("pushing the controller")
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

extension SecondViewController :  UIGestureRecognizerDelegate{
    
}
