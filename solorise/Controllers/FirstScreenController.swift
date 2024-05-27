//
//  ViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 20/05/2024.
//

import UIKit

class FirstScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemMint
        // Do any additional setup after loading the view.
        NetworkManager.shared.test(expecting: ApiResponse<String>.self) { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let result):
                print(result)
            case .failure(let error):
                print("The error is")
                print(error)
            }
            
        }
    }


}

