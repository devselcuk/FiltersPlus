//
//  FiltersVC.swift
//  FiltersPlus
//
//  Created by MacMini on 9.11.2021.
//

import UIKit

@available(iOS 13.0, *)
class FiltersVC: UIViewController {
    
    
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var filters = [FilterFactory]()
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        filters = FilterHouse(image: UIImage(named: "rome")!).filters
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! FilterResultVC
            
            vc.factory = filters[index]
        }
    }
}


@available(iOS 13.0, *)
extension FiltersVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = filters[indexPath.row].filterName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        
        performSegue(withIdentifier: "segue", sender: Any.self)
    }
    
    
}
