//
//  InvidualPostController.swift
//  solorise
//
//  Created by Navid Sheikh on 04/09/2024.
//

import Foundation
import UIKit

class InvidualPostController: UIViewController {

    var post: Post? {
        didSet {
            // Ensure the view is loaded before accessing UI elements
            if isViewLoaded {
                loadPostImage()
            }
        }
    }

    let mainImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "image-placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .init(white: 0.9, alpha: 0.5)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .systemBackground
        self.setUpView()
        loadPostImage() // Ensure image is loaded if post is already set when the view is loaded
    }

    // Custom initializer for post
    init(post: Post? = nil) {
        self.post = post
        super.init(nibName: nil, bundle: nil) // Proper call to UIViewController's initializer
    }

    // Required initializer for decoding
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Function to set up the view layout
    private func setUpView() {
        self.view.addSubview(mainImage)
        
        // Assuming anchor is a custom extension method for layout
        self.mainImage.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                              left: self.view.leadingAnchor,
                              right: self.view.trailingAnchor,
                              bottom: nil,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingRight: 0,
                              paddingBottom: 0,
                              width: nil,
                              height: self.view.frame.height / 2)
    }
    
    // Move image-loading logic to a separate method
    private func loadPostImage() {
        guard let imageUrlString = post?.image, let url = URL(string: imageUrlString) else {
            return
        }
        
        // Asynchronously download the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to download image: \(error)")
                return
            }

            guard let data = data else {
                print("No image data found")
                return
            }

            DispatchQueue.main.async { // Ensure UI updates on the main thread
                self.mainImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
