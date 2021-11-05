//
//  Preference.swift
//  Basic
//
//  Created by pineone on 2021/09/02.
//

import Foundation

class Preference {
    struct Key {
        let rawValue: String

        init(_ key: String) {
            rawValue = key
        }
    }

    private let suiteName: String
    private var storage: [String: Any] = [:]
    private let preferenceURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent("Preference")

    private var fileURL: URL {
        return preferenceURL.appendingPathComponent("\(suiteName).plist")
    }

    fileprivate init(suiteName: String? = nil) {
        self.suiteName = suiteName ?? .empty
        if let storedData = NSDictionary(contentsOf: fileURL) as? [String: Any] {
            storage = storedData
        }
    }

    private func synchronize() {
        DispatchQueue.global(qos: .background).async {
            try! FileManager.default.createDirectory(at: self.preferenceURL, withIntermediateDirectories: true, attributes: nil)
            (self.storage as NSDictionary).write(to: self.fileURL, atomically: true)
        }
    }

    /// 설정 값을 저장합니다.
    ///
    /// - Parameter
    ///   - preference: 설정값
    ///   - key:        키
    func set(_ preference: Any, forKey key: Preference.Key) {
        storage[key.rawValue] = preference
        synchronize()
    }

    /// 설정 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    ///
    /// - Returns: 설정 값
    func any(_ key: Preference.Key) -> Any? {
        return storage[key.rawValue]
    }

    /// Bool 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Bool 값
    func bool(_ key: Preference.Key) -> Bool? {
        return storage[key.rawValue] as? Bool
    }

    /// Int 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Int 값
    func integer(_ key: Preference.Key) -> Int? {
        return storage[key.rawValue] as? Int
    }

    /// Float 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Float 값
    func float(_ key: Preference.Key) -> Float? {
        return storage[key.rawValue] as? Float
    }

    /// Double 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Double 값
    func double(_ key: Preference.Key) -> Double? {
        return storage[key.rawValue] as? Double
    }

    /// String 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: String 값
    func string(_ key: Preference.Key) -> String? {
        return storage[key.rawValue] as? String
    }

    /// Data 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Data 값
    func data(_ key: Preference.Key) -> Data? {
        return storage[key.rawValue] as? Data
    }

    /// [Any] 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: [Any] 값
    func array(_ key: Preference.Key) -> [Any]? {
        return storage[key.rawValue] as? [Any]
    }

    /// [String: Any] 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: [String: Any] 값
    func dictionary(_ key: Preference.Key) -> [String: Any]? {
        return storage[key.rawValue] as? [String: Any]
    }

    /// Date 타입의 값을 가져옵니다.
    ///
    /// - Parameter key: 키
    /// - Returns: Date 값
    func date(_ key: Preference.Key) -> Date? {
        return storage[key.rawValue] as? Date
    }

    /// 지정된 key의 값을 제거합니다.
    ///
    /// - Parameter key: 키
    @discardableResult
    func remove(forKey key: Preference.Key) -> Any? {
        let removedValue = storage.removeValue(forKey: key.rawValue)
        synchronize()
        return removedValue
    }

    /// 모든 값을 제거합니다.
    func clear() {
        storage.removeAll()
        synchronize()
    }
}

extension Preference {
    static let `default` = Preference()

    private static let cache = NSCache<NSString, Preference>()

    /// Preference 오브젝트를 가져옵니다.
    ///
    /// - Parameter suiteName: Preference의 identifier 입니다. nil이면 default 오브젝트가 반환됩니다.
    /// - Returns: Preference 오브젝트
    static func instance(suiteName: String) -> Preference {
        let cacheKey = suiteName as NSString
        guard let preference = cache.object(forKey: cacheKey) else {
            let preference = Preference(suiteName: suiteName)
            cache.setObject(preference, forKey: cacheKey)
            return preference
        }
        return preference
    }
}
