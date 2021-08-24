//
//  Extension.swift
//  Tour Guide Demo
//
//  Created by developer on 19/02/19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Photos

extension UIView{
    func addshadow(top: Bool,
                       left: Bool,
                       bottom: Bool,
                       right: Bool,
                       shadowRadius: CGFloat = 5.0) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.5
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func addBorderShadow(radius: CGFloat){
      //  self.layer.masksToBounds = true
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
    }
    
    func addCornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
//        self.layer.borderWidth = 0.25
    }
    
    func startProgressHub(){
        let bgview = UIView()
        bgview.frame = self.frame
        bgview.tag = 140
        bgview.backgroundColor = UIColor.black
        bgview.alpha = 0.5
        let view = UIActivityIndicatorView()
        view.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.tag = 40
        view.startAnimating()
        view.center = bgview.center
        bgview.addSubview(view)
        self.addSubview(bgview)
    }
    
    func stopProgresshub(){
        let view = self.viewWithTag(40) as? UIActivityIndicatorView
       let bgview = self.viewWithTag(140)
        view?.stopAnimating()
        view?.removeFromSuperview()
        bgview?.removeFromSuperview()
        
    }
    
    func setLightBlueGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [LightBlueRightColor.cgColor, LightBlueLeftColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setBlueGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [BlueRightColor.cgColor, BlueLeftColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setRedGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [RedRightColor.cgColor, RedLeftColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func removeGradientBackground() {
//        self.layer.sublayers?.removeAll()
    }
    
     func gradientColor(frame: CGRect) -> UIColor? {
        let gradient = CAGradientLayer(layer: frame.size)
        gradient.frame = frame
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0, 1.0]
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradient.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
    }
    
    func zoomIn(){
        self.transform = self.transform.scaledBy(x: 0.001, y: 0.001)

        UIView.animate(withDuration: 1.5, animations: {
              self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
          }, completion: nil)
    }
    
    func roundCorner(sides: UIRectCorner){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: sides, cornerRadii: CGSize(width: 10, height: 10)).cgPath

        //Here I'm masking the textView's layer with rectShape layer
         self.layer.mask = rectShape
        self.layer.masksToBounds = false
    }
}

extension UIViewController{
    
    func showalert(msg: String){
        let alert = UIAlertController(title: "Alert".localize, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localize, style: .default, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }
    
    func secondsBtwnDates( endDate : Date) -> Int{
        let calendar = Calendar.current
        let secDateComponents = calendar.dateComponents([.second], from: Date(), to: endDate)
        let seconds = secDateComponents.second ?? 0
        print("Seconds: \(seconds)")
        return  seconds     //(hr * 3600) + (min * 60) +
    }
    
    func setNav(){
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 20)!, NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let gradientLayer = CAGradientLayer()
        var updatedFrame = self.navigationController!.navigationBar.bounds
        updatedFrame.size.height += 40
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
    
    func timeStamp(date: Date)-> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateformatter.string(from: date)
    }
    
    func getDays(date: Date) -> Int {
       return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
     func getTime() -> String {
    //        var timeStamp = Date().timeIntervalSince1970
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm a"
            return  formatter.string(from: Date())
        }
        
        func getDate() -> String {
            //        var timeStamp = Date().timeIntervalSince1970
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            return formatter.string(from: Date())
        }
        
        func getDateFromString(date: String)-> Date{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            return formatter.date(from: date) ?? Date()
        }
    
    
    func getString(dict: [String: Any])-> String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print(decoded)
        return decoded
    }
}

extension String{
  
        func strikeThrough() -> NSAttributedString {
            let attributeString =  NSMutableAttributedString(string: self)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
            return attributeString
        }
    
    func converttoJSON() -> Dictionary<String, AnyObject>{
        
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String, AnyObject>
            {
               print(jsonArray) // use the json here
                return jsonArray
            } else {
                print("bad json")
                return Dictionary<String, AnyObject>()
            }
        } catch let error as NSError {
            print(error)
        }
        return Dictionary<String, AnyObject>()
    }
    
    func attributed(size:CGFloat = 12,textAlignment: NSTextAlignment = .left,color: UIColor = UIColor.black) -> NSAttributedString {
        let textAlign = (textAlignment == .right) ? "right" : ((textAlignment == .left) ? "left" : "center")
        let htmlCSSString = "<style>"
            + "body {"
            + "font-size: \(size)pt !important;"
            + "text-align: \(textAlign) !important;"
            + "color: \((color == .white) ? "#fff" : "#000") !important;"
            + " } "
            + "</style> \(self.formatted())"
        guard let data = htmlCSSString.data(using: .utf8) else { return NSAttributedString() }
        do {
            let attributed = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
           
                return attributed
        } catch { return NSAttributedString() }
        
    }
    
    func formatted() -> String {
        return replacingOccurrences(of: "\n", with: "<br>")
    }
    
    
    
    
    func convertDate(addValue: Int = 0) ->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = dateformatter.date(from: self) ?? Date()
        date = generateDates(between: date, byAdding: .day, value: addValue) ?? Date()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d"
        return newDateFormatter.string(from: date)
    }
    
    func convertTimeStamp() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = dateformatter.date(from: self) ?? Date()
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return newDateFormatter.string(from: date)
    }
    
    func generateDates(between startDate: Date?, byAdding: Calendar.Component, value: Int) -> Date? {

       
        guard var date = startDate else {
            return nil
        }
        
        date = Calendar.current.date(byAdding: byAdding, value: value, to: date)!
        
        
        return date
    }
    
    func hexStringToUIColor () -> UIColor {
           var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

           if (cString.hasPrefix("#")) {
               cString.remove(at: cString.startIndex)
           }

           if ((cString.count) != 6) {
               return UIColor.gray
           }

           var rgbValue:UInt64 = 0
           Scanner(string: cString).scanHexInt64(&rgbValue)

           return UIColor(
               red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
               green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
               blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
               alpha: CGFloat(1.0)
           )
       }
}

extension UITextField{
    ///Function to set Localize placeholder to textfield
       func placeholder(){
          
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: self.textColor ?? navColor])
       }
    
    func setWhitePlaceholder(){
        self.attributedPlaceholder = NSAttributedString(string: (self.placeholder ?? "").localize, attributes: [NSAttributedString.Key.foregroundColor: self.textColor])
    }
}


extension UIButton{
    
    func setItalicUnderline(){
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : BlueRightColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "",
                                                        attributes: yourAttributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    func setUnderline(){
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : RedLeftColor,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
        let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "",
                                                        attributes: yourAttributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    
    func isSelected(status: Bool,color: UIColor = .groupTableViewBackground){
        if status{
            self.setBlueGradientBackground()
            self.setTitleColor(.white, for: .normal)
        }else{
            self.removeGradientBackground()
            if (self.layer.sublayers?[0].isKind(of: CAGradientLayer.self))!{
                self.layer.sublayers?[0].removeFromSuperlayer()
            }
            self.backgroundColor = color
            self.setTitleColor(UIColor(red: 252/255, green: 36/255, blue: 97/255, alpha: 1), for: .normal)
        }
    }
    
    func isChecked(status : Bool){
        if status{
            self.setImage(#imageLiteral(resourceName: "imgSelected"), for: .normal)
        }else{
            self.setImage(#imageLiteral(resourceName: "imgUnselected"), for: .normal)
        }
    }
    
}


extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        // return the url from new url components
        return urlComponents.url
    }
}


extension Date {
    
    func convertTimeStamp() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd-MMMM-yyyy"
        return newDateFormatter.string(from: self)
    }
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"
            
        }
        
    }
    
    
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
    
}


extension UIImage {
    func textToImage(drawText: String,attribute: [NSAttributedString.Key : Any], atPoint: CGPoint) -> UIImage{

       

        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)


        // Put the image into a rectangle as large as the original image
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        // Create a point within the space that is as bit as the image
        let rect = CGRect(origin: atPoint, size: self.size)
        

        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: attribute)

        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the context now that we have the image we need
        UIGraphicsEndImageContext()

        //Pass the image back up to the caller
        return newImage!

    }
    
     func createImageWithLabelOverlay(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.size.width, height: self.size.height), false, 2.0)
        let currentView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let currentImage = UIImageView.init(image: self)
        currentImage.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        currentView.addSubview(currentImage)
        let lbl = UILabel(frame: label.frame)
        lbl.text = label.text
        lbl.attributedText = label.attributedText
        lbl.font = label.font
        lbl.textAlignment = label.textAlignment
        lbl.alpha = label.alpha
        lbl.textColor = label.textColor
        lbl.numberOfLines = label.numberOfLines
        currentView.addSubview(lbl)
        lbl.center = currentView.center
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func convertImageToBase64String () -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
}

extension PHAsset {
func getAssetThumbnail() -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.isSynchronous = true
    manager.requestImage(for: self,
                         targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                         contentMode: .aspectFit,
                         options: option,
                         resultHandler: {(result, info) -> Void in
                            thumbnail = result!
                         })
    return thumbnail
    }
}


public class localizeButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitle(self.titleLabel?.text?.localize, for: .normal)
    }
}

public class localizeLabel: UILabel {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = self.text?.localize
    }
}

public class localizeTextField: UITextField {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.text = self.text?.localize
        self.placeholder = self.placeholder?.localize
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
}

public class customeSegment: UISegmentedControl {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let unselectTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        self.setTitleTextAttributes(unselectTextAttributes, for: .normal)
        
    }
}
