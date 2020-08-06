//
//  Extension.swift
//  Nomad-Party 

import Foundation
import SDWebImage

// Adds a gradient effect to a UIImage
extension UIImageView {
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0.5, 1.0]
        
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

extension String {
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
    }
}

// Handles time of an interaction
func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){ return "1 year ago"
        } else { return "Last year" }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){ return "1 month ago"
        } else { return "Last month" }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){ return "1 week ago"
        } else { return "Last week" }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){ return "1 day ago"
        } else { return "Yesterday" }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){ return "1 hour ago"
        } else { return "An hour ago" }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){ return "1 minute ago"
        } else { return "A minute ago" }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else { return "Just now" }
}

// Loads image from url
extension UIImageView {
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else { return }
        guard let url = URL(string: string) else { return }
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
}

// Used to show activity status with respect to time online 
extension Double {
    func convertDate() -> String {
        var string = ""
        let date: Date = Date(timeIntervalSince1970: self)
        let calendrier = Calendar.current
        let formatter = DateFormatter()
        if calendrier.isDateInToday(date) {
            string = ""
            formatter.timeStyle = .short
        } else if calendrier.isDateInYesterday(date) {
            string = "Yesterday: "
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        let dateString = formatter.string(from: date)
        return string + dateString
    }
}
