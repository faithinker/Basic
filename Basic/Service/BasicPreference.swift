//
//  BasicPreference.swift
//  Basic
//
//  Created by pineone on 2021/09/02.
//

extension Preference {
    private static let suitePrefix = "AppName"

    static var device: Preference {
        return Preference.instance(suiteName: "\(suitePrefix).device")
    }

    static var user: Preference {
        return Preference.instance(suiteName: "\(suitePrefix).user")
    }
    
    static var inspect: Preference {
        return Preference.instance(suiteName: "\(suitePrefix).inspect")
    }
}

extension Preference.Key {
    static let Sample = Preference.Key("Sample")
}

