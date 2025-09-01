import SwiftUI

struct AddEditContactView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var contactID: UUID? = nil
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nickname: String = ""
    @State private var phoneNumbers: [String] = [""]
    @State private var emails: [String] = [""]
    @State private var socialMediaProfiles: [String: String] = [:]
    @State private var about: String = ""
    @State private var address: String = ""
    
    @State private var newPlatform: String = ""
    @State private var newHandle: String = ""
    
    var contactToEdit: Contact?
    
    var isEditing: Bool {
        contactToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Nickname", text: $nickname)
                }
                
                Section(header: Text("Phone Numbers")) {
                    ForEach(phoneNumbers.indices, id: \.self) { index in
                        HStack {
                            TextField("Phone Number", text: Binding(
                                get: { phoneNumbers[index] },
                                set: { phoneNumbers[index] = $0 }
                            ))
                            if phoneNumbers.count > 1 {
                                Button(action: {
                                    phoneNumbers.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button(action: { phoneNumbers.append("") }) {
                        Label("Add Phone Number", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Emails")) {
                    ForEach(emails.indices, id: \.self) { index in
                        HStack {
                            TextField("Email", text: Binding(
                                get: { emails[index] },
                                set: { emails[index] = $0 }
                            ))
                            if emails.count > 1 {
                                Button(action: {
                                    emails.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button(action: { emails.append("") }) {
                        Label("Add Email", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Social Media Profiles")) {
                    ForEach(socialMediaProfiles.keys.sorted(), id: \.self) { platform in
                        HStack {
                            Text(platform)
                            Spacer()
                            TextField("Handle/URL", text: Binding(
                                get: { socialMediaProfiles[platform] ?? "" },
                                set: { socialMediaProfiles[platform] = $0 }
                            ))
                            Button(action: {
                                socialMediaProfiles.removeValue(forKey: platform)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Platform", text: $newPlatform)
                        TextField("Handle/URL", text: $newHandle)
                        Button(action: {
                            if !newPlatform.isEmpty && !newHandle.isEmpty {
                                socialMediaProfiles[newPlatform] = newHandle
                                newPlatform = ""
                                newHandle = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    TextEditor(text: $about)
                        .frame(height: 100)
                }
                
                Section(header: Text("Address")) {
                    TextEditor(text: $address)
                        .frame(height: 80)
                }
            }
            .navigationBarTitle(isEditing ? "Edit Contact" : "New Contact", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveContact()
                }
                .disabled(firstName.trimmingCharacters(in: .whitespaces).isEmpty || phoneNumbers.allSatisfy { $0.trimmingCharacters(in: .whitespaces).isEmpty })
            )
            .onAppear {
                if let contact = contactToEdit {
                    loadContact(contact)
                }
            }
        }
    }
    
    func loadContact(_ contact: Contact) {
        contactID = contact.id
        firstName = contact.firstName
        lastName = contact.lastName ?? ""
        nickname = contact.nickname ?? ""
        phoneNumbers = contact.phoneNumbers.isEmpty ? [""] : contact.phoneNumbers
        emails = contact.emails ?? [""]
        socialMediaProfiles = contact.socialMediaProfiles
        about = contact.about ?? ""
        address = contact.address ?? ""
    }
    
    func saveContact() {
        let newContact = Contact(
            id: contactID ?? UUID(),
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces).isEmpty ? nil : lastName.trimmingCharacters(in: .whitespaces),
            nickname: nickname.trimmingCharacters(in: .whitespaces).isEmpty ? nil : nickname.trimmingCharacters(in: .whitespaces),
            phoneNumbers: phoneNumbers.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            emails: emails.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty },
            socialMediaProfiles: socialMediaProfiles,
            about: about.trimmingCharacters(in: .whitespaces).isEmpty ? nil : about.trimmingCharacters(in: .whitespaces),
            address: address.trimmingCharacters(in: .whitespaces).isEmpty ? nil : address.trimmingCharacters(in: .whitespaces)
        )
        
        if isEditing {
            contactsVM.updateContact(newContact)
        } else {
            contactsVM.addContact(newContact)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
