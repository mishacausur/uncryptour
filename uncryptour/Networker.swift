//
//  Networker.swift
//  uncryptour
//
//  Created by Misha Causur on 29.03.2022.
//

import Foundation
import Combine

struct Networker {
    static let chared = Networker()
    let decoder = JSONDecoder()

    func fetchData(_ url: String) -> AnyPublisher<String, Error> {
        URLSession.shared
            .dataTaskPublisher(for: URL(string: url)!)
            .map(\.data)
            .decode(type: String.self, decoder: decoder)
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    func loadData() async throws -> String {
        try await Task.retrying {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "")!)
            return try decoder.decode(String.self, from: data)
        }
        .value
    }
    
}

extension Task where Failure == Error {
    @discardableResult
    static func retrying(
        priority: TaskPriority? = nil,
        maxRetyingCount: Int = 3,
        retryDelay: TimeInterval = 1,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for _ in 0..<maxRetyingCount {
                do {
                    return try await operation()
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delay = UInt64(oneSecond * retryDelay)
                    try await Task<Never, Never>.sleep(nanoseconds: delay)
                    
                    continue
                }
            }
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
