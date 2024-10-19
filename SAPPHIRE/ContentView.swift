//
//  ContentView.swift
//  SAPPHIRE
//
//  Created by EZ on 10/18/24.
//

import SwiftUI

//Shnoz circle Toggle style
struct CircularToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            Circle()
                .fill(configuration.isOn ? Color.green : Color.gray)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
    }
}

struct ToggleButtonView: View {
    @Binding var isScreenProctoringEnabled: Bool
    @Binding var isGazeTrackingEnabled: Bool

    var body: some View {
        VStack(spacing: 15) {
            Text("How Should We Keep You On Task?")
                .font(.title2)

            Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                .toggleStyle(CircularToggleStyle())

            Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                .toggleStyle(CircularToggleStyle())
        }
    }
}

struct ContentView: View {
    @State private var task: String = ""
    @State private var isTaskSelected: Bool = false
    @State private var isScreenProctoringEnabled: Bool = false
    @State private var isGazeTrackingEnabled: Bool = false

    @ObservedObject var screenProctoring = ScreenProctoring()

    var body: some View {
        VStack {
            if !isTaskSelected {
                Text("Enter your task")
                    .font(.title)
                    .padding()

                TextField("Enter your task here", text: $task)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    isTaskSelected = true
                }) {
                    Text("Next")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Text("How Should We Keep You On Task?")
                    .font(.title2)
                    .padding()

                // Shnoz changed buttons to toggle
                HStack{
                    Toggle("Proctor My Screen", isOn: $isScreenProctoringEnabled)
                        .toggleStyle(CircularToggleStyle())
                        .onChange(of: isScreenProctoringEnabled) {
                            if isScreenProctoringEnabled {
                                screenProctoring.startScreenProctoring()
                                
                            } else {
                                screenProctoring.stopScreenProctoring()
                            }
                        }
                    Text("Proctor My Screen")
                        .font(.headline)
                        .foregroundColor(isScreenProctoringEnabled ? .green : .gray)
                }

                // shnoz changed to toggle
                HStack{
                    Toggle("Track My Gaze", isOn: $isGazeTrackingEnabled)
                        .toggleStyle(CircularToggleStyle())
                    Text("Track My Gaze")
                        .font(.headline)
                        .foregroundColor(isGazeTrackingEnabled ? .green : .gray)
                }
                if isScreenProctoringEnabled || isGazeTrackingEnabled {
                    Button(action: {
                        // TBD: Start Task Logic
                    }) {
                        Text("Start Task")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}

//
