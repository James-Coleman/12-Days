import UIKit

enum DaysItem: Int, CaseIterable {
    /// A partridge in a pear tree
    case partridge
    /// 2 turtle doves
    case turtleDove
    /// 3 french hens
    case frenchHen
    /// 4 calling birds
    case callingBird
    /// 5 golden rings
    case ring
    /// 6 geese a laying
    case goose
    /// 7 swans a swimming
    case swan
    /// 8 maids a milking
    case maid
    /// 9 ladies dancing
    case lady
    /// 10 pipers piping
    case piper
    /// 11 lords a leaping
    case lord
    /// 12 drummers drumming
    case drummer
    
    // Copy and paste for exhaustive switch statement
    /*
    var name: Type {
        switch self {
        case .partridge:
            return
        case .turtleDove:
            return
        case .frenchHen:
            return
        case .callingBird:
            return
        case .ring:
            return
        case .goose:
            return
        case .swan:
            return
        case .maid:
            return
        case .lady:
            return
        case .piper:
            return
        case .lord:
            return
        case .drummer:
            return
        }
    }
    */
 
    /**
     Converts the `rawValue` of the enum into the day number
     
     The enum must be declared in ascending order for this to work
    */
    var dayCount: Int {
        return self.rawValue + 1
    }
    
    /// An array repeating the item with the appropriate count
    var itemArray: [DaysItem] {
        return Array(repeating: self, count: dayCount)
    }
    
    /// This converts the enum into a simple human readable format
    var emoji: String {
        switch self {
        case .partridge:
            return "🌳"
        case .turtleDove:
            return "🕊"
        case .frenchHen:
            return "🐓"
        case .callingBird:
            return "🦚"
        case .ring:
            return "💍"
        case .goose:
            return "🦆"
        case .swan:
            return "🦢"
        case .maid:
            return "🐄"
        case .lady:
            return "💃"
        case .piper:
            return "🎺"
        case .lord:
            return "🎩"
        case .drummer:
            return "🥁"
        }
    }
    
    /**
     This is effectively the same as day 12
    */
    static var allArray: [[DaysItem]] {
        return DaysItem.allCases.map { $0.itemArray }
    }
    
    enum DaysError: LocalizedError {
        case dayLessThan1
        case dayGreaterThanAllCasesCount
        case couldNotCreateDayItem(from: Int)
        
        var errorDescription: String? {
            switch self {
            case .dayLessThan1:
                return "Day cannot be 0 or a negative number"
            case .dayGreaterThanAllCasesCount:
                return "Day cannot be larger than the possible number of options"
            case let .couldNotCreateDayItem(from: int):
                return "This should already be protected against, but the number \(int) must be greater than 0 and less than or equal to the number of possible cases"
            }
        }
    }
    
    /**
     An array of the items for any particular day
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError.dayLessThan1`
     if `day` 
     
     - Returns: An array of the items for any particular day
     */
    static func array(of day: Int) throws -> [DaysItem] {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= DaysItem.allCases.count else { throw DaysError.dayGreaterThanAllCasesCount }
        
        if day == 1 {
            return DaysItem.partridge.itemArray
        } else {
            guard let item = DaysItem(rawValue: day - 1) else { throw DaysError.couldNotCreateDayItem(from: day) } // This should never fail because of the earlier checks.
            let array = item.itemArray
            let previousArray = try DaysItem.array(of: day - 1)
            return previousArray + array
        }
    }
    
    static func seperateArrays(of day: Int) throws -> [[DaysItem]] {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= DaysItem.allCases.count else { throw DaysError.dayGreaterThanAllCasesCount }
        
        guard let item = DaysItem(rawValue: day - 1) else { throw DaysError.couldNotCreateDayItem(from: day) } // This should never fail because of the earlier checks.
        let array = item.itemArray
        
        if day == 1 {
            return [array]
        } else {
            let previousArrays = try DaysItem.seperateArrays(of: day - 1)
            return previousArrays + [array]
        }
    }
    
    static func cumulativeArray(of day: Int) throws -> [DaysItem] {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let todayArray = try array(of: day)
        
        if day == 1 {
            return todayArray
        } else {
            let previousDays = try cumulativeArray(of: day - 1)
            return previousDays + todayArray
        }
    }
    
    static func dayEmoji(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let dayArray = try DaysItem.array(of: 12)
        let dayEmoji = dayArray.map { $0.emoji }.reduce("", +)
        return dayEmoji
    }
    
    static func emojiSummary(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let arrays = try seperateArrays(of: day)
        let seperateEmoji = arrays.map { array in
            return array.map { $0.emoji }.reduce("", +)
            }.reduce("") { (soFar, next) -> String in
                return soFar == "" ? next : soFar + "\n" + next
        }
        
        return seperateEmoji
    }
    
    static func totalEmoji(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let total = try DaysItem.cumulativeArray(of: 12)
        
        let totalEmoji = total.map { $0.emoji }.reduce("", +)
        
        return totalEmoji
    }
}

DaysItem.callingBird.itemArray

DaysItem.allArray

try DaysItem.dayEmoji(of: 12)

try DaysItem.emojiSummary(of: 3)

try DaysItem.totalEmoji(of: 12)

let total = try DaysItem.cumulativeArray(of: 12)

DaysItem.allCases.forEach { mapItem in
    let count = total.filter { $0 == mapItem }.count
    print(count, mapItem.emoji, mapItem.rawValue + 1, "x", count / (mapItem.rawValue + 1))
}

