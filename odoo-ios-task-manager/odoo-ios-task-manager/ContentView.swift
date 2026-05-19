//
//  ContentView.swift
//  odoo-ios-task-manager
//
//  Created by Osama Iqbal on 10/05/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Toast System Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    builtInToastsSection
                    customViewSection
                    positionsSection
                }
                .padding()
            }
            .navigationTitle("Toast Demo")
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
            }
        }
    }
    
    private var positionsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Different Positions")
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
}

#Preview {
    ContentView()
}
