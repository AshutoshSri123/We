import Foundation
import Combine

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    private let savingKey = "WeAppContacts"
    
    init() {
        loadContacts()
    }
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        saveContacts()
    }
    
    func updateContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts[index] = contact
            saveContacts()
        }
    }
    
    func deleteContact(_ contact: Contact) {
        contacts.removeAll { $0.id == contact.id }
        saveContacts()
    }
    
    private func saveContacts() {
        if let encoded = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(encoded, forKey: savingKey)
        }
    }
    
    private func loadContacts() {
        if let data = UserDefaults.standard.data(forKey: savingKey),
           let decoded = try? JSONDecoder().decode([Contact].self, from: data) {
            contacts = decoded
        }
    }
}
