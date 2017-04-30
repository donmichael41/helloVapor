import Foundation

var dateFormater: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a z 'on' EEEE, MMMM dd, y"
    formatter.timeZone = TimeZone(abbreviation: "Asia/Bangkok")
    
    return formatter
}()

final class TimeKeeper {
    var systemTime: () -> String = {
        let current = Date()
        
        return dateFormater.string(from: current)
    }
}
