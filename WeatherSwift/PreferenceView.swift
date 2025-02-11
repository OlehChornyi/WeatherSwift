//
//  PreferenceView.swift
//  WeatherSwift
//
//  Created by Oleh on 11.02.2025.
//

import SwiftUI
import SwiftData

struct PreferenceView: View {
    @Query var preferences: [Preference]
    @State private var locationName = ""
    @State private var latString = ""
    @State private var longString = ""
    @State private var selectedUnit = UnitSystem.imperial
    @State private var degreeUnitShowing = true
    var degreeUnit: String {
        if degreeUnitShowing {
            return selectedUnit == .imperial ? "F" : "C"
        }
        return ""
    }
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                TextField("location", text: $locationName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .padding(.bottom)
                
                Group {
                    Text("Lattitude:")
                        .bold()
                    TextField("lattitude", text: $latString)
                    
                    Text("Longitude:")
                        .bold()
                    TextField("longitude", text: $longString)
                        .padding(.bottom)
                }
                .font(.title2)
                
                HStack {
                    Text("Units:")
                        .bold()
                    
                    Spacer()
                    
                    Picker("", selection: $selectedUnit) {
                        ForEach(UnitSystem.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .padding(.bottom)
                }
                .font(.title2)
                
                Toggle("Show F/C after temp value", isOn: $degreeUnitShowing)
                    .font(.title2)
                    .bold()
                
                HStack {
                    Spacer()
                    Text("42°\(degreeUnit)")
                        .font(.system(size: 150))
                        .fontWeight(.thin)
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !preferences.isEmpty {
                            for preference in preferences {
                                modelContext.delete(preference)
                            }
                        }
                        let preference = Preference(
                            locationName: locationName,
                            latString: latString,
                            longString: longString,
                            selectedUnit: selectedUnit,
                            degreeUnitShowing: degreeUnitShowing
                        )
                        modelContext.insert(preference)
                        guard let _ = try? modelContext.save() else {return}
                        dismiss()
                    }
                }
            }
        }
        .task {
            guard !preferences.isEmpty else {return}
            let preference = preferences.first!
            locationName = preference.locationName
            latString = preference.latString
            longString = preference.longString
            selectedUnit = preference.selectedUnit
            degreeUnitShowing = preference.degreeUnitShowing
        }
    }
}

#Preview {
    PreferenceView()
        .modelContainer(Preference.preview)
}
