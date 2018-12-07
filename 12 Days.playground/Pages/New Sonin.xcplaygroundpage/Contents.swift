import UIKit

extension NumberFormatter {
    public static let ordinalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()
}

extension Int {
    public var withOrdinal: String {
        let number = NSNumber(integerLiteral: self)
        return NumberFormatter.ordinalFormatter.string(from: number) ?? String(self)
    }
}

enum Day: Int {
    case first = 1
    case second
    case third
    case fourth
    case fifth
    case sixth
    case seventh
    case eighth
    case ninth
    case tenth
    case eleventh
    case twelfth
}

enum DaysItem: Int, CaseIterable {
    case henry
    case crashingBug
    case failingTest
    case callingClient
    case goldIPhone
    case geek
    case server
    case amend
    case laravel
    case proxy
    case quote
    case driver
    
    // Copy and paste for exhaustive switch statement
    /*
     var name: Type {
     switch self {
     case .henry:
     return
     case .crashingBug:
     return
     case .failingTest:
     return
     case .callingClient:
     return
     case .goldIPhone:
     return
     case .geek:
     return
     case .server:
     return
     case .amend:
     return
     case .laravel:
     return
     case .proxy:
     return
     case .quote:
     return
     case .driver:
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
        case .henry:
            return "🖥"
        case .crashingBug:
            return "🕷"
        case .failingTest:
            return "❗️"
        case .callingClient:
            return "📞"
        case .goldIPhone:
            return "📱"
        case .geek:
            return "🤓"
        case .server:
            return "🔥"
        case .amend:
            return "🥛"
        case .laravel:
            return "⏳"
        case .proxy:
            return "↗️"
        case .quote:
            return "📄"
        case .driver:
            return "🚗"
        }
    }
    
    /// A string containing the appropriate number of emoji for the day
    var multipleEmoji: String {
        let array = Array(repeating: emoji, count: dayCount)
        let string = array.reduce("", +)
        return string
    }
    
    /// A string describing the gift.
    var rhyme: String {
        switch self {
        case .henry:
            return "A web dev named Henry"
        case .crashingBug:
            return "Two crashing bugs"
        case .failingTest:
            return "Three failing tests"
        case .callingClient:
            return "Four calling clients"
        case .goldIPhone:
            return "Five gold iPhones"
        case .geek:
            return "Six geeks a coding"
        case .server:
            return "Seven servers burning"
        case .amend:
            return "Eight amends milking it"
        case .laravel:
            return "Nine laravels building"
        case .proxy:
            return "Ten proxies proxied"
        case .quote:
            return "Eleven quotes misleading"
        case .driver:
            return "Twelve drivers updating"
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
        
        var failureReason: String? {
            switch self {
            case .dayLessThan1:
                return "The day was less than 1"
            case .dayGreaterThanAllCasesCount:
                return "The day was larger than the possible number of options"
            case let .couldNotCreateDayItem(from: int):
                return "This should already be protected against, but the number \(int) is either less than 0 or more than or equal to the number of possible cases"
            }
        }
        
        var recoverySuggestion: String? {
            return "Make the day greater than 0 and less than or equal to the possible number of options"
        }
    }
    
    /**
     A combined array of the new items given for any particular day
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: An array of the new items for any particular day
     */
    static func dayArray(of day: Int) throws -> [DaysItem] {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= DaysItem.allCases.count else { throw DaysError.dayGreaterThanAllCasesCount }
        
        if day == 1 {
            return DaysItem.henry.itemArray
        } else {
            guard let item = DaysItem(rawValue: day - 1) else { throw DaysError.couldNotCreateDayItem(from: day) } // This should never fail because of the earlier checks.
            let array = item.itemArray
            let previousArray = try DaysItem.dayArray(of: day - 1)
            return previousArray + array
        }
    }
    
    /**
     Seperate arrays of the new items given for any particular day
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: An array of arrays of the new items for any particular day
     */
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
    
    /**
     A single array containing all the things obtained up to and including a particular day.
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: A single array of all items obtained up to and including the given day
     */
    static func cumulativeArray(of day: Int) throws -> [DaysItem] {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let todayArray = try dayArray(of: day)
        
        if day == 1 {
            return todayArray
        } else {
            let previousDays = try cumulativeArray(of: day - 1)
            return previousDays + todayArray
        }
    }
    
    /**
     A string of emojis of the new items given for any particular day
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: A string containing emojis of the new items obtained on the given day
     */
    static func dayEmoji(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let dayArray = try DaysItem.dayArray(of: day)
        let dayEmoji = dayArray.map { $0.emoji }.reduce("", +)
        return dayEmoji
    }
    
    /**
     A string of emojis of the new items given for any particular day, seperated onto newlines per itemtype.
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: A string containing emojis of the new items obtained on the given day, seperated onto newlines per itemtype
     */
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
    
    /**
     A string of emojis of all the items obtained upto and including any particular day.
     
     - Parameter day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: A string containing emojis of the entire song, seperated onto newlines per itemtype
     */
    static func totalEmoji(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let total = try DaysItem.cumulativeArray(of: day)
        
        let totalEmoji = total.map { $0.emoji }.reduce("", +)
        
        return totalEmoji
    }
    
    /**
     A string of the rhymes and multiple emojis of all the items obtained upto and including any particular day.
     This uses recursion to assemble the entire rhyme.
     
     This is private because it shouldn't be used on it's own.
     
     - Parameter day: The number of the day
     - Parameter justFirstDay: If this is just day `1` and no other days. This controls the exact text description of the first day.
     
     - Throws: `DaysError`
     
     - Returns: A string containing rhymes and emojis of the song upto and including the specified day, seperated onto newlines per itemtype
     */
    private static func cumulativeRhyme(of day: Int, justFirstDay: Bool = false) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        guard let item = DaysItem(rawValue: day - 1) else { throw DaysError.couldNotCreateDayItem(from: day) } // This should never fail because of the earlier checks.
        
        let todaysRhyme = "\(item.rhyme) \(item.multipleEmoji)"
        
        let prefix = day % 2 == 0 ? "🎵 " : "🎶 "
        
        if day == 1 && justFirstDay {
            return todaysRhyme
        } else if day == 1 {
            let withoutA = todaysRhyme.dropFirst()
            let newRhyme = "And a" + withoutA
            return prefix + newRhyme
        } else {
            let yesterdaysRhyme = try cumulativeRhyme(of: day - 1)
            return prefix + todaysRhyme + "\n" + yesterdaysRhyme
        }
    }
    
    /**
     A string of the entire rhyme for any particular day, with emoji as well.
     
     - Paramater day: The number of the day
     
     - Throws: `DaysError`
     
     - Returns: A string containing the start of the rhyme, and each line of the rhyme up to and including the specified day
    */
    public static func totalRhyme(of day: Int) throws -> String {
        guard day >= 1 else { throw DaysError.dayLessThan1 }
        guard day <= 12 else { throw DaysError.dayGreaterThanAllCasesCount }
        
        let start = """
        🎵 On the \(day.withOrdinal) day of Sonin,
        🎶 My P.M. gave to me:
        """
        
        let body = try cumulativeRhyme(of: day, justFirstDay: day == 1)
        
        return start + "\n" + body
    }
}

//DaysItem.callingClient.itemArray

//DaysItem.allArray

//try DaysItem.seperateArrays(of: Day.third.rawValue)

//try DaysItem.cumulativeArray(of: Day.third.rawValue)

//try DaysItem.dayEmoji(of: Day.third.rawValue)

//try DaysItem.emojiSummary(of: Day.third.rawValue)

//try DaysItem.allEmoji()

// This is to show the breakdown of how many total items of each type there are.
/*
 let total = try DaysItem.cumulativeArray(of: Day.twelfth.rawValue)
 
 DaysItem.allCases.forEach { mapItem in
 let count = total.filter { $0 == mapItem }.count
 print(count, mapItem.emoji, mapItem.rawValue + 1, "x", count / (mapItem.rawValue + 1))
 }
 */

//print(try DaysItem.emojiSummary(of: Day.second.rawValue))

print(try DaysItem.totalRhyme(of: Day.fifth.rawValue))
