//
//  ViewController.swift
//  FiltersPlus
//
//  Created by MacMini on 8.11.2021.
//

import UIKit
import CoreImage.CIFilterBuiltins
import CoreImage
import PhotosUI
let context =  CIContext()
struct LightItem : Hashable {
    let name : String
    let image : UIImage?
}

@available(iOS 13.0, *)
var dataSource : UICollectionViewDiffableDataSource<Int,LightItem>!

class ViewController: UIViewController, UICollectionViewDelegate, PHPickerViewControllerDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.outPutImageView.image = filters[indexPath.row].output()
        
        print(indexPath.row)
        
    
    }
    

    @available(iOS 14, *)
    @IBAction func adddPhoto(_ sender: Any) {
        activityIndicator.startAnimating()
        var config = PHPickerConfiguration()
        config.filter  = .images
        
        config.selectionLimit = 1
        
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    
    @available(iOS 14, *)
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let result = results.first else {
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            return }
        
       let provider =  result.itemProvider
        
        provider.loadObject(ofClass: UIImage.self) { reading, error in
            DispatchQueue.main.async {
                print(error)
                if let error = error {
                    self.activityIndicator.stopAnimating()
                }
                print(reading)
                if let image = reading as? UIImage {
                    self.outPutImageView.image = image
                    self.filters = FilterHouse(image: image).filters
                    self.applySnap()
                }
            }
        }
    }
    

    
    @IBOutlet weak var outPutImageView: UIImageView!
    
    
    var collectionView : UICollectionView!
    
    let image = UIImage(named: "rome")!
    var filters : [FilterFactory] = [] {
        willSet {
            items = newValue.map({ LightItem(name: $0.filterName, image: $0.output())})
            
        }
    }
    
  
    
    
    var items : [LightItem] = [] {
        didSet {
            self.activityIndicator.stopAnimating()
        }
    }
   
    
    
    let activityIndicator = UIActivityIndicatorView()
    
    
    var saveImageData : [Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let saveImageData = UserDefaults.standard.array(forKey: "samage") as? [Data] {
            self.saveImageData = saveImageData
            print(self.saveImageData)
        }
        
        activityIndicator.frame = view.bounds
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.backgroundColor = .systemBackground
            activityIndicator.color = .label
            view.addSubview(activityIndicator)
            
            self.outPutImageView.clipsToBounds = true
            
            
           
            
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
            view.addSubview(collectionView)
            
            collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        } else {
            // Fallback on earlier versions
        }
      
    
 
        

        if #available(iOS 13.0, *) {
            setDataSource()
        } else {
            // Fallback on earlier versions
        }
      
  
        
        
    }

    
    @available(iOS 13.0, *)
    func setDataSource() {
        
        
        dataSource = UICollectionViewDiffableDataSource<Int,LightItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, filter in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            
            cell.filterImageView.image = filter.image
    
            cell.filterNamelabel.text = filter.name
            return cell
        })
        
        applySnap()
        
            }
    
    
    @available(iOS 13.0, *)
    
    private func applySnap() {
        var snapShot = NSDiffableDataSourceSnapshot<Int,LightItem>()
        snapShot.appendSections([0])
        snapShot.appendItems(self.items, toSection: 0)
        
        dataSource.apply(snapShot)

    }
    
    
    
    
    @available(iOS 13.0, *)
    
    
    func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section )
    }
    
    
    @IBAction func sharePhoto(_ sender: Any) {
        
        let vc = UIActivityViewController(activityItems: [self.outPutImageView.image], applicationActivities: nil)
        
        present(vc, animated: true, completion: nil)
    }
    

    @IBAction func savePhoto(_ sender: Any) {
        
        
        if   let data = self.outPutImageView.image?.pngData() {
            self.saveImageData.append(data)
            
            UserDefaults.standard.setValue(self.saveImageData, forKey: "samage")
            
            let alert = UIAlertController(title: "Image Saved", message: "Successfully saved within the app", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
 

}







protocol FilterProtocol {
 
    var filter : CIFilter { get set }
    var input : UIImage { get set }
  
    
    
    var values : [String: Double] { get set}
    
    func output() -> UIImage?
    
    var filterName : String { get set}
    
}


extension FilterProtocol {
    
    func output() -> UIImage? {
        
        guard let image = CIImage(image : input) else { return nil }
        
        filter.setValue(image, forKey: kCIInputImageKey)
        
        for (key, value) in values {
            filter.setValue(value, forKey: key)
        }
        
        guard let ci  = filter.outputImage else { return nil}
      
        return UIImage( cgImage: context.createCGImage(ci, from: ci.extent)!)
        
    }
}



struct FilterFactory : FilterProtocol, Hashable {
    var filterName: String
    

    
    static func == (lhs: FilterFactory, rhs: FilterFactory) -> Bool {
        lhs.id == rhs.id
        
    }
    
    
    let id = UUID()
    
    var filter: CIFilter
    
    var input: UIImage
    
    var values: [String : Double]
    
    
    
    
}





struct FilterHouse {
   
    
    var image : UIImage
    
    
    
    @available(iOS 13.0, *)
    var filters : [FilterFactory] {
        [ FilterFactory(filterName: "Chrome", filter: CIFilter.photoEffectChrome(), input: image, values: [ : ]), FilterFactory(filterName: "Fade", filter: CIFilter.photoEffectFade(), input: image, values: [ : ]), FilterFactory(filterName: "Instant", filter: CIFilter.photoEffectInstant(), input: image, values: [ : ]), FilterFactory(filterName: "Mono", filter: CIFilter.photoEffectMono(), input: image, values: [ : ]), FilterFactory(filterName: "Noir", filter: CIFilter.photoEffectNoir(), input: image, values: [ : ]),FilterFactory(filterName: "Process", filter: CIFilter.photoEffectProcess(), input: image, values: [ : ]),FilterFactory(filterName: "Tonal", filter: CIFilter.photoEffectTonal(), input: image, values: [ : ]),FilterFactory(filterName: "Transfer", filter: CIFilter.photoEffectTransfer(), input: image, values: [ : ]), FilterFactory(filterName: "Sepia", filter: CIFilter.sepiaTone(), input: image, values: ["inputIntensity" : 1.0]), FilterFactory(filterName: "Vignette", filter: CIFilter.vignette(), input: image, values: [ "inputRadius": 1.0 , "inputIntensity" : 1.0]), FilterFactory(filterName: "Halftone", filter: CIFilter.cmykHalftone(), input: image, values: [ : ]),FilterFactory(filterName: "Box Blur", filter: CIFilter.boxBlur(), input: image, values: ["inputRadius" : 11]), FilterFactory(filterName: "Disc Blur", filter: CIFilter.discBlur(), input: image, values: ["inputRadius" : 10]), FilterFactory(filterName: "Gaussian Blur", filter: CIFilter.gaussianBlur(), input: image, values: ["inputRadius" : 10]), FilterFactory(filterName: "Median Filter", filter: CIFilter.median(), input: image, values: [:]), FilterFactory(filterName: "Motion Blur", filter: CIFilter.motionBlur(), input: image, values: ["inputRadius" : 20, "inputAngle" : 0.5]), FilterFactory(filterName: "Zoom Blur", filter: CIFilter.zoomBlur(), input: image, values: ["inputAmount" : 20]), FilterFactory(filterName: "Dot Screen", filter: CIFilter.dotScreen(), input: image, values: [ : ]), FilterFactory(filterName: "Hatched Screen", filter: CIFilter.hatchedScreen(), input: image, values: [ : ]), FilterFactory(filterName: "Line Screen", filter: CIFilter.lineScreen(), input: image, values: [ : ]),FilterFactory(filterName: "Mono", filter: CIFilter.photoEffectMono(), input: image, values: [ : ]), FilterFactory(filterName: "Bloom", filter: CIFilter.bloom(), input: image, values: [ : ]), FilterFactory(filterName: "Comic", filter: CIFilter.comicEffect(), input: image, values: [ : ]), FilterFactory(filterName: "Mono", filter: CIFilter.photoEffectMono(), input: image, values: [ : ]),FilterFactory(filterName: "Crytalize", filter: CIFilter.crystallize(), input: image, values: [ : ]), FilterFactory(filterName: "Depth of Field", filter: CIFilter.depthOfField(), input: image, values: [ : ]),FilterFactory(filterName: "Edges", filter: CIFilter.edges(), input: image, values: [ : ]) , FilterFactory(filterName: "Edge Word", filter: CIFilter.edgeWork(), input: image, values: [ : ]), FilterFactory(filterName: "Gloom", filter: CIFilter.gloom(), input: image, values: [ : ]),FilterFactory(filterName: "Height Field", filter: CIFilter.heightFieldFromMask(), input: image, values: [ : ]), FilterFactory(filterName: "Highlight Shadow", filter: CIFilter.photoEffectMono(), input: image, values: [ : ]), FilterFactory(filterName: "Hexagonal Pixelate", filter: CIFilter.hexagonalPixellate(), input: image, values: [ : ]), FilterFactory(filterName: "Highlight Shadow", filter: CIFilter.highlightShadowAdjust(), input: image, values: [ : ]), FilterFactory(filterName: "Line Overlay", filter: CIFilter.lineOverlay(), input: image, values: [ : ]), FilterFactory(filterName: "Pixelate", filter: CIFilter.pixellate(), input: image, values: [ : ]), FilterFactory(filterName: "Pointillize", filter: CIFilter.pointillize(), input: image, values: [ : ])]
    }
    
   
}


extension UIView {
    
    @IBInspectable
    var r : CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
