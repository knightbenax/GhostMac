//
//  ViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 15/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Cocoa
import Kingfisher

class MainViewController: BaseViewController {

    @IBOutlet weak var weekView: NSCollectionView!
    @IBOutlet weak var inspirationImage: NSImageView!
    @IBOutlet weak var monthLabel: NSTextField!
    
    
    
    let eventItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "EventItemIdentifier")
    
    let today = Date()
    
    let daysOfWeek = ["SUN", "MON", "TUES", "WED", "THUR", "FRI", "SAT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDailyView()
        setCollectionFlowLayout()
    }
    
    func signInGoogle(){
        if (store.userLoggedIn()){
            
        }
    }
    
    
    @IBAction func signInGoogleAction(_ sender: Any) {
        signInGoogle()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        let defaultImage = NSImage(named: NSImage.Name("wait_image"))!
        self.imageFitWell(image: defaultImage)
        self.imageFitWell(image: defaultImage)
    }
    
    fileprivate func setCollectionFlowLayout(){
        let nib = NSNib(nibNamed: "EventItem", bundle: nil)
        weekView.register(nib, forItemWithIdentifier: eventItemIdentifier)
        weekView.delegate = self
        weekView.dataSource = self
        weekView.enclosingScrollView?.borderType = .noBorder
        monthLabel.stringValue = formatDateToBeauty(thisDate: today, type: "year")
        weekView.enclosingScrollView?.backgroundColor = NSColor.clear
        weekView.backgroundColors = [NSColor.clear]
        
        weekView.enclosingScrollView?.scrollerInsets = NSEdgeInsets.init(top: 0, left: 0, bottom: -20, right: 0)
       
           /*let flowLayout = NSCollectionViewFlowLayout()
           flowLayout.itemSize = NSSize(width: sizeOfCell, height: sizeOfCell)
           flowLayout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           flowLayout.minimumLineSpacing = 0
           flowLayout.minimumInteritemSpacing = 0
           colorList.collectionViewLayout = flowLayout*/
    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getDailyView(){
     
        let url = URL(string: "https://source.unsplash.com/collection/9552158")
        /*KingfisherManager.shared.retrieveImage(with: url!, options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired), .keepCurrentImageWhileLoading, .transition(.none)]) { result in
            // Do something with `result`
            //try print(result.get().image)
            do {
                let image = try result.get().image
                self.imageFitWell(image: image)
            } catch (let error){
                print(error)
            }
        }*/
       let downloader = ImageDownloader.default
       downloader.downloadImage(with: url!) { result in
           switch result {
           case .success(let value):
               let image = value.image
               self.imageFitWell(image: image)
           case .failure(let error):
               print(error)
           }
       }
    }

    private func imageFitWell(image: NSImage){
        inspirationImage.layer? = CALayer()
        inspirationImage.layer?.contentsGravity = .resizeAspectFill
        inspirationImage.layer?.contents = image
        inspirationImage.wantsLayer = true
        print(image)
    }
    
    
    func getDayOfWeek(today: Date) -> Int? {
          let myCalendar = Calendar(identifier: .gregorian)
          let weekDay = myCalendar.component(.weekday, from: today)
          return weekDay
      }
    
    func formatDateToBeauty(thisDate: Date, type: String = "day") -> String{
        switch type {
        case "year":
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "MMM yyyy"
             return dateFormatterPrint.string(from: thisDate)
        case "month":
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "d MMM"
            return dateFormatterPrint.string(from: thisDate)
        default:
             let dateFormatterPrint = DateFormatter()
             dateFormatterPrint.dateFormat = "dd"
             return dateFormatterPrint.string(from: thisDate)
        }
    }

}

extension MainViewController: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        14
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let i = indexPath.item
        let cell = collectionView.makeItem(withIdentifier: eventItemIdentifier, for: indexPath) as? EventItem
        
        let dayDiff = i - 7
        let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
        cell?.todayDotView.isHidden = true
        
        if (i == 7){
            //this is today
            cell?.todayDotView.isHidden = false
        }
        
        let index = getDayOfWeek(today: nextDate!)! - 1
        cell?.dateText.stringValue = formatDateToBeauty(thisDate: nextDate!)
        cell?.dayText.stringValue = daysOfWeek[index]
        return cell!
    }
    
    
    
    
}

