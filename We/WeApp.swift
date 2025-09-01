
import SwiftUI

@main
struct WeApp: App {
    @StateObject var contactsVM = ContactsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environmentObject(contactsVM)
        }
    }
}
