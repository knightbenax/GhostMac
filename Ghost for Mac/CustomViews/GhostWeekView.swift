//
//  GhostWeekView.swift
//  Ghost
//
//  Created by Bezaleel Ashefor on 04/06/2019.
//  Copyright © 2019 Ephod. All rights reserved.
//

import Foundation
import AppKit

protocol GhostWeekDelegate {
    func clickedDayView(day: Int)
}

@IBDesignable
class GhostWeekView: NSView {
    
    var delegate : GhostWeekDelegate?
    
    let daysOfWeek = ["SUN", "MON", "TUES", "WED", "THUR", "FRI", "SAT"]
    
    //the view that indicates the currently selected dateview
    let selectorView = NSView(frame: .zero)
    
    //this is the dot that shows that day is today
    let todayDotView = NSView(frame: .zero)
    
    var todaySelected = true
    var selectedDayView : NSView!
    var todayView : NSView!
    var selectedViewXConstraint : NSLayoutConstraint?
    var selectedViewYConstraint : NSLayoutConstraint?
    var selectedViewWidthConstraint : NSLayoutConstraint?
    var selectedViewHeightConstraint : NSLayoutConstraint?
   
    /*override func layoutSubviews() {
        super.layoutSubviews()
    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("days")
        createDaysOfWeek()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("days")
        createDaysOfWeek()
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
             dateFormatterPrint.dateFormat = "yyyy"
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
    
    func createDaysOfWeek(){
        var previousView : NSView!
        let today = Date()
        
        selectorView.wantsLayer = true
        selectorView.layer?.backgroundColor = NSColor(named: "textColor")?.cgColor
        selectorView.layer?.cornerRadius = 3
        self.addSubview(selectorView)
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<14 {
            let dayView = NSView(frame: .zero)
            //dayView.backgroundColor = NSColor.blue
            
            let dateView = NSTextField()
            dateView.isBordered = false
            dateView.isEditable = false
            dateView.wantsLayer = true
            dateView.layer?.backgroundColor = NSColor.clear.cgColor
            let dayTextView = NSTextField()
            dayTextView.isEditable = false
            dayTextView.isBordered = false
            dayView.wantsLayer = true
            dayView.layer?.backgroundColor = NSColor.clear.cgColor
            let infoHolder = NSStackView()
            //infoHolder.alignment = .center
            //infoHolder.axis = .horizontal
            infoHolder.distribution = .fillEqually
            
            let dayDiff = i - 7
            let nextDate = Calendar.current.date(byAdding: .day, value: dayDiff, to: today)
            
            let index = getDayOfWeek(today: nextDate!)! - 1
            dateView.stringValue = daysOfWeek[index]
            
            dateView.font = NSFont.init(name: "Overpass-Bold", size: 14.0)
            dayTextView.font = NSFont.init(name: "Overpass-Black", size: 24.0)
            
            let thisDateInString = onlyDay(parsedDate: nextDate!)
            //infoHolder.tag = Int(thisDateInString)!
            
            dayTextView.stringValue = formatDateToBeauty(thisDate: nextDate!)
            
            if (i < 7){
                dayTextView.textColor = NSColor(named: "prioritySelected")
                dateView.textColor = NSColor(named: "prioritySelected")
            } else {
                dayTextView.textColor = NSColor(named: "textColor")
                dateView.textColor = NSColor(named: "textColor")
            }
            
            
            let yearView = NSTextField()
            yearView.stringValue = formatDateToBeauty(thisDate: nextDate!, type: "year")
            yearView.textColor = NSColor(named: "textColor")
            yearView.font = NSFont.init(name: "Overpass-Regular", size: 12.0)
            
          
            todayDotView.wantsLayer = true
            todayDotView.layer?.backgroundColor = NSColor(red:0.96, green:0.65, blue:0.14, alpha:1.0).cgColor
            todayDotView.layer?.cornerRadius = 3
            
            //Add the gesture recognizer
            //let gesture = UITapGestureRecognizer(target: self, action: #selector(clickedDayView(_:)))
            
            dayView.addSubview(dateView)
            dayView.addSubview(dayTextView)
            //dayView.tag = i
            //dayView.addGestureRecognizer(gesture)
            dayView.addSubview(infoHolder)
            self.addSubview(dayView)
            
            
            
            infoHolder.translatesAutoresizingMaskIntoConstraints = false
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dateView.translatesAutoresizingMaskIntoConstraints = false
            dayTextView.translatesAutoresizingMaskIntoConstraints = false
            yearView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dateView.topAnchor.constraint(equalTo: dayView.topAnchor),
                dateView.centerXAnchor.constraint(equalTo: dayView.centerXAnchor)
                //dateView.leftAnchor.constraint(equalTo: dayView.leftAnchor),
                ])
            
            NSLayoutConstraint.activate([
                dayTextView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -1),
                dayTextView.leftAnchor.constraint(equalTo: dayView.leftAnchor),
                dayTextView.bottomAnchor.constraint(equalTo: dayView.bottomAnchor),
                dayTextView.rightAnchor.constraint(equalTo: dayView.rightAnchor),
                ])
            
            NSLayoutConstraint.activate([
                infoHolder.centerXAnchor.constraint(equalTo: dayView.centerXAnchor),
                infoHolder.leftAnchor.constraint(equalTo: dayView.leftAnchor),
                infoHolder.heightAnchor.constraint(equalToConstant: 8),
                infoHolder.rightAnchor.constraint(equalTo: dayView.rightAnchor),
                infoHolder.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 5)
            ])
            
            if (i == 7){
                dayTextView.textColor = NSColor(named: "bgColor")
                dateView.textColor = NSColor(named: "bgColor")
                //this is todayview
                todayView = dayView
                selectedDayView = dayView
                let todayDotViewHolder = NSView()
                todayDotViewHolder.addSubview(todayDotView)
                todayDotView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    todayDotView.widthAnchor.constraint(equalToConstant: 6),
                    todayDotView.heightAnchor.constraint(equalToConstant: 6),
                    todayDotView.centerXAnchor.constraint(equalTo: todayDotViewHolder.centerXAnchor),
                    todayDotView.centerYAnchor.constraint(equalTo: todayDotViewHolder.centerYAnchor)
                ])
                
                //infoHolder.tag = i
                infoHolder.addArrangedSubview(todayDotViewHolder)
                
                selectedViewWidthConstraint = selectorView.widthAnchor.constraint(equalTo: dayView.widthAnchor, constant: 18)
                selectedViewHeightConstraint = selectorView.heightAnchor.constraint(equalTo: dayView.heightAnchor, constant: 20)
                selectedViewXConstraint = selectorView.centerXAnchor.constraint(equalTo: dayView.centerXAnchor)
                selectedViewYConstraint = selectorView.centerYAnchor.constraint(equalTo: dayView.centerYAnchor, constant: 2)

                NSLayoutConstraint.activate([
                    selectedViewHeightConstraint!,
                    selectedViewHeightConstraint!,
                    selectedViewXConstraint!,
                    selectedViewYConstraint!,
                    selectorView.topAnchor.constraint(equalTo: self.topAnchor),
                    selectorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                ])
                
                selectedViewWidthConstraint?.isActive = true
                selectedViewHeightConstraint?.isActive = true
                selectedViewXConstraint?.isActive = true
                selectedViewYConstraint?.isActive = true
            }
            
            
            if let previousView = previousView {
                NSLayoutConstraint.activate([
                    dayView.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
                    dayView.leftAnchor.constraint(equalTo: previousView.rightAnchor, constant: 26),
                    dayView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
                    ])
            } else {
                NSLayoutConstraint.activate([
                    dayView.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
                    dayView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    dayView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
                    ])
            }
            
            
            if (i == 13){
                //this is the last view
                NSLayoutConstraint.activate([
                    dayView.rightAnchor.constraint(equalTo: self.rightAnchor)
                    ])
            }
            //print(dayView.bounds.width)
            previousView = dayView
            
        }
        
    }
    
    /*@objc func clickedDayView(_ sender: UITapGestureRecognizer){
        let day = sender.view?.tag
        let dayView = sender.view!
        
        //turn the today textback to the non selected color
        let todayLabels = selectedDayView.subviews.filter({$0 is UILabel})
        todayLabels.forEach({
            let label = $0 as! UILabel
            label.textColor = NSColor(named: "textColor")
        })
        
        //the selectedview to the selected color
        dayView.subviews.filter({$0 is UILabel}).forEach({
            let label = $0 as! UILabel
            label.textColor = NSColor(named: "bgColor")
        })
        
        selectedViewWidthConstraint?.isActive = false
        selectedViewHeightConstraint?.isActive = false
        selectedViewXConstraint?.isActive = false
        selectedViewYConstraint?.isActive = false
        
        selectedViewWidthConstraint = selectorView.widthAnchor.constraint(equalTo: dayView.widthAnchor, constant: 18)
        selectedViewHeightConstraint = selectorView.heightAnchor.constraint(equalTo: dayView.heightAnchor, constant: 20)
        selectedViewXConstraint = selectorView.centerXAnchor.constraint(equalTo: dayView.centerXAnchor)
        selectedViewYConstraint = selectorView.centerYAnchor.constraint(equalTo: dayView.centerYAnchor, constant: 2)
        
     
        selectedDayView = dayView
        
        selectedViewWidthConstraint?.isActive = true
        selectedViewHeightConstraint?.isActive = true
        selectedViewXConstraint?.isActive = true
        selectedViewYConstraint?.isActive = true
        
        /*NSView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.setNeedsDisplay()
            }, completion: nil)*/
        
        let dayDiff = day! - 7
        //make up for the difference of past days
        delegate?.clickedDayView(day: dayDiff)
        //print(day)
    }*/
    
    func setImportantPoints(points: [String]){
        var stackViews = [NSView]()
        self.subviews.forEach({
            let dayView = $0
            stackViews.append(contentsOf: dayView.subviews.filter({$0 is NSStackView}))
        })
        stackViews.forEach({
            let realStackView = $0 as! NSStackView
            
            if (realStackView.tag != 7){
                //meaning that this isn't a today stackview
                realStackView.removeAllArrangedSubviews()
            }
            
            if ((points.first(where: {onlyDayPoints(parsedDate: $0) == realStackView.tag})) != nil){
                let importantDotViewHolder = NSView()
                let importantDotView = NSView(frame: .zero)
                
                importantDotView.wantsLayer = true
                importantDotView.layer?.backgroundColor = NSColor(red:0.05, green:0.50, blue:0.69, alpha:1.0).cgColor
                importantDotView.layer?.cornerRadius = 3
                
                importantDotViewHolder.addSubview(importantDotView)
                importantDotView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    importantDotView.widthAnchor.constraint(equalToConstant: 6),
                    importantDotView.heightAnchor.constraint(equalToConstant: 6),
                    importantDotView.centerXAnchor.constraint(equalTo: importantDotViewHolder.centerXAnchor),
                    importantDotView.centerYAnchor.constraint(equalTo: importantDotViewHolder.centerYAnchor)
                ])
                                  
                realStackView.addArrangedSubview(importantDotViewHolder)
            }
        })
        
        /*NSView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
        self.layoutIfNeeded()
        }, completion: nil)*/
    }
    
    
    func setUrgentPoints(points: [String]){
         var stackViews = [NSView]()
         self.subviews.forEach({
             let dayView = $0
             stackViews.append(contentsOf: dayView.subviews.filter({$0 is NSStackView}))
         })
         stackViews.forEach({
             let realStackView = $0 as! NSStackView
             
            if (realStackView.tag != 7){
                //meaning that this isn't a today stackview
                realStackView.removeAllArrangedSubviews()
            }
            
             if ((points.first(where: {onlyDayPoints(parsedDate: $0) == realStackView.tag})) != nil){
                 let urgentDotViewHolder = NSView()
                 let urgentDotView = NSView(frame: .zero)
                 
                urgentDotView.wantsLayer = true
                urgentDotView.layer?.backgroundColor = NSColor(red:0.62, green:0.18, blue:0.28, alpha:1.0).cgColor
                 urgentDotView.layer?.cornerRadius = 3
                 
                 urgentDotViewHolder.addSubview(urgentDotView)
                 urgentDotView.translatesAutoresizingMaskIntoConstraints = false

                 NSLayoutConstraint.activate([
                     urgentDotView.widthAnchor.constraint(equalToConstant: 6),
                     urgentDotView.heightAnchor.constraint(equalToConstant: 6),
                     urgentDotView.centerXAnchor.constraint(equalTo: urgentDotViewHolder.centerXAnchor),
                     urgentDotView.centerYAnchor.constraint(equalTo: urgentDotViewHolder.centerYAnchor)
                 ])
                                   
                 realStackView.addArrangedSubview(urgentDotViewHolder)
             }
         })
         
         /*NSView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
         self.layoutIfNeeded()
         }, completion: nil)*/
         
         
     }
    
    
    func onlyDay(parsedDate: Date) -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.timeZone = TimeZone.current
           dateFormatter.locale = Locale(identifier: "en-US")
           dateFormatter.dateFormat = "dd"
           
           return dateFormatter.string(from: parsedDate)
    }
    
    func onlyDayPoints(parsedDate: String) -> Int{
           let dateFormatter = DateFormatter()
           dateFormatter.timeZone = TimeZone.current
           dateFormatter.locale = Locale(identifier: "en-US")
           dateFormatter.dateFormat = "yyyy-MM-dd"
           
           
           let finaldateFormatter = DateFormatter()
           finaldateFormatter.timeZone = TimeZone.current
           finaldateFormatter.locale = Locale(identifier: "en-US")
           finaldateFormatter.dateFormat = "dd"
           
           let tempDate = dateFormatter.date(from: parsedDate)
        return Int(finaldateFormatter.string(from: tempDate!))!
       }
    
    override class var requiresConstraintBasedLayout: Bool {
          return true
        }
    
}


extension NSStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [NSView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
