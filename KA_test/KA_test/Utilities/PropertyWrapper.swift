//
//  PropertyWrapper.swift
//  KA_test
//
//  Created by Pavel Bondar on 13.05.26.
//

import Foundation

@propertyWrapper
public struct UserDefaultsPropertyWrapper<Value: Codable> {

    private let key: String
    private let defaultValue: Value?

    init(key: String, defaultValue: Value?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value? {
        get { (UserDefaults.standard.object(forKey: key) as? Value) ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

}

@propertyWrapper
public struct UserDefaultsObjectWrapper<Value: Codable> {

    private let key: String
    private let defaultValue: Value?

    init(key: String, defaultValue: Value?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value? {
        get {
            if let storedData = UserDefaults.standard.data(forKey: key) {
                return try? JSONDecoder().decode(Value.self, from: storedData)
            } else {
                return defaultValue
            }
        } set {
            if let value = newValue, let encoded = try? JSONEncoder().encode(value) {
                UserDefaults.standard.set(encoded, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

}

@propertyWrapper
public struct UserDefaultsObjcArrayObjectWrapper<Value: NSObject&Codable> {

    private let key: String
    private let defaultValue: [Value]?

    init(key: String, defaultValue: [Value]?) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: [Value]? {
        get {
            if let storedData = UserDefaults.standard.data(forKey: key) {
                return try? JSONDecoder().decode([Value].self, from: storedData)
            } else {
                return defaultValue
            }
        } set {
            
            if let value = newValue,
               let encoded = try? JSONEncoder().encode(value) {
                
                UserDefaults.standard.set(encoded, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

}

