//
//  DropDownViewController.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/6/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class DropDownViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [String] = ["Sample 1", "Sample 2", "Sample 3"]
    var cellPressed: ((_ row: Int) -> Void)?
    
    var selectedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropDownCellTableViewCell.self)
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

extension DropDownViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DropDownCellTableViewCell = tableView.dequeueReusableCell()
        cell.itemLabel.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        dismiss(animated: false, completion: nil)
        cellPressed?(indexPath.row)
        
        return indexPath
    }
}
