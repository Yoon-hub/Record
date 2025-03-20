//
//  SubwayStationAddView.swift
//  App
//
//  Created by 윤제 on 3/20/25.
//

import SwiftUI

import Core

struct SubwayStationAddView: View {
    
    /// searchText
    @State private var searchText = ""
    
    /// Json 데이터 로 부터 가져온 역정보
    @State var stationsInfo: [Station] = []
    
    /// 검색 된 역정보 list
    @State var searchedStations: [Station] = []
    
    /// ✅ 선택한 역 저장
    @State private var selectedStation: Station?
    
    /// Alert
    @State private var showAlert = false
    
    /// 닫기 할때 쓰는 property
    @Environment(\.dismiss) private var dismiss
    
    /// SubwaStation View 리스트 업데이틑 위해 추가
    @Binding var subwayStationViewStations: [String]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                
                CustomSearchBar(text: $searchText)
            }
            
            Spacer()
            
            List {
                ForEach(searchedStations, id: \.self) { station in
                    HStack {
                        Text(station.station)
                        Spacer() // 셀 전체를 확장하도록 추가
                    }
                    .contentShape(Rectangle()) // ✅ 터치 영역 확장
                    .onTapGesture {
                        selectedStation = station  // ✅ 선택한 역 저장
                        showAlert = true  // ✅ 알림 표시
                    }
                }
                .alert(isPresented: $showAlert) {
                    var stations = UserDefaultsWrapper.stations
                    let contains = stations.contains(selectedStation?.station ?? "")
                    
                    if contains {
                        return Alert(title: Text("알림"), message: Text("이미 추가된 역입니다."), dismissButton: .default(Text("확인")))
                        
                    } else {
                        return Alert(
                            title: Text("알림"),
                            message: Text("\(selectedStation?.station ?? "")을 추가하시겠습니까?"),
                            primaryButton: .default(Text("확인"), action: {

                                // 역 추가
                                stations.append(selectedStation?.station ?? "")
                                UserDefaultsWrapper.stations = stations
                                
                                subwayStationViewStations = stations
                                
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                }
            }
            .listStyle(.plain)
        }
        .onAppear {
            stationsInfo = loadStations(from: "subwayStation") ?? []
            
            // 중복 방지
            // ex) 을지로4가 2호선, 을지로4가 5호선
            stationsInfo = Array(Dictionary(grouping: stationsInfo, by: \.station).values.map { $0.first! })
        }
        .onChange(of: searchText) { oldValue, newValue in
            searchedStations = stationsInfo.filter { $0.station.contains(searchText) }
        }
        .padding(.horizontal, 20)
    }
    
    /// Subway Station JSON 파일을 통해서 역 정보 가져오기
    func loadStations(from filename: String) -> [Station]? {
        // JSON 파일을 bundle에서 가져오기
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return nil
        }
        
        do {
            // 파일에서 JSON 데이터 읽기
            let data = try Data(contentsOf: url)
            
            // JSON을 Codable 객체로 디코딩
            let decoder = JSONDecoder()
            let stations = try decoder.decode([Station].self, from: data)
            
            return stations
        } catch {
            print("JSON 디코딩 실패: \(error)")
            return nil
        }
    }
}

struct CustomSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("지하철역 검색", text: $text)
                .focused($isFocused)
                .padding(8)
                .background(Color.clear)
                .onSubmit {
                    print("검색 실행: \(text)")
                }

            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .frame(height: 40)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
