//
//  MyPageControllerViewController.swift
//  solorise
//
//  Created by Navid Sheikh on 29/06/2024.
//

import UIKit



enum MenuOption: String, CaseIterable {
    case add = "Grind"
    case remove = "Highlights"
    case view = "Journal"
    
    var description: String {
        return self.rawValue
    }
}

class MyPageControllerViewController: UIViewController{
    var pages = [UIViewController]()
    
    let posts =  [Post]()
    
    
    
    let mainImage : CustomImageView  = {
        let imageView  = CustomImageView()
        imageView.image =  UIImage(named: "image-placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius =  .init(10)
        
        imageView.clipsToBounds = true
        imageView.backgroundColor =  .init(white: 0.9, alpha: 0.5)
        return imageView
    }()
    
    let bio: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.text = "Great things"
        textView.textAlignment = .justified
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.sizeToFit()
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
   
        return textView
    }()
    
    
    let menuPageCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .none
       
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
//        cv.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        cv.showsHorizontalScrollIndicator =  false
    
        return cv
    }()
    private let menuIdentifier: String =  "menuIdentifier"
    var pageViewController: UIPageViewController!
//    private var currentIndex: Int {
//          guard let viewController = viewControllers?.first, let index = pages.firstIndex(of: viewController) else {
//              return 0
//          }
//          return index
//      }
//    
    private var currentIndex: Int {
        guard let viewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: viewController) else {
            return 0
        }
        return index
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//      
//        setUpPage()
        self.view.backgroundColor = .systemBackground
        setUpView()
        setCollectionView()
        setUpPage()
       
        
  
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func setUpView(){
        view.addSubview(mainImage)
        view.addSubview(bio)
        mainImage.anchor( top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leadingAnchor, right: nil, bottom: nil, paddingTop: 10, paddingLeft: 10,paddingRight: 0, paddingBottom: 0, width: nil, height: nil)
        mainImage.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        
        
        bio.anchor( top: self.mainImage.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 10, paddingLeft: 10,paddingRight: -10, paddingBottom: 0, width: nil, height: 50)
    
    }
    
    private func setCollectionView(){
        menuPageCollection.delegate = self
        menuPageCollection.dataSource = self
        menuPageCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: menuIdentifier)
        view.addSubview(menuPageCollection)
        menuPageCollection.anchor(top: self.bio.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: nil, height: 40)    
    }
    
    private func setUpPage(){
        navigationController?.navigationBar.isHidden = true
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
               pageViewController.dataSource = self
               pageViewController.delegate = self

               self.addChild(pageViewController)
               view.addSubview(pageViewController.view)
               pageViewController.didMove(toParent: self)
        
        // Do any additional setup after loading the view.
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        
        pageViewController.view.anchor(top: self.menuPageCollection.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor, bottom: self.view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: nil, height: nil)
        // Create the individual view controllers that will be managed by the page view controller
        let page1 = GrindProfileController()
//        page1.view.backgroundColor = .red
        let page2 = UIViewController()
        page2.view.backgroundColor = .green
        let page3 = UIViewController()
        page3.view.backgroundColor = .blue

        // Add them to the array
        pages.append(contentsOf: [page1, page2, page3])

        if let firstViewController = pages.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
   
 

}
extension MyPageControllerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
  
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil // Loop to array.count - 1 if you want cyclic scrolling
        }

        guard pages.count > previousIndex else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let pageCount = pages.count

        guard pageCount != nextIndex else {
            return nil // Loop to 0 if you want cyclic scrolling
        }

        guard pageCount > nextIndex else {
            return nil
        }

        return pages[nextIndex]
    }
    // UIPageViewControllerDelegate method to sync collection view with page changes
       func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
           if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: visibleViewController) {
               menuPageCollection.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
               collectionView(menuPageCollection, didSelectItemAt: IndexPath(item: index, section: 0))
           }
       }
    
    
    
    
    
 

    
    
}

let menuOptions =  MenuOption.allCases

extension MyPageControllerViewController :  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: menuIdentifier, for: indexPath)
        cell.backgroundColor = .black
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        title.textColor = .white
        title.text = menuOptions[indexPath.row].description
        title.font = UIFont.systemFont(ofSize: 14)
       title.textAlignment = .center
       cell.contentView.addSubview(title)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 2) / 3 , height: menuPageCollection.bounds.height)
    }
    
    // UICollectionViewDelegate methods
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let direction: UIPageViewController.NavigationDirection = currentIndex < indexPath.item ? .forward : .reverse
       pageViewController.setViewControllers([pages[indexPath.item]], direction: direction, animated: true, completion: nil)
   }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    
}
