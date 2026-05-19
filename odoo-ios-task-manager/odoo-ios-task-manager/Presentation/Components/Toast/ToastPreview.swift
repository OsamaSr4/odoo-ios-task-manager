import SwiftUI

struct ToastPreview: View {
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    builtInToastsSection
                    positionsSection
                    customViewSection
                    customPositionSection
                }
                .padding()
            }
            .navigationTitle("Toast System Preview")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(toastManager)
        .overlay(ToastContainer(toastManager: toastManager))
    }
    
    private var builtInToastsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Built-in Toast Types")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                Button("Info Toast") {
                    toastManager.info("This is an info message", title: "Info")
                }
                .buttonStyle(.bordered)
                
                Button("Success Toast") {
                    toastManager.success("Task completed successfully!", title: "Success")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Error Toast") {
                    toastManager.error("Something went wrong", title: "Error")
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
                Button("Warning Toast") {
                    toastManager.warning("Please check your input", title: "Warning")
                }
                .buttonStyle(.bordered)
                .tint(.orange)
            }
        }
    }
    
    private var positionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("iPhone Positions")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                Button("Top Position") {
                    toastManager.success("Top position toast", position: .top)
                }
                .buttonStyle(.bordered)
                
                Button("Bottom Position") {
                    toastManager.info("Bottom position toast", position: .bottom)
                }
                .buttonStyle(.bordered)
                
                Button("Center Position") {
                    toastManager.warning("Center position toast", position: .center)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var customViewSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Custom View Toasts")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                Button("Premium Toast") {
                    toastManager.showCustom(
                        view: HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Premium Activated")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("You now have access to all features.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Download Toast") {
                    toastManager.showCustom(
                        view: HStack(spacing: 12) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Downloading...")
                                    .font(.headline)
                                Text("File: document.pdf")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(12)
                    )
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var customPositionSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Custom Positions")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                Button("Top Trailing Custom") {
                    toastManager.showCustom(
                        view: Text("Custom Position")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8),
                        position: .custom(alignment: .topTrailing, offset: CGSize(width: -24, height: 40))
                    )
                }
                .buttonStyle(.bordered)
                
                Button("Bottom Leading Custom") {
                    toastManager.error("Custom position alert", position: .custom(alignment: .bottomLeading, offset: CGSize(width: 24, height: -40)))
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
    }
}

struct iPadToastPreview: View {
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    iPadPositionsSection
                    iPadCustomSection
                }
                .padding()
            }
            .navigationTitle("iPad Toast Preview")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(toastManager)
        .overlay(ToastContainer(toastManager: toastManager))
    }
    
    private var iPadPositionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("iPad Positions")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                Button("Top Left") {
                    toastManager.success("Top left position", position: .topLeft)
                }
                .buttonStyle(.bordered)
                
                Button("Top") {
                    toastManager.info("Top position", position: .top)
                }
                .buttonStyle(.bordered)
                
                Button("Top Right") {
                    toastManager.warning("Top right position", position: .topRight)
                }
                .buttonStyle(.bordered)
                
                Button("Bottom Left") {
                    toastManager.error("Bottom left position", position: .bottomLeft)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                
                Button("Bottom") {
                    toastManager.success("Bottom position", position: .bottom)
                }
                .buttonStyle(.bordered)
                
                Button("Bottom Right") {
                    toastManager.info("Bottom right position", position: .bottomRight)
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private var iPadCustomSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("iPad Custom Views")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                Button("Wide Custom Toast") {
                    toastManager.showCustom(
                        view: HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.white)
                            VStack(alignment: .leading) {
                                Text("Analytics Dashboard")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Monthly report is ready")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            Button("View") {
                                print("View analytics")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                        }
                        .padding()
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12),
                        maxWidth: 400
                    )
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview("iPhone Toast Preview") {
    ToastPreview()
}

#Preview("iPad Toast Preview") {
    iPadToastPreview()
        .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
        .previewDisplayName("iPad Pro")
}
