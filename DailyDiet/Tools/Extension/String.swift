import UIKit

extension String {

    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = "-") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
    
    /// Encode String to Base 64
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }


    /// Decode String from Base 64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    /// Convert English number string to persian
    func convertNumberToPersian() -> String {
        Log.i()

        let numbersDictionary: Dictionary = ["0": "۰", "1": "۱", "2": "۲", "3": "۳", "4": "۴", "5": "۵", "6": "۶", "7": "۷", "8": "۸", "9": "۹"]
        var str: String = self

        for (key, value) in numbersDictionary {
            str = str.replacingOccurrences(of: key, with: value)
        }

        return str
    }

    /// Convert English number string to persian
    func convertNumberToEnglish() -> String {
        Log.i()

        let numbersDictionary: Dictionary = ["۰": "0", "۱": "1", "۲": "2", "۳": "3", "۴": "4", "۵": "5", "۶": "6", "۷": "7", "۸": "8", "۹": "9"]
        var str: String = self

        for (key, value) in numbersDictionary {
            str = str.replacingOccurrences(of: key, with: value)
        }

        return str
    }


    subscript (i: Int) -> String {
        Log.i()

        return self[i ..< i + 1]
    }

    /// Return subString from index i to last
    func substring(fromIndex: Int) -> String {
        Log.i()

        return self[min(fromIndex, count) ..< count]
    }

    /// Return subString from first to  index i
    func substring(toIndex: Int) -> String {
        Log.i()

        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        Log.i()

        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        Log.i()

        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else { return attributedString }

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }

    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }
}
