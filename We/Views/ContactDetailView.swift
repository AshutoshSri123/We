import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @State private var showingEditView = false
    
    var contact: Contact
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(contact.fullName)
                    .font(.largeTitle)
                    .bold()
                
                if let nickname = contact.nickname {
                    Text("Nickname: \(nickname)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                Group {
                    if !contact.phoneNumbers.isEmpty {
                        SectionHeaderView(title: "Phone Numbers")
                        ForEach(contact.phoneNumbers, id: \.self) { number in
                            Text(number).font(.body)
                        }
                    }
                    
                    if let emails = contact.emails, !emails.isEmpty {
                        SectionHeaderView(title: "Emails")
                        ForEach(emails, id: \.self) { email in
                            Text(email).font(.body)
                        }
                    }
                    
                    if !contact.socialMediaProfiles.isEmpty {
                        SectionHeaderView(title: "Social Media")
                        ForEach(contact.socialMediaProfiles.sorted(by: { $0.key < $1.key }), id: \.key) { platform, handle in
                            Link("\(platform): \(handle)", destination: URL(string: handle) ?? URL(string: "https://\(handle)")!)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if let about = contact.about, !about.isEmpty {
                        SectionHeaderView(title: "About")
                        Text(about).font(.body)
                    }
                    
                    if let address = contact.address, !address.isEmpty {
                        SectionHeaderView(title: "Address")
                        Text(address).font(.body)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditView = true
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditContactView(contactToEdit: contact)
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 4)
    }
}
