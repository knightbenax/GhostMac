//
//  ViewController.swift
//  Ghost for Mac
//
//  Created by Bezaleel Ashefor on 15/02/2020.
//  Copyright © 2020 Ephod. All rights reserved.
//

import Cocoa
import Kingfisher
import GAppAuth

class MainViewController: BaseViewController {

    @IBOutlet weak var weekView: NSCollectionView!
    @IBOutlet weak var inspirationImage: NSImageView!
    @IBOutlet weak var monthLabel: NSTextField!
    @IBOutlet weak var logInView: NSView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    let eventItemIdentifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "EventItemIdentifier")
    
    let today = Date()
    var fetchedDay = 0
    var wakeup = false
    let daysOfWeek = ["SUN", "MON", "TUES", "WED", "THUR", "FRI", "SAT"]
    var urgentCalendar = ""
    var importantCalendar = "primary"
    var selectedCalendar = ""
    
    var contacts : Array<Contact>!
    
    @IBOutlet weak var ghost_empty_image: NSImageView!
    @IBOutlet weak var emptyView: NSView!
    @IBOutlet weak var emptyTaskTextView: NSTextField!
    //We don't want to load the contacts everytime. It takes effort and let's reduce CO2 waste.
    var needContacts : Bool = false
    
    
    private(set) lazy var events : [Event] = {
          return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCalendar = importantCalendar
        GAppAuth.shared.retrieveExistingAuthorizationState()
        checkRegistration()
        if (store.userLoggedIn()){
            logInView.isHidden = true
            getCalendarEvents()
        } else {
            logInView.isHidden = false
        }
        getDailyView()
        setCollectionFlowLayout()
    }
    
    func getCalendarEvents(){
       startProgressLoading()
        let today = getTimeAndDate(day: fetchedDay)
        let yesterday = getTimeAndDate(diff: -1, day: fetchedDay)
        googleService.getGoogleCalendarEvents(calendar_id: selectedCalendar, startDate: yesterday, endDate: today, completion: { (result: Result<Any, Error>) in
            
            switch (result){
            case .success(let data):
                 let dataItems = data as! NSDictionary
                 let items = dataItems.object(forKey: "items") as! NSArray
                 self.parseEvents(items: items)
            case .failure(let error):
                print(error)
            }
            
          
        })
    }
    
    private func startProgressLoading(){
        progressIndicator.isHidden = false
        progressIndicator.startAnimation(self)
    }
    
    private func endProgressLoading(){
        progressIndicator.stopAnimation(self)
        progressIndicator.isHidden = true
    }
    
    func parseEvents(items: NSArray){
        items.forEach {(item) in
            let data = item as! NSDictionary
            
            var type = ""
            var startDateValue = ""
            var endDateValue = ""
            var colorId = ""
            var markedAsDone = false
            var descriptionTemp = ""
            var location : String? = ""
            var hasTime = false
            
            if (data.object(forKey: "conferenceData") as? NSDictionary) != nil {
                type = "#meeting"
            } else {
                type = "#work"
            }
            
            let startDate = data.object(forKey: "start") as! NSDictionary
            let endDate = data.object(forKey: "end") as! NSDictionary
            
            if let dateTime = startDate.object(forKey: "dateTime") as? String{
                startDateValue = dateTime
            } else {
                startDateValue = startDate.object(forKey: "date") as! String
            }
            
            if let dateTime = endDate.object(forKey: "dateTime") as? String{
                endDateValue = dateTime
                hasTime = true
            } else {
                endDateValue = endDate.object(forKey: "date") as! String
            }
        
            if let tempColorId = data.object(forKey: "colorId") as? String{
                colorId = tempColorId
            } else {
                colorId = "11"
            }
            
            if let locationTemp = data.object(forKey: "location") as? String{
                location = locationTemp
            }
            
            if let description = data.object(forKey: "description") as? String{
                if (description == "Ghost marked as done" || description.contains("Ghost marked as done")){
                    markedAsDone = true
                }
                
                if (description.contains("Join Zoom Meeting") || description.contains("join zoom meeting") || description.contains("Ghost Meeting")){
                    type = "#meeting"
                } else if (description.contains("Ghost Gym")){
                    type = "#gym"
                } else if (description.contains("Ghost Task")){
                    type = "#task"
                } else if (description.contains("Ghost Work")){
                    type = "#work"
                }
                
                descriptionTemp = description
            }
            
            var savedAttendees : Array<String>!
            
            if let attendees = data.object(forKey: "attendees") as? NSArray {
                savedAttendees = Array<String>()
                //there are attendees, load contacts
                needContacts = true
                
                //save all attendees
                for attendee in attendees {
                    let attendeeData = attendee as! NSDictionary
                    savedAttendees.append(attendeeData.object(forKey: "email") as! String)
                    
                }
                //save the creator. this is for cases where the event wasn't created by me or
                //we have more than one attendee
                if let creator = data.object(forKey: "creator") as? NSDictionary {
                    let creatorEmail = creator.object(forKey: "email" ) as! String
                    if ((savedAttendees) != nil){
                        savedAttendees.append(creatorEmail)
                    }
                }
                
                if let myIndex = savedAttendees.firstIndex(of: "knightbenax@gmail.com"){
                    savedAttendees.remove(at: myIndex)
                }
                
                savedAttendees = savedAttendees.removingDuplicates()
            }
            
            
            
            //print(savedAttendees)
            
            events.append(Event(id: data.object(forKey: "id") as! String,
                                summary: data.object(forKey: "summary") as! String,
                                startDate: startDateValue,
                                endDate: endDateValue,
                                colorId: colorId,
                                type: type,
                                hasTime: hasTime, attendees: savedAttendees,
                                markedAsDone: markedAsDone, description: descriptionTemp, location: location))
        }
        
        
        
        if (needContacts) {
            //fetch the contacts, we would reload the table when done
            fetchContacts()
        } else {
            scheduleList.reloadData()
            endProgressLoading()
        }
        
        if (wakeup){
            endProgressLoading()
            wakeup = false
        }
        
        if (events.count == 0){
            emptyView.isHidden = false
            setEmptyTaskTextViewLabel(calendar: selectedCalendar)
        } else {
            emptyView.isHidden = true
        }
        
        //events.count == 0 ? emptyView.isHidden = false : emptyView.isHidden = true
    }
    
    
    func setEmptyTaskTextViewLabel(calendar: String){
        switch calendar {
        case importantCalendar:
            ghost_empty_image.isHidden = false
            emptyTaskTextView.stringValue = "You have no important long-term things for today. It's fine but don't make this a regular occurence"
        case urgentCalendar:
            ghost_empty_image.isHidden = false
            emptyTaskTextView.stringValue = "You have no events, tasks or even fires to put out today! Time to read or catch up on that series"
        case "nourgentcalendar":
            ghost_empty_image.isHidden = true
            emptyTaskTextView.stringValue = "You haven't selected a calender to use for urgent tasks. Select one from settings"
        default:
            break
        }
    }
    
    
    func checkRegistration(){
        if GAppAuth.shared.isAuthorized() {
            let authorization = GAppAuth.shared.getCurrentAuthorization()
            let tokenResponse = authorization?.authState.lastTokenResponse
            let accessToken : String = (tokenResponse?.accessToken)!
            let refreshToken : String = (tokenResponse?.refreshToken)!
            let accessExpiryDate : Date = (tokenResponse?.accessTokenExpirationDate)!
            let values : NSMutableDictionary = ["access_token": accessToken,
                                                "refresh_token": refreshToken,
                                                "expires_in": accessExpiryDate]
            store.saveUser(result: values)
            print("saved user")
        }
    }
    
    override var representedObject: Any? {
        didSet {
            checkRegistration()
        }
    }
    
    
    
    func signInGoogle(){
        do {
            try GAppAuth.shared.authorize { auth in
                if auth {
                    self.checkRegistration()
                }
            }
        } catch let error {
            print(error.localizedDescription)
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

