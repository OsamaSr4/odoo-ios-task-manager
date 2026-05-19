import SwiftUI

struct NavBar: View {
    let items: [NavBarItem]
    @Binding var selectedItem: NavBarItem
    
    init(
        items: [NavBarItem],
        selectedItem: Binding<NavBarItem>
    ) {
        self.items = items
        self._selectedItem = selectedItem
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                navBarItemView(item)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
        )
    }
    
    @ViewBuilder
    private func navBarItemView(_ item: NavBarItem) -> some View {
        Button(action: {
            selectedItem = item
            item.action?()
        }) {
            VStack(spacing: 4) {
                item.icon
                    .font(.title2)
                    .foregroundColor(isSelected(item) ? .blue : .gray)
                
                AppText(
                    item.title,
                    variant: .regular,
                    color: isSelected(item) ? .blue : .gray
                )
                .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected(item) ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func isSelected(_ item: NavBarItem) -> Bool {
        return item.id == selectedItem.id
    }
}

struct NavBarItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: Image
    let action: (() -> Void)?
    
    init(
        title: String,
        icon: Image,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    static func == (lhs: NavBarItem, rhs: NavBarItem) -> Bool {
        return lhs.id == rhs.id
    }
}

#Preview {
    VStack(spacing: 0) {
        Spacer()
        
        NavBar(
            items: [
                NavBarItem(
                    title: "Home",
                    icon: Image(systemName: "house.fill")
                ),
                NavBarItem(
                    title: "Tasks",
                    icon: Image(systemName: "list.bullet")
                ),
                NavBarItem(
                    title: "Calendar",
                    icon: Image(systemName: "calendar")
                ),
                NavBarItem(
                    title: "Profile",
                    icon: Image(systemName: "person.fill")
                )
            ],
            selectedItem: .constant(
                NavBarItem(title: "Home", icon: Image(systemName: "house.fill"))
            )
        )
    }
    .ignoresSafeArea(edges: .bottom)
}
