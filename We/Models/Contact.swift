import Foundation

struct Contact: Identifiable, Codable {
    var id: UUID = UUID()
    
    var firstName: String
    var lastName: String?
    var nickname: String?
    
    var phoneNumbers: [String]
    var emails: [String]?
    
    var socialMediaProfiles: [String: String]
    
    var about: String?
    var address: String?
        
    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}
