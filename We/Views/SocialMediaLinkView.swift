import SwiftUI

struct SocialMediaLinkView: View {
    @Binding var platform: String
    @Binding var handle: String
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            TextField("Platform", text: $platform)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
            
            TextField("Handle / URL", text: $handle)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
            
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill").foregroundColor(.red)
                }
            }
        }
    }
}
