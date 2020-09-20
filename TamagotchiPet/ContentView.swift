//
//  ContentView.swift
//  TamagotchiPet
//
//  Created by MacBook Pro on 2020/09/19.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var tamagotchi: Tamagotchi
    
    // バロメータを保存する
    @AppStorage("Barometer", store: UserDefaults(suiteName: "group.com.Xer.TamagotchiPet"))
    var tamagotchiBarometer: Data = Data()
    
    init() {
        self.tamagotchi = Tamagotchi(name: "まめっち", gender: .male, age: 1, stomachMeter: 0, socialMeter: 0, imageName: "mametchi")
        
        guard let _ = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) else {
            storeBarometer(with: TamagotchiBarometer(age: self.tamagotchi.age,
                                                     stomachMeter: self.tamagotchi.stomachMeter,
                                                     socialMeter: self.tamagotchi.socialMeter))
            return
        }
    }
    
    var body: some View {
        VStack {
            // たまごっちのプロフィール
            HStack {
                Image(tamagotchi.imageName).resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                Spacer()
                VStack(alignment:.leading) {
                    Text(tamagotchi.name)
                    // オスとメスで色を変える
                    Text("\(tamagotchi.gender.rawValue)").foregroundColor(tamagotchi.gender == .male ? .blue : .pink)
                    Text("\(tamagotchi.age) 才")
                }
            }.padding(.horizontal, 70)
            .padding(.vertical, 50)
            
            // バロメータ表示部分
            VStack {
                HStack {
                    Text("ごきげん")
                    Spacer()
                    HStack {
                        ForEach(0..<tamagotchi.socialMeter, id:\.self) {_ in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                        }
                        ForEach(0..<BAROMETER_MAX - tamagotchi.socialMeter, id:\.self) {_ in
                            Image(systemName: "heart")
                                .foregroundColor(.pink)
                        }
                    }
                }.padding(.horizontal, 50)
                .padding(.vertical, 5)
                
                HStack {
                    Text("おなか")
                    Spacer()
                    HStack {
                        ForEach(0..<tamagotchi.stomachMeter, id:\.self) {_ in
                            Image(systemName: "triangle.fill")
                                .foregroundColor(.orange)
                        }
                        ForEach(0..<BAROMETER_MAX - tamagotchi.stomachMeter, id:\.self) {_ in
                            Image(systemName: "triangle")
                                .foregroundColor(.orange)
                        }
                    }
                }.padding(.horizontal, 50)
                .padding(.vertical, 5)
            }
            
            // ボタン
            HStack {
                Button(action: {
                    // あそぶ
                    tamagotchi.fullSocialMeter()
                }, label: {
                    Text("あそぶ")
                })
                
                Button(action: {
                    // ごはんをあげる
                    tamagotchi.fullStomachMeter()
                }, label: {
                    Text("ごはん")
                    
                })
            }
        }
    }
    
    // UserDefultsに保存する
    func storeBarometer(with barometer: TamagotchiBarometer) {
        guard let encodeData = try? JSONEncoder().encode(barometer) else {
            return
        }
        self.tamagotchiBarometer = encodeData
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
