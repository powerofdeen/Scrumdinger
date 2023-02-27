//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by powerofdeen on 2023/01/18.
//

import Foundation
import SwiftUI

// ObservavleObject 프로토콜
class ScrumStore: ObservableObject {
    
    // @Published 속성 래퍼가 붙은 변수를 변경하면 뷰가 업데이트 됨
    @Published var scrums: [DailyScrum] = []
    
    // 스크럼 내용 저장
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("scrum.data")
    }
    
    // async / await 사용
    static func load() async throws -> [DailyScrum] {
        try await withCheckedThrowingContinuation{ continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                        
                }
            }
        }
    }
    
    // 이전 비동기 처리 방식
    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyScrum = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyScrum))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(scrums: [DailyScrum]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                }
            }
        }
    }
    
    // 이전 방식
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(scrums)
            let outfile = try fileURL()
            try data.write(to: outfile)
            DispatchQueue.main.async {
                completion(.success(scrums.count))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
