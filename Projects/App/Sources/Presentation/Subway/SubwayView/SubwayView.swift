//
//  SubwayView.swift
//  App
//
//  Created by 윤제 on 3/10/25.
//

import SwiftUI

import Data

import RxSwift

struct SubwayView: View {
    
    @State var items: [ArriveInfo] = []
    @State var stations: [Station] = []
    
    let selectedStation: String
    
    let disposBag = DisposeBag()
    
    var body: some View {
        
        GeometryReader { proxy in
            List(items, id: \.self) { item in
                
                let arriveTimes = item.barvDt.compactMap { Int($0) }
                let currentStation = stations.filter { $0.code == item.statnId }.first?.station ?? ""
                let nextStation = stations.filter { $0.code == item.statnTid}.first?.station ?? ""
                
                let subwayId = item.subWayId
                 
                SubwayCellView(
                    arrivalTimes: arriveTimes,
                    curretStation: currentStation,
                    nextStation: nextStation,
                    subwayId: subwayId
                )
                    .listRowSeparator(.hidden)
               }
            .listStyle(.plain)
            .refreshable {   // ✅ 새로고침 기능 추가
                 fetchData()
             }
        }
        .onAppear {
            fetchData()
        }
        .navigationTitle(selectedStation)
    }
}

extension SubwayView {
    private func fetchData() {
        let subWayAPIsWorker = SubwayAPIs.Worker()
        
        stations = loadStations(from: "subwayStation") ?? []
        
        self.items.removeAll()
        
        [selectedStation].forEach {
            subWayAPIsWorker.fetchSubway(station: $0)
                .catchAndReturn(nil)
                .subscribe { dto in
                    switch dto {
                    case .success(let dto):
                       
                        /// 지하철 도착 정보
                        dto?.realtimeArrivalList.forEach { realtimeArrival in
                            
                            let arriveInfo = ArriveInfo(
                                statnFid: realtimeArrival.statnFid,
                                statnTid: realtimeArrival.statnTid,
                                statnId: realtimeArrival.statnId,
                                subWayId: realtimeArrival.subwayId,
                                barvDt: [realtimeArrival.barvlDt]
                            )
                            
                            if let index = self.items.firstIndex(where: { $0 == arriveInfo }) {
                                // 이미 존재하면 barvDt 배열에 추가
                                self.items[index].barvDt.append(realtimeArrival.barvlDt)
                            } else {
                                // 존재하지 않으면 추가
                                items.append(arriveInfo)
                            }
                        }
                        
                        items.sort { $0.subWayId < $1.subWayId }
                        
                    case .failure:
                        print("실패")
                    }
                }
                .disposed(by: disposBag)
        }
        
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

struct Station: Codable, Hashable {
    let code: String
    let station: String
    let line: String
}
