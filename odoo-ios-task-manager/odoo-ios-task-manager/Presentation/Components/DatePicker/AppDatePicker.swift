import SwiftUI

struct AppDatePicker: View {
    @Binding var selectedDate: Date
    let title: String
    let minimumDate: Date?
    let maximumDate: Date?
    let displayedComponents: DatePickerComponents
    
    @State private var isShowingDatePicker = false
    
    init(
        selectedDate: Binding<Date>,
        title: String = "Select Date",
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        displayedComponents: DatePickerComponents = [.date]
    ) {
        self._selectedDate = selectedDate
        self.title = title
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.displayedComponents = displayedComponents
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                isShowingDatePicker.toggle()
            }) {
                HStack {
                    AppText(title, variant: .medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    AppText(
                        formattedDate,
                        variant: .regular,
                        color: .gray
                    )
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
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
            
            if isShowingDatePicker {
                VStack(spacing: 0) {
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        in: dateRange,
                        displayedComponents: displayedComponents
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    
                    HStack {
                        AppButton("Cancel", variant: .outline) {
                            isShowingDatePicker = false
                        }
                        
                        AppButton("Done") {
                            isShowingDatePicker = false
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = displayedComponents.contains(.hourAndMinute) ? .short : .none
        return formatter.string(from: selectedDate)
    }
    
    private var dateRange: ClosedRange<Date> {
        let start = minimumDate ?? Date.distantPast
        let end = maximumDate ?? Date.distantFuture
        return start...end
    }
}

#Preview {
    VStack(spacing: 30) {
        AppDatePicker(
            selectedDate: .constant(Date()),
            title: "Birth Date",
            maximumDate: Date()
        )
        
        AppDatePicker(
            selectedDate: .constant(Date()),
            title: "Appointment Date",
            minimumDate: Date(),
            displayedComponents: [.date, .hourAndMinute]
        )
        
        AppDatePicker(
            selectedDate: .constant(Date()),
            title: "Event Date",
            minimumDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())
        )
    }
    .padding()
}
