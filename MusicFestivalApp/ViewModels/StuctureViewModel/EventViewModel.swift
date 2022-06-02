import Foundation

struct EventViewModel {
    let event : Event
    
    let formatter1 = DateFormatter()
    
    
    init(event: Event){
        self.event = event
        formatter1.dateStyle = .short
    }
    
    var id: UUID {
        return self.event.id
    }
    var name: String {
        return self.event.name
    }
    var location: String {
        return self.event.location
    }
    var startedDate: String {
        return formatter1.string(from: self.event.started_date)
    }
    var finishDate: String {
        return formatter1.string(from: self.event.finish_date)
    }
}



