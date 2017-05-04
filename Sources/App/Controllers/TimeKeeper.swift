import Foundation

var dateFormater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm:ssss a z 'on' EEEE, MMMM dd, y"
    formatter.timeZone = TimeZone(abbreviation: "ICT")
    
    return formatter
}()

final class TimeKeeper {
    var systemTime: () -> String = {
        let current = Date()
        
        return dateFormater.string(from: current)
    }
}
