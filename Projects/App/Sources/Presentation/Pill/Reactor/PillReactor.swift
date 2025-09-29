//
//  PillReactor.swift
//  App
//
//  Created by 윤제 on 11/21/24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class PillReactor: Reactor {
    
    enum Action {
        case addPill(String, String)
        case viewDidload
        case deletePill(IndexPath)
        case switchTap(Int)
    }
    
    enum Mutation {
        case showAlert(String)
        case setPills([Pill])
        case appendPill(Pill)
        case removePill(IndexPath)
    }
    
    struct State {
        @Pulse var isAlert: String = ""
        var pills: [Pill] = []
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    @Injected var savePillUsecase: SavePillUsecaseProtocol
    @Injected var fetchPillUsecase: FetchPillUsecaseProtocol
    @Injected var deletePillUsecase: DeletePillUsecaseProtocol
    
}

// MARK: - Mutation
extension PillReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .deletePill(let index):
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    let pill = self.currentState.pills[index.row]
                    await self.deletePillUsecase.execute(event: pill)
                    observer.onNext(.removePill(index))
                    LocalPushService.shared.removeNotification(identifiers: [pill.id]) // 노티 삭제
                }
                return Disposables.create()
            }
            
        case .viewDidload:
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                Task {
                    // 알림 권한 확인
                    let result = await LocalPushService.shared.requestAuthorization()
                }
                Task {

                    let pills = await self.fetchPillUsecase.execute()
                    observer.onNext(.setPills(pills))
                }
                return Disposables.create()
            }
        case .addPill(let pill, let time):
            return Observable.create { [weak self] observer in
                guard let self else { return Disposables.create() }
                
                // 시간 형식 틀리면
                if !self.isValidTimeFormat(time) {
                    observer.onNext(.showAlert("올바른 시간을 입력해 주세요."))
                    return Disposables.create()
                }
                
                Task {
                    let pill = Pill(title: pill, time: time, use: true)
                    await self.savePillUsecase.excecute(event: pill)
                    observer.onNext(.appendPill(pill))
                    self.setPushService(pill) // 노티 추가
                }
                return Disposables.create()
            }
        case .switchTap(let indexPath):
            let pill = self.currentState.pills[indexPath]
            pill.use.toggle()
            self.setPushService(pill)
            return .empty()
        }
    }
    
    func reduce(
        state: State,
        mutation: Mutation
    ) -> State {
        var newState = state
        
        switch mutation {
        case .showAlert(let message):
            newState.isAlert = message
        case .setPills(let pills):
            newState.pills = pills
        case .appendPill(let pill):
            newState.pills.append(pill)
        case .removePill(let index):
            newState.pills.remove(at: index.row)
        }
        
        return newState
    }
}

// MARK: -
extension PillReactor {
    
    private func isValidTimeFormat(_ time: String) -> Bool {
        // 정규식: 네 자리 숫자, 앞 두 자리는 00~23, 뒤 두 자리는 00~59
        let timeRegex = "^(?:[01][0-9]|2[0-3])[0-5][0-9]$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", timeRegex)
        return predicate.evaluate(with: time)
    }
    
    
    /// 앱스토어 배포 시 수정해야 할 부분
    private func setPushService(_ pill: Pill) {
        
        let (hour, time) = convertTimeStringToHourMinute(time: pill.time)!
        
        if pill.use {
            LocalPushService.shared.addRepeatingNotification(
                identifier: pill.id,
                title: "알약 알림",
                body: "\(pill.title) 먹을 시간이야!",
                hour: hour,
                minute: time
            )
        } else {
            LocalPushService.shared.removeNotification(identifiers: [pill.id])
        }
    }
    
    private func convertTimeStringToHourMinute(time: String) -> (hour: Int, minute: Int)? {
        // 입력 문자열이 4자리인지 확인
        guard time.count == 4 else { return nil }
        
    
        guard let hour = Int(time.prefix(2)),
              let minute = Int(time.suffix(2)),
              (0...23).contains(hour),
              (0...59).contains(minute)
        else { return nil }
        
        return (hour, minute)
    }

}
