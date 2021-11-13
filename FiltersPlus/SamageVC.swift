//
//  SamageVC.swift
//  FiltersPlus
//
//  Created by MacMini on 9.11.2021.
//

import UIKit

@available(iOS 13.0, *)
class SamageVC: UIViewController {
    
    var collectionView : UICollectionView!
    
    
    var dataSource : UICollectionViewDiffableDataSource<Int,Data>!
    
    var datas : [Data] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let datas = UserDefaults.standard.array(forKey: "samage") as? [Data] {
            self.datas = datas
            print(self.datas)
        }
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configuredLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SamageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "samage")
        
        dataSource = UICollectionViewDiffableDataSource<Int,Data>(collectionView: collectionView, cellProvider: { collectionView, indexPath, data in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "samage", for: indexPath) as! SamageCollectionViewCell
            
            cell.cimageView.image = UIImage(data: data)
            print(UIImage(data: data))
            return cell
        })
        
        
        
        var sn = NSDiffableDataSourceSnapshot<Int,Data>()
        sn.appendSections([0])
        sn.appendItems(self.datas, toSection: 0)
        dataSource.apply(sn)
        // Do any additional setup after loading the view.
    }
    
     
    //MARK: configure collectionview layout
    
    func configuredLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }
}




@available(iOS 13.0, *)
extension SamageVC : UICollectionViewDelegate {
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIActivityViewController(activityItems: [UIImage(data: self.datas[indexPath.row])], applicationActivities: nil)
        
        present(vc, animated: true, completion: nil)
    }
}


