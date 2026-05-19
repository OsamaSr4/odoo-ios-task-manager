import SwiftUI

struct AppDropdown<T: Hashable & CustomStringConvertible>: View {
    @Binding var selectedItem: T?
    let items: [T]
    let placeholder: String
    let allowsEmptySelection: Bool
    
    @State private var isExpanded = false
    
    init(
        selectedItem: Binding<T?>,
        items: [T],
        placeholder: String = "Select an option",
        allowsEmptySelection: Bool = false
    ) {
        self._selectedItem = selectedItem
        self.items = items
        self.placeholder = placeholder
        self.allowsEmptySelection = allowsEmptySelection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    AppText(
                        selectedItem?.description ?? placeholder,
                        variant: .regular,
                        color: selectedItem != nil ? .primary : .gray
                    )
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 0) {
                    if allowsEmptySelection {
                        dropdownRow(nil, title: "None")
                    }
                    
                    ForEach(items, id: \.self) { item in
                        dropdownRow(item, title: item.description)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
                .clipped()
            }
        }
        .onTapGesture {
            isExpanded = false
        }
    }
    
    private func dropdownRow(_ item: T?, title: String) -> some View {
        Button(action: {
            selectedItem = item
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded = false
            }
        }) {
            HStack {
                AppText(
                    title,
                    variant: .regular,
                    color: .primary
                )
                
                Spacer()
                
                if selectedItem == item {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                selectedItem == item ? Color.blue.opacity(0.1) : Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 30) {
        AppDropdown(
            selectedItem: .constant("Option 2"),
            items: ["Option 1", "Option 2", "Option 3"],
            placeholder: "Choose an option"
        )
        
        AppDropdown(
            selectedItem: .constant(nil),
            items: ["Apple", "Banana", "Orange", "Grape"],
            placeholder: "Select a fruit",
            allowsEmptySelection: true
        )
        
        AppDropdown(
            selectedItem: .constant(2),
            items: [1, 2, 3, 4, 5],
            placeholder: "Select a number"
        )
    }
    .padding()
}
