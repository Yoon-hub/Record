//
//  SubwayStationView.swift
//  App
//
//  Created by 윤제 on 3/18/25.
//

import SwiftUI

import Core

struct SubwayStationView: View {
    
    @State private var list: [String] = UserDefaultsWrapper.stations
    
    @State private var showPopup = false
    
    var body: some View {
        VStack {
            List {
                ForEach(list, id: \.self) { item in
                    NavigationLink(destination: SubwayView(selectedStation: item)) {
                        Text(item)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete(perform: delete)
             
                Section() {
                    addButton
                        .listRowBackground(Color.clear)
                }
                .listRowSeparator(.hidden)
                
            }
            .padding(.leading, 12)
            .listStyle(.plain)
        }
        .navigationTitle("지하철역")
        .fullScreenCover(isPresented: $showPopup) {
            SubwayStationAddView(subwayStationViewStations: $list)
        }
    }
    
    // Method to handle deletion
    private func delete(at offsets: IndexSet) {
        list.remove(atOffsets: offsets)
        UserDefaultsWrapper.stations = list
    }
    
    // + 버튼
    private var addButton: some View {
        Button(action: {
            showPopup.toggle()
        }) {
            HStack {
                Spacer() // 좌측 공간
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Spacer() // 우측 공간
            }
            .padding(.horizontal) // 좌우 여백
        }
    }
}
