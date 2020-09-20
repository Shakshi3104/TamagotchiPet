//
//  TamagotchiCharactor.swift
//  TamagotchiPet
//
//  Created by MacBook Pro on 2020/09/20.
//

import Foundation

// 性別
enum Gender: String {
    case male = "♂"
    case female = "♀"
}

// バロメータの最大値
public let BAROMETER_MAX = 5

struct TamagotchiBarometer: Codable {
    var age: Int
    var stomachMeter: Int
    var socialMeter: Int
    
    init(age: Int, stomachMeter: Int, socialMeter: Int) {
        self.age = age
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
    }
    
    // 年齢を1増やす
    mutating func increaseAge() -> Int {
        self.age += 1
        return self.age
    }
    
    // おなかメータを1減らす
    mutating func reduceStomachMeter() -> Int {
        if self.stomachMeter - 1 != 0 {
            self.stomachMeter -= 1
        }
        
        return self.stomachMeter
    }
    
    // なかよしメータを1減らす
    mutating func reduceSocialMeter() -> Int{
        if self.socialMeter - 1 != 0 {
            self.socialMeter -= 1
        }
        
        return self.socialMeter
    }
    
    mutating func fullStomachMeter() -> Int {
        self.stomachMeter = BAROMETER_MAX
        
        return self.stomachMeter
    }
    
    mutating func fullSocialMeter() -> Int {
        self.socialMeter = BAROMETER_MAX
        
        return self.socialMeter
    }
}

// たまごっちクラス
class Tamagotchi: ObservableObject {
    let name: String
    let gender: Gender
    @Published var age: Int
    
    @Published var stomachMeter: Int
    @Published var socialMeter: Int
    
    let imageName: String
    
    init(name: String, gender: Gender, age: Int, stomachMeter: Int, socialMeter: Int, imageName: String) {
        self.name = name
        self.gender = gender
        self.age = age
        
        self.stomachMeter = stomachMeter
        self.socialMeter = socialMeter
        
        self.imageName = imageName
    }
    
    convenience init(name: String, gender: Gender, age: Int, imageName: String) {
        self.init(name: name, gender: gender, age: age, stomachMeter: BAROMETER_MAX, socialMeter: BAROMETER_MAX, imageName: imageName)
    }
    
    // 年齢を1増やす
    func increaseAge() {
        self.age += 1
    }
    
    // おなかメータを1減らす
    func reduceStomachMeter() {
        
        if self.stomachMeter - 1 != 0 {
            self.stomachMeter -= 1
        }
    }
    
    // なかよしメータを1減らす
    func reduceSocialMeter() {
        if self.socialMeter - 1 != 0 {
            self.socialMeter -= 1
        }
    }
    
    func fullStomachMeter() {
        self.stomachMeter = BAROMETER_MAX
    }
    
    func fullSocialMeter() {
        self.socialMeter = BAROMETER_MAX
    }
}
