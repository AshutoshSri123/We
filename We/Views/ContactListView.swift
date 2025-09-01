import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @State private var showingAddContact = false
    @State private var searchText = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contactsVM.contacts.sorted { $0.fullName < $1.fullName }
        } else {
            return contactsVM.contacts.filter {
                $0.fullName.lowercased().contains(searchText.lowercased()) ||
                ($0.nickname?.lowercased().contains(searchText.lowercased()) ?? false)
            }.sorted { $0.fullName < $1.fullName }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredContacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact)) {
                        VStack(alignment: .leading) {
                            Text(contact.fullName)
                                .font(.headline)
                            if let nickname = contact.nickname {
                                Text(nickname).font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteContact)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("We Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddContact = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddEditContactView()
            }
            .searchable(text: $searchText, prompt: "Search contacts")
        }
    }
    
    func deleteContact(at offsets: IndexSet) {
        offsets.forEach { index in
            let contact = filteredContacts[index]
            contactsVM.deleteContact(contact)
        }
    }
}
