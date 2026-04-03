//
//  TodayWeatherSummaryService.swift
//  App
//
//  Created by Cursor on 4/2/26.
//

import Foundation

/// Open-Meteo 무료 API (키 없음). 기본 좌표는 서울 시청 부근.
enum TodayWeatherSummaryService {
    
    /// 말풍선용: 본문 + 탭 가능한 날씨 이모지 + 기온 꼬리
    struct WeatherDaySummary: Sendable {
        let dayPrefix: String
        let conditionBody: String
        let conditionEmoji: String
        let temperatureTail: String
        
        var fullLine: String {
            dayPrefix + conditionBody + conditionEmoji + temperatureTail
        }
    }
    
    private enum FetchError: Error {
        case invalidPayload
    }
    
    private static let seoulLatitude = 37.5665
    private static let seoulLongitude = 126.9780
    
    private struct ForecastResponse: Decodable {
        let daily: Daily?
        
        struct Daily: Decodable {
            let temperature2mMax: [Double]?
            let temperature2mMin: [Double]?
            let weathercode: [Int]?
            
            enum CodingKeys: String, CodingKey {
                case temperature2mMax = "temperature_2m_max"
                case temperature2mMin = "temperature_2m_min"
                case weathercode = "weather_code"
            }
        }
    }
    
    /// 한 줄 요약 (이모지·말투 포함)
    static func fetchSummary(
        latitude: Double = seoulLatitude,
        longitude: Double = seoulLongitude
    ) async throws -> String {
        try await fetchTodaySummary(latitude: latitude, longitude: longitude).fullLine
    }
    
    /// 오늘 요약 (이모지 탭 → 내일 등에 사용)
    static func fetchTodaySummary(
        latitude: Double = seoulLatitude,
        longitude: Double = seoulLongitude
    ) async throws -> WeatherDaySummary {
        try await fetchDaySummary(dayIndex: 0, latitude: latitude, longitude: longitude)
    }
    
    /// 내일 요약
    static func fetchTomorrowSummary(
        latitude: Double = seoulLatitude,
        longitude: Double = seoulLongitude
    ) async throws -> WeatherDaySummary {
        try await fetchDaySummary(dayIndex: 1, latitude: latitude, longitude: longitude)
    }
    
    private static func fetchDaySummary(
        dayIndex: Int,
        latitude: Double,
        longitude: Double
    ) async throws -> WeatherDaySummary {
        let days = max(2, dayIndex + 1)
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min,weather_code"),
            URLQueryItem(name: "timezone", value: "Asia/Seoul"),
            URLQueryItem(name: "forecast_days", value: String(days))
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
        guard let maxArr = decoded.daily?.temperature2mMax,
              let minArr = decoded.daily?.temperature2mMin,
              let codeArr = decoded.daily?.weathercode,
              dayIndex < maxArr.count,
              dayIndex < minArr.count,
              dayIndex < codeArr.count
        else {
            throw FetchError.invalidPayload
        }
        let maxRounded = Int(maxArr[dayIndex].rounded())
        let minRounded = Int(minArr[dayIndex].rounded())
        let code = codeArr[dayIndex]
        let (body, emoji) = koreanCondition(for: code)
        let dayWord = dayIndex == 0 ? "오늘은 " : "내일은 "
        let prefix = "\(dayWord)"
        let tail = "최고 🥵 \(maxRounded)° · 최저 🥶 \(minRounded)°"
        return WeatherDaySummary(
            dayPrefix: prefix,
            conditionBody: body,
            conditionEmoji: emoji,
            temperatureTail: tail
        )
    }
    
    /// WMO weather code (Open-Meteo) — 본문과 날씨 이모지(탭 영역) 분리
    private static func koreanCondition(for code: Int) -> (body: String, emoji: String) {
        switch code {
        case 0:
            return ("쨍쨍 맑아요 ", "☀️\n")
        case 1:
            return ("대체로 맑은 편이에요 ", "🌤️\n")
        case 2:
            return ("구름이 살짝 껴요 ", "⛅️\n")
        case 3:
            return ("흐린 날이에요 ", "☁️\n")
        case 45, 48:
            return ("안개가 자욱해요 ", "🌫️\n")
        case 51, 53, 55, 56, 57:
            return ("이슬비가 내려요 ", "🌦️\n")
        case 61, 63, 65, 66, 67:
            return ("비가 와요 우산 챙기기 ", "🌧️\n")
        case 71, 73, 75, 77:
            return ("눈이 내려요 ", "❄️\n")
        case 80, 81, 82:
            return ("소나기가 올 수 있어요 ", "🌦️\n")
        case 85, 86:
            return ("눈 소나기 조심 ", "❄️🌨️\n")
        case 95:
            return ("천둥번개가 있어요 ", "⚡️\n")
        case 96, 99:
            return ("우박·번개 조심해요 ", "⛈️\n")
        default:
            return ("살짝 흐려요 ", "☁️\n")
        }
    }
}
