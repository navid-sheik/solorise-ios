import UIKit


class Dropdown: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var transparentView = UIView()
    private var tableView = UITableView()
    private var dataSource = [String]()
    private var selectedButton = UIButton()
    
    // Add this property to handle the selection
    var didSelectItem: ((Int) -> Void)?

    
    override init() {
        super.init()
        setupTransparentView()
        setupTableView()
    }
    
    private func setupTransparentView() {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func showDropdown(on button: UIButton, with data: [String]) {
        guard let window = UIApplication.shared.keyWindow else { return }
        selectedButton = button
        dataSource = data
        
        transparentView.frame = window.frame
        window.addSubview(transparentView)
        
        tableView.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y + button.frame.height, width: button.frame.width, height: 0)
        window.addSubview(tableView)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y + button.frame.height + 5, width: button.frame.width, height: CGFloat(self.dataSource.count * 50))
        })
        tableView.reloadData()
    }
    
    // New method to update the data source without showing the dropdown
      func updateDataSource(with data: [String]) {
          dataSource = data
          tableView.reloadData()  // Reload the table view with the new data
      }
      
    
    @objc private func removeTransparentView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: self.selectedButton.frame.origin.x, y: self.selectedButton.frame.origin.y + self.selectedButton.frame.height, width: self.selectedButton.frame.width, height: 0)
        }) { _ in
            self.transparentView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        didSelectItem?(indexPath.row)
        removeTransparentView()
    }
}
