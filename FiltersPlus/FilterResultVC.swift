//
//  FilterResultVC.swift
//  FiltersPlus
//
//  Created by MacMini on 9.11.2021.
//

import UIKit

class FilterResultVC: UIViewController {
    
    
    @IBOutlet weak var inputImageView: UIImageView!
    
    @IBOutlet weak var outPutImageView: UIImageView!
   
    
    var factory : FilterFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let factory = factory else {
            return
        }

        
        inputImageView.image = factory.input
        
        outPutImageView.image = factory.output()
        
        navigationItem.title = factory.filterName
        // Do any additional setup after loading the view.
    }
    


}
