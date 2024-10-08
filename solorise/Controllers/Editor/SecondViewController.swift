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

class SecondViewController: UIViewController {
    
    weak var previewViewDelegate: PreviewViewControllerDelegate?
    
    // Capture session
    var session: AVCaptureSession?
    
    // Photo output
    let output = AVCapturePhotoOutput()
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    // Video output
    let videoOutput = AVCaptureMovieFileOutput()
    
    // Timer to handle long press
    var timer: Timer?
    var isRecording = false
    
    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    
    var currentCameraPosition: AVCaptureDevice.Position = .back
    
    let shutterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 10
        return button
    }()
    
    private let accessGalleryPreview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true // Enable interaction
        
        return imageView
    }()
    
    var imageData: UIImage? {
        didSet {
            if let image = imageData {
                let photoEditorVC = PreviewViewController()
                photoEditorVC.image = image
                photoEditorVC.delegate = previewViewDelegate  // Setting the delegate here
                navigationController?.pushViewController(photoEditorVC, animated: true)
            }
        }
    }

    var videoData: URL? {
        didSet {
            if let videoURL = videoData {
                let videoPreviewVC = PreviewViewController()
                videoPreviewVC.videoURL = videoURL
                videoPreviewVC.delegate =  previewViewDelegate  // Setting the delegate here
                navigationController?.pushViewController(videoPreviewVC, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(accessGalleryPreview)
        setUpConstraints()
        checkCameraPermission()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTakePhoto))
        shutterButton.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1 // Adjust as needed
        longPressRecognizer.delegate = self
        shutterButton.addGestureRecognizer(longPressRecognizer)
        
        setupCustomBackButton()
        
        
        // Add the camera toggle button
        // Add the camera toggle button
        let switchCameraButton = UIButton(type: .system)
        switchCameraButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(toggleCamera), for: .touchUpInside)

        // Add the button to the view
        view.addSubview(switchCameraButton)

        // Use anchor to position the button instead of setting the frame directly
        switchCameraButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  right: view.trailingAnchor,
                                  paddingTop: 20, paddingRight: 20,
                                  width: 50, height: 50)

    }
    
    func setupCustomBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpConstraints() {
        shutterButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: -50, width: 100, height: 100)
        shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        accessGalleryPreview.anchor(left: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: -50, width: 50, height: 50)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGalleryPreviewTap))
        accessGalleryPreview.addGestureRecognizer(tapGesture)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setUpCamera(position: self?.currentCameraPosition ?? .back)
                }
            }
        case .restricted, .denied:
            break
        case .authorized:
            setUpCamera(position: currentCameraPosition)
        @unknown default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            if let session = self.session, !session.isRunning {
                session.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .background).async {
            if let session = self.session, session.isRunning {
                session.stopRunning()
            }
        }
    }
    
    private func setUpCamera(position: AVCaptureDevice.Position) {
        DispatchQueue.global(qos: .userInitiated).async {
            let session = self.session ?? AVCaptureSession() // Use existing session if available
            
            // Select the appropriate camera based on the position
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    // Remove existing inputs before adding a new one
                    if let currentInput = self.session?.inputs.first as? AVCaptureDeviceInput {
                        self.session?.removeInput(currentInput)
                    }

                    // Add the new input to the session
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    // Configure outputs (photo and video)
                    if session.canAddOutput(self.output) {
                        session.addOutput(self.output)
                    }
                    if session.canAddOutput(self.videoOutput) {
                        session.addOutput(self.videoOutput)
                    }
                    
                    // Make UI changes (preview layer) on the main thread
                    DispatchQueue.main.async {
                        self.previewLayer.videoGravity = .resizeAspectFill
                        self.previewLayer.session = session
                    }
                    
                    // Start the session on a background thread
                    DispatchQueue.global(qos: .background).async {
                        session.startRunning()
                        self.session = session
                    }
                } catch {
                    print("Error setting up the camera input: \(error)")
                }
            }
        }
    }

    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended, .cancelled, .failed:
            stopRecording()
        default:
            break
        }
    }
    
    @objc private func handleGalleryPreviewTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func toggleCamera() {
        // Stop the session before switching cameras
        session?.beginConfiguration()
        
        // Remove all existing inputs
        if let currentInput = session?.inputs.first as? AVCaptureDeviceInput {
            session?.removeInput(currentInput)
        }

        // Toggle the camera position
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back

        // Reconfigure the camera with the new position
        setUpCamera(position: currentCameraPosition)

        session?.commitConfiguration()
    }


    
    private func startRecording() {
        guard let session = session, session.isRunning, !isRecording else { return }
        
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
}

extension SecondViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageData = selectedImage
        } else if let mediaURL = info[.mediaURL] as? URL {
            videoData = mediaURL
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SecondViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        session?.stopRunning()
        
        if let image = UIImage(data: data) {
            let photoEditorVC = PreviewViewController()
            photoEditorVC.image = image
            photoEditorVC.delegate = previewViewDelegate  // Setting the delegate here
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(photoEditorVC, animated: true)
            }
        }
    }
}

extension SecondViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Finished recording to: \(outputFileURL)")
        session?.stopRunning()
        if let error = error {
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            let videoPreviewVC = PreviewViewController()
            videoPreviewVC.videoURL = outputFileURL
            videoPreviewVC.delegate = previewViewDelegate  // Setting the delegate here
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(videoPreviewVC, animated: true)
            }
        }
    }
}

extension SecondViewController: UIGestureRecognizerDelegate {
}
