import Foundation
import UIKit
import AVFoundation
import AVKit

protocol PreviewViewControllerDelegate: AnyObject {
    func didSaveEditedImage(_ image: UIImage)
}

class PreviewViewController: UIViewController {
    
    weak var delegate: PreviewViewControllerDelegate?
    
    
    var videoURL: URL?
    var image: UIImage?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?

    let showTextFieldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(toggleEditingMode), for: .touchUpInside)
        return button
    }()
    
    let closeEditorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(closeEditor), for: .touchUpInside)
        return button
    }()
    
    let submitPostButton: UIButton = {
        let button = UIButton(type: .system)
        
        // Configure the system image with a specific point size and scale
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let image = UIImage(systemName: "paperplane.circle", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate)
        
        // Set the image and ensure it fits the button
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        // Set content mode to ensure the image scales within the button's bounds
        button.imageView?.contentMode = .scaleAspectFit
        
        // Add action for the button
        button.addTarget(self, action: #selector(submitPost), for: .touchUpInside)
        
        return button
    }()


    let textViewInMedia: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textView.textColor = .white
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.text = ""
        textView.isEditable = false  // Initially non-editable
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let fontSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 10
        slider.maximumValue = 40
        slider.value = 16
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(fontSizeChanged(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var buttonStackView: UIStackView!
    var textViewHeightConstraint: NSLayoutConstraint!
    var textViewWidthConstraint: NSLayoutConstraint!
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isEditingMode = false  // Track editing mode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTapGestureToDismissKeyboard()
        view.backgroundColor = .systemBackground
        
        if let videoURL = videoURL {
            setupVideoPlayer(with: videoURL)
        } else {
            setupImageView()
        }
        
        // Check if the textView has content and set its initial visibility
        textViewInMedia.alpha = textViewInMedia.text.isEmpty ? 0 : 1
        textViewInMedia.delegate = self
        
        // Add a tap gesture recognizer to the textView to enter editing mode
        let textViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(enterEditingModeFromTap))
        textViewInMedia.addGestureRecognizer(textViewTapGesture)
        
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        overlayView.addSubview(fontSizeSlider)
        NSLayoutConstraint.activate([
            fontSizeSlider.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            fontSizeSlider.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            fontSizeSlider.bottomAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        fontSizeSlider.isHidden = true  // Initially hidden
        
        buttonStackView = StackManager.createStackView(
            with: [showTextFieldButton],
            axis: .horizontal,
            spacing: 5,
            distribution: .fillProportionally,
            alignment: .fill
        )
        
        view.addSubview(closeEditorButton)
        view.addSubview(buttonStackView)
        
        closeEditorButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leadingAnchor,
            right: nil,
            paddingTop: 0,
            width: 35,
            height: 35
        )
        
        buttonStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: nil,
            right: view.trailingAnchor,
            paddingTop: 0,
            paddingRight: -5,
            height: 35
        )
        
        view.addSubview(textViewInMedia)
        textViewInMedia.anchor(height: nil)
        
        view.addSubview(submitPostButton)
        submitPostButton.anchor(
           
            left: nil,
            right: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: -5,
            width: 35,
            height: 35
           
        )
        
        
        
        textViewHeightConstraint = textViewInMedia.heightAnchor.constraint(equalToConstant: 35)
        textViewHeightConstraint.isActive = true
        
        textViewWidthConstraint = textViewInMedia.widthAnchor.constraint(equalToConstant: 150)
        textViewWidthConstraint.isActive = true
        textViewInMedia.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        textViewInMedia.addGestureRecognizer(panGesture)
        textViewInMedia.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer to the overlay to dismiss the keyboard
        let overlayTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(overlayTapGesture)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let playerLayer = playerLayer {
            playerLayer.frame = playerView.bounds
        }
    }
    
    private func setupVideoPlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else { return }
        
        view.addSubview(playerView)
        playerView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leadingAnchor,
            right: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor
        )
        playerView.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        if textViewInMedia.isFirstResponder {
            textViewInMedia.resignFirstResponder()
        }
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leadingAnchor,
            right: view.trailingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor
        )
        if let image = image {
            imageView.image = image
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let textField = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        var newCenter = CGPoint(x: textField.center.x + translation.x, y: textField.center.y + translation.y)
        
        let containerView: UIView = videoURL != nil ? playerView : imageView
        let containerFrame = view.convert(containerView.frame, from: containerView.superview)
        let containerBounds = containerFrame.insetBy(dx: textField.bounds.width / 2, dy: textField.bounds.height / 2)
        
        newCenter.x = max(containerBounds.minX, min(newCenter.x, containerBounds.maxX))
        newCenter.y = max(containerBounds.minY, min(newCenter.y, containerBounds.maxY))
        
        textField.center = newCenter
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc func toggleEditingMode() {
        isEditingMode.toggle()
        
        if isEditingMode {
            UIView.animate(withDuration: 0.5) {
                self.overlayView.alpha = 1
                self.textViewInMedia.alpha = 1
                self.textViewInMedia.isEditable = true
                self.showTextFieldButton.tintColor = .blue
                self.fontSizeSlider.isHidden = false
            }
            textViewInMedia.becomeFirstResponder()
        } else {
            UIView.animate(withDuration: 0.5) {
                self.overlayView.alpha = 0
                if self.textViewInMedia.text.isEmpty {
                    self.textViewInMedia.alpha = 0
                }
                self.textViewInMedia.isEditable = false
                self.showTextFieldButton.tintColor = .gray
                self.fontSizeSlider.isHidden = true
            }
            view.endEditing(true)
        }
    }
    
    @objc func enterEditingModeFromTap() {
        // Switch to editing mode when the textView is tapped
        isEditingMode = true
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 1
            self.textViewInMedia.alpha = 1
            self.textViewInMedia.isEditable = true
            self.showTextFieldButton.tintColor = .blue
            self.fontSizeSlider.isHidden = false
        }
        textViewInMedia.becomeFirstResponder()
    }
    
    @objc func closeEditor() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func submitPost(){
        print("Submit post")
        
        guard let image = imageView.image else {
            print("No image found in imageView")
            return
        }
        
        // Start a graphics context with the image's size
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0.0)
        
        // Draw the existing image in the context
        image.draw(in: CGRect(x: 0, y: 0, width: imageView.bounds.width, height: imageView.bounds.height))
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
        
        // Translate the context to the position of the textView within the imageView
        context?.translateBy(x: textViewInMedia.frame.origin.x, y: textViewInMedia.frame.origin.y)
        
        // Render the textView layer in the context
        textViewInMedia.layer.render(in: context!)
        
        // Capture the combined image
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
        
     
        // Save or use the combined image
        if let finalImage = combinedImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            delegate?.didSaveEditedImage(finalImage)
            self.navigationController?.popToRootViewController(animated: true)
            print("Image saved successfully")
        } else {
            print("Failed to create combined image")
        }
    }
    
    @objc func fontSizeChanged(_ sender: UISlider) {
        let newFontSize = CGFloat(sender.value)
        textViewInMedia.font = UIFont.systemFont(ofSize: newFontSize)
        
        // Resize the textView to fit the new font size
        let fittingSize = CGSize(width: view.bounds.width - 40, height: .infinity)
        let estimatedSize = textViewInMedia.sizeThatFits(fittingSize)
        
        // Store the current frame's origin before updating constraints
        let currentOrigin = textViewInMedia.frame.origin
        
        // Update constraints
        textViewHeightConstraint.constant = estimatedSize.height
        textViewWidthConstraint.constant = max(estimatedSize.width, 150) // Ensure a minimum width
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            
            // Reposition the text view to maintain its top-left corner position
            self.textViewInMedia.frame.origin = currentOrigin
        }
    }
}

extension PreviewViewController: UITextViewDelegate {
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fittingSize = CGSize(width: view.bounds.width - 40, height: .infinity)
        let estimatedSize = textView.sizeThatFits(fittingSize)
        
        let minimumWidth: CGFloat = 150
        
        // Store the current center before updating constraints
        let currentCenter = textView.center
        
        // Update constraints
        textViewHeightConstraint.constant = estimatedSize.height
        textViewWidthConstraint.constant = max(estimatedSize.width, minimumWidth)
        
        // Animate layout changes and restore the position
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            textView.center = currentCenter  // Restore the center position
        }
    }
}

