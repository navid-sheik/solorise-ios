//
//  PreviewViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 01/08/2024.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class PreviewViewController: UIViewController {
    
    var videoURL: URL?
    var image: UIImage?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text"
        textField.backgroundColor = .white
        textField.textColor = .black
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    let playerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let videoURL = videoURL {
            setupVideoPlayer(with: videoURL)
        } else {
            setupImageView()
        }
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
        
        playerView.frame = view.bounds
        playerLayer.frame = playerView.bounds
        view.addSubview(playerView)
        playerView.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        imageView.frame = view.bounds
        textField.frame = CGRect(x: 20, y: view.frame.height - 250, width: view.frame.width - 40, height: 40)
        textField.delegate = self
        saveButton.frame = CGRect(x: view.frame.width - 230, y: view.frame.height - 60, width: 60, height: 40)
        
        if let image = image {
            imageView.image = image
        }
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        guard let image = imageView.image else { return }
        let renderer = UIGraphicsImageRenderer(size: image.size)
        let editedImage = renderer.image { context in
            image.draw(at: .zero)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 40),
                .foregroundColor: UIColor.red
            ]
            let text = textField.text ?? ""
            let textSize = text.size(withAttributes: textAttributes)
            let textRect = CGRect(x: (image.size.width - textSize.width) / 2, y: (image.size.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
            text.draw(in: textRect, withAttributes: textAttributes)
        }
        
        // Save edited image to photo library
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil)
    }
}

extension PreviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
