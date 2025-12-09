import UIKit

extension String {
    
    var localize: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func typeFile() -> String {
        var type = ""
        var completed = false
        
        for character in self.reduce([], { [$1] + $0 }) {
            if character == "." {
                completed = true
            }
            
            if !completed {
                type = character.description + type
            }
        }
        return "ff.\(type)"
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    //MARK: get Age
    func getAge() -> Int? {
        let dateString = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        let now = Date()
        let calendar = Calendar.current
        guard let dateOfBirth = date else { return nil }
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year
    }
}
extension NSMutableAttributedString {
    
    func foundText(text : String , serchText: String, font: CGFloat) -> NSMutableAttributedString {
        
        let string = text
        let lowecasedString = string.lowercased()
        let substring = serchText.lowercased()
        var index = 0
        let newStr = self
        newStr.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: string.count))
        newStr.addAttribute(.font, value:  UIFont.systemFont(ofSize: font), range: NSRange(location: 0, length: string.count))
        var arrayRange = [NSRange]()
        var lengthOfFound = 0
        for char in lowecasedString {
            if substring.first == char {
                // Create a start and end index to ultimately creata range
                //
                // Hello Agnosticdev, I love Tutorials
                //       6   ->   17 - rage of substring from 7 to 18
                //
                if substring.count + index <= lowecasedString.count {
                    lengthOfFound = substring.count + index
                } else {
                    lengthOfFound = index
                }
                
                let startOfFoundCharacter = string.index(string.startIndex, offsetBy: index)
                let lengthOfFoundCharacter = string.index(string.startIndex, offsetBy: lengthOfFound)
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                // Grab the substring from the parent string and compare it against substring
                // Essentially, looking for the needle in a haystack
                if lowecasedString.substring(with: range) == substring {
                    arrayRange.append(NSRange(location: index, length: substring.count))
                }
            }
            index += 1
        }
        if arrayRange.count > 0 {
            for range in arrayRange {
                newStr.addAttribute(NSAttributedString.Key.link, value: serchText, range: range)
                newStr.addAttribute(.font, value:  UIFont.systemFont(ofSize: font), range: range)
                newStr.addAttribute(.foregroundColor, value: UIColor.yellow, range: range)
            }
        }
        
        return newStr
    }
}

