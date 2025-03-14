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
    
    let disposBag = DisposeBag()
    
    var body: some View {
        
        GeometryReader { proxy in
            List(items, id: \.self) { item in
                
                let arriveTimes = item.barvDt.forEach {
                    Int($0) ?? 0 / 600
                }
                
                
                SubwayCellView(
                    arrivalTimes: arriveTimes,
                    curretStation: <#String#>,
                    nextStation: <#String#>,
                    subwayId: <#String#>
                )
                    .listRowSeparator(.hidden)
               }
            .listStyle(.plain)
        }
        .onAppear {
            fetchData()
        }
    }
}

extension SubwayView {
    private func fetchData() {
        let subWayAPIsWorker = SubwayAPIs.Worker()
        
        subWayAPIsWorker.fetchSubway(station: "신대방")
            .subscribe { dto in
                switch dto {
                case .success(let dto):
                    
                    self.items.removeAll()
                   
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
                            
                            // 이미 존재하면 barvDt 배열에 새로운 값 추가
                            self.items[index].barvDt.append(realtimeArrival.barvlDt)
                        } else {
                            
                            // 존재하지 않으면 새로운 객체 추가
                            self.items.append(arriveInfo)
                        }
                    }
                    
                    print(self.items)
                    
                case .failure:
                    print("실패")
                }
            }
            .disposed(by: disposBag)
            
    }
}

#Preview {
    SubwayView()
}
