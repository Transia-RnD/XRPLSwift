//
//  IssuedCurrencyAmount.swift
//  
//
//  Created by Denis Angell on 3/20/22.
//

import Foundation

public struct IssuedCurrencyAmount {
    
//    private(set) var value: String
    
    private(set) var drops: Int!
    public var currency: String = "XRP"
    public var issuer: String?
    
    public init(value: Int, currency: String, issuer: String) throws {
        if value < 0 || value > UInt64(100000000000000000) {
            throw AmountError.invalidAmount
        }
        self.drops = value
        self.currency = currency
        self.issuer = issuer
    }
    
    public init(drops: Int) throws {
        if drops < 0 || drops > UInt64(100000000000000000) {
            throw AmountError.invalidAmount
        }
        self.drops = drops
    }
    
    public init(_ text: String) throws {
        // removed commas
        let stripped = text.replacingOccurrences(of: ",", with: "")
        if !stripped.replacingOccurrences(of: ".", with: "").isNumber {
            throw AmountError.invalidAmount
        }
        // get parts
        var xrp = stripped
        var drops = ""
        if let decimalIndex = stripped.firstIndex(of: ".") {
            xrp = String(stripped.prefix(upTo: decimalIndex))
            let _index = stripped.index(decimalIndex, offsetBy: 1)
            drops = String(stripped.suffix(from: _index))
        }
        // adjust values
        drops = drops + String.init(repeating: "0", count: 6-drops.count)
        // combine parts
        let _drops = Int(xrp+drops)!
        if _drops < 0 || _drops > UInt64(100000000000000000) {
            throw AmountError.invalidAmount
        }
        self.drops = _drops
    }
    
    public init(xrp: Double) throws {
        let _drops = Int(xrp*1000000)
        if _drops < 0 || _drops > UInt64(100000000000000000) {
            throw AmountError.invalidAmount
        }
        self.drops = _drops
    }
    
    public func prettyPrinted() -> String {
        let drops = self.drops%1000000
        let xrp = self.drops/1000000
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: xrp))!
        let leadingZeros: [Character] = Array(repeating: "0", count: 6 - String(drops).count)
        return formattedNumber + "." + String(leadingZeros) + String(drops)
    }
    
    public func toDrops() -> Int {
        return self.drops
    }
    
    public func toXrp() -> Double {
        return Double(self.drops) / Double(1000000)
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
