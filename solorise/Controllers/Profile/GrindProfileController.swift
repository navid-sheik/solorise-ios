//
//  GrindProfileController.swift
//  solorise
//
//  Created by Navid Sheikh on 29/06/2024.
//

import UIKit


class GrindProfileController: UIViewController {
    
    var categories  =  ["One", "Two",  "three", "Four",  "Five", "One", "Two",  "three", "Four",  "Fivesomethingis"]
    
    var sections  =  [[Post]]()
    
    let identifierGriendCell =  "identifirGrindCell"
    
    let identifierFilterrCell =  "identifierFilterrCell"
    
    static let headerId   = "headerId"
    
     let headerGrinderLabelId =  "headerGrinderLabelId"
    
    let collectionView : UICollectionView = {
        let cv  =  UICollectionView(frame: .zero, collectionViewLayout: GrindProfileController.createLayout())
        cv.backgroundColor  = .white
        return cv
    }()
    
    let profileActivitiesCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isScrollEnabled = true
        cv.backgroundColor = .systemBackground
        cv.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        cv.showsHorizontalScrollIndicator =  false
    
        return cv
    }()
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.fetchPopularSearches()
        self.fecthAllImage()
        view.addSubview(profileActivitiesCollection)
        view.addSubview(collectionView)
        
//        
//        profileActivitiesCollection.backgroundColor = .systemCyan
        profileActivitiesCollection.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, left: view.leadingAnchor, right: view.trailingAnchor, bottom: nil, paddingTop: 5, paddingLeft: 0, paddingRight: 0, paddingBottom: -20, width: nil, height: 42)
        
        collectionView.anchor(top: self.profileActivitiesCollection.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: -20, width: nil, height: nil)
        
       
        


        // Do any additional setup after loading the view.
    }
    
    func fecthAllImage(){
        
        print("Print popualar  images ")
        
        NetworkManager.shared.getAllImages(expecting: ImagesResponse.self) { [weak self]  result in
            guard let self  = self else {return}
            switch result {
                
            case .success(let response):
                
                print(response)
            case .failure(_):
                print("Error fetching")
            }
            
        }
    }
    func fetchPopularSearches (){
        print("Print popualar searches ")
        
        NetworkManager.shared.getAllPost(expecting: ApiResponse<[Post]>.self) { [weak self]  result in
            guard let self  = self else {return}
                   switch result {
       
                   case .success(let response):
                       guard let posts  = response.data else {return}
                       self.sections.append( posts)
                       DispatchQueue.main.async {
                           self.collectionView.reloadData()
                       }
                   case .failure(_):
                       print("Error fetching")
                   }
        }
//        Service.shared.getPopularSearches(expecting: ApiResponse<[SearchQuery]>.self) { [weak self]  result in
//            guard let self  = self else {return}
//            switch result {
//                
//            case .success(let response):
//                guard let searchqueries  = response.data else {return}
//                self.popularSearches = searchqueries
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            case .failure(_):
//                print("Error fetching")
//            }
//        }
        
    }
  
    
    
    private func setUpCollectionView(){

        
        collectionView.backgroundColor =  .white
        collectionView.register(GrindProfileCelll.self, forCellWithReuseIdentifier: identifierGriendCell)
        collectionView.register(Header.self, forSupplementaryViewOfKind: GrindProfileController.headerId, withReuseIdentifier: headerGrinderLabelId)
        
        profileActivitiesCollection.register(ProfileFilterCell.self, forCellWithReuseIdentifier: identifierFilterrCell)
//        collectionView.register(Header.self, forSupplementaryViewOfKind: HomeViewController.headerJustLabel, withReuseIdentifier: featureProductHeaderId)
//        collectionView.register(Header.self, forSupplementaryViewOfKind: HomeViewController.headerJustLabel, withReuseIdentifier: recommendedHeaderId)
//        collectionView.register(Header.self, forSupplementaryViewOfKind: HomeViewController.headerJustLabel, withReuseIdentifier: tagPopularSearchHeaderId)
//        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerIdentifierCell)
//        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellNewArrivalsIdentifier)
//        collectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellIdenfier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profileActivitiesCollection.delegate = self
        profileActivitiesCollection.dataSource = self
        
        
//
//        collectionView.refreshControl = UIRefreshControl()
//        collectionView.refreshControl?.addTarget(self, action: #selector(refreshingData), for: .valueChanged)
    }
    //MARK: -COMPOSITIONAL LAYOUT
    static func createLayout() -> UICollectionViewCompositionalLayout{
        
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            
//            if sectionNumber == 0 {
//                
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                
//                let group  =  NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item])
//                
//                let  section  = NSCollectionLayoutSection(group: group)
//                section.contentInsets.top = 10
//                section.orthogonalScrollingBehavior = .continuous
//                section.contentInsets.bottom = 25
//                return section
//                
//                
//            }
//            else if sectionNumber == 1{
                
                let item =  NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 8
                
                let group  = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.40), heightDimension: .fractionalWidth(0.40)), subitems: [item])
                group.contentInsets.trailing =  8
                
                let section  = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior =  .continuousGroupLeadingBoundary
                
                section.contentInsets.leading = 8
                section.boundarySupplementaryItems =  [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: GrindProfileController.headerId, alignment: .topLeading)]
                
                section.contentInsets.bottom = 2
                return section
                
//            }
//            
//            else if sectionNumber == 2{
//               
//        
//
//                
//                let item =  NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                item.contentInsets.trailing = 8
//       
////                item.contentInsets.leading = 8
//                
//                let group  = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitems: [item])
//                group.contentInsets.trailing = 8
//
//                let section  = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior =  .continuousGroupLeadingBoundary
//   
//                section.contentInsets.leading = 8
////                section.contentInsets.trailing = 8
//                section.boundarySupplementaryItems =  [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: HomeViewController.headerJustLabel, alignment: .topLeading)]
//                
//                section.contentInsets.bottom = 25
//                return section
//                
//            }
//            
//            else if sectionNumber == 3{
//                
//                let  item =  NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalWidth(0.50)))
//                item.contentInsets.trailing = 8
//                item.contentInsets.bottom = 16
//                
//                let group =  NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
//                
//                let section  =  NSCollectionLayoutSection(group: group)
//                
//                section.contentInsets.leading =  8
//                section.boundarySupplementaryItems =  [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: HomeViewController.headerJustLabel, alignment: .topLeading)]
//                return section
//            }
//            else if sectionNumber == 4{
//                
//                let item =  NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1)))
//                item.contentInsets.trailing = 16
//                
//                let group  = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), subitems: [item])
////                group.contentInsets.trailing =  16
//                
//                let section  = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior =  .continuous
//                section.boundarySupplementaryItems =  [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: HomeViewController.headerJustLabel, alignment: .topLeading)]
//                section.contentInsets.leading =  8
//                section.contentInsets.bottom = 25
//                
//                return section
//            }
//            
//            
//            
//            
//            else {
//                let item =  NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                item.contentInsets.trailing = 16
//                
//                let group  = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
//                group.contentInsets.trailing =  16
//                
//                let section  = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior =  .paging
//                
//                section.contentInsets.leading = 16
//                section.boundarySupplementaryItems =  [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: "Some id", alignment: .topLeading)]
//                
//                section.contentInsets.bottom = 25
//                return section
//            }
            
        }
        
    }

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension GrindProfileController :  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == profileActivitiesCollection{
            return 1
        }
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == profileActivitiesCollection{
            return categories.count
        }
        return sections[section].count
        
//        }else if section == 1{
//            return min(allproducts.count, 3)
//        }
//        return 10

    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == profileActivitiesCollection{
            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: identifierFilterrCell, for: indexPath) as! ProfileFilterCell
            
            
            cell.tagName.text = categories[indexPath.row]
            return cell
            
           
        }
        
      
            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: identifierGriendCell, for: indexPath) as! GrindProfileCelll
            cell.post = sections[indexPath.section][indexPath.row]
//            cell.mainImage.image =  UIImage(named: "template2")
            return cell
//        }else if   indexPath.section == 1{
//            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: cellNewArrivalsIdentifier, for: indexPath) as! ProductCell
//            //        cell.tagName.text =  featuredIngredients[indexPath.row].strIngredient
//            
//            
//     
//            cell.mainImage.loadImageUrlString(urlString: allproducts[indexPath.row].images[0])
//            return cell
//        }
//        
//        else  if   indexPath.section == 2  {
//            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: cellNewArrivalsIdentifier, for: indexPath) as! ProductCell
//            //        cell.tagName.text =  featuredIngredients[indexPath.row].strIngredient
//            
//            if allproducts.count > 0 {
//                       let lastElement = allproducts[allproducts.count - 1]
//                       cell.mainImage.loadImageUrlString(urlString: lastElement.images[0])
//                   }
//            return cell
//        }else if indexPath.section == 3{
//            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: cellNewArrivalsIdentifier, for: indexPath) as! ProductCell
//            //        cell.tagName.text =  featuredIngredients[indexPath.row].strIngredient
//            
//            let product = allproducts[indexPath.row + 3]
//            cell.mainImage.loadImageUrlString(urlString: product.images[0])
//            return cell
//        }
//        else if indexPath.section == 4{
//            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdenfier, for: indexPath) as! TagCell
//            cell.tagName.text =  popularSearches[indexPath.row].query
//            return cell
//        }
//        else {
//            let cell  =  collectionView.dequeueReusableCell(withReuseIdentifier: cellNewArrivalsIdentifier, for: indexPath) as! ProductCell
//            //        cell.tagName.text =  featuredIngredients[indexPath.row].strIngredient
//            return cell
//        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//      
//        
//        if indexPath.section == 1{
//            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: newArrivalsHeaderId, for: indexPath) as! Header
//            header.label.text  =   "New Arrivals "
//            return header
//        }else if indexPath.section == 2{
//            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: featureProductHeaderId, for: indexPath) as! Header
//            header.label.text  =   "Feature Product"
//            return header
//        }
//        
//        else if indexPath.section == 3{
//            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: recommendedHeaderId, for: indexPath) as! Header
//            header.label.text  =   "Recommended For You"
//            return header
//        }
//        else if indexPath.section == 4{
//            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tagPopularSearchHeaderId, for: indexPath) as! Header
//            header.label.text  =   "Popular Searches"
//            return header
//        }
//            
//            
            
            
        let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerGrinderLabelId, for: indexPath) as! Header
        header.label.text =  sections[indexPath.section].first?.category
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView ==  profileActivitiesCollection{
            let item =  categories[indexPath.row]
         
                let stringWidth = item.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]).width + 20
            return CGSize(width: stringWidth, height: profileActivitiesCollection.bounds.height - 16)
            
            
            
        }
        
        return CGSize(width: 50, height: 50)
       
    }
    

    

    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 1{
//            let controller  = ProductViewController(product:  allproducts[indexPath.row])
//      
//            navigationController?.pushViewController(controller, animated: true)
//            
//            
//            
//        }else if indexPath.section == 2{
//            let controller  = ProductViewController(product:  allproducts[allproducts.count - 1])
//            
//            navigationController?.pushViewController(controller, animated: true)
//            
//            
//        }else if indexPath.section == 3{
//            let controller  = ProductViewController(product:  allproducts[indexPath.row + 3])
//            
//            navigationController?.pushViewController(controller, animated: true)
//            
//            
//        }
//        
//    }
    
    
    
    
}
    
    
    
    

class Header : UICollectionReusableView {

    var label : UILabel  = {
        let label = UILabel()
        label.text =  "Categories"
        label.font =  UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewAllLabel : UILabel =  {
        let label =  UILabel()
        label.text =  "View All"
        label.textColor =  .systemBlue
        label.font =  UIFont.systemFont(ofSize: 18)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.anchor(top: nil, left: leadingAnchor, right: nil, bottom: nil, paddingTop: nil, paddingLeft: 0, paddingRight: nil, paddingBottom: nil, width: nil, height: nil)
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive  = true
    }

}


