//
//  TamagotchiWidget.swift
//  TamagotchiWidget
//
//  Created by MacBook Pro on 2020/09/19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let meterMax = 100
    
    // バロメータを保存する
    @AppStorage("Barometer", store: UserDefaults(suiteName: "group.com.Xer.TamagotchiPet"))
    var tamagotchiBarometer: Data = Data()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry: SimpleEntry
        
        if let decodeData = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) {
            entry = SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, barometer: decodeData)
        }
        else {
            entry = SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5))
        }
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            var entry: SimpleEntry
            var barometer: TamagotchiBarometer = TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5)
            
            if let decodeData = try? JSONDecoder().decode(TamagotchiBarometer.self, from: tamagotchiBarometer) {
                
                do {
                    barometer = try TamagotchiBarometer(from: decodeData as! Decoder)
                }
                catch let error as NSError{
                            print("Failure to Write File\n\(error)")
                }
            }
            else {
                return
            }
            
            // バロメータを減らす
            let social = barometer.reduceSocialMeter()
            let stomach = barometer.reduceStomachMeter()
            
            entry = SimpleEntry(date: entryDate,
                                stomachMeter: Int(self.meterMax * (social / BAROMETER_MAX)),
                                socialMeter: Int(self.meterMax * (stomach / BAROMETER_MAX)),
                                barometer: barometer)
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let stomachMeter: Int
    let socialMeter: Int
    let barometer: TamagotchiBarometer
}

// 実際に表示される画面
struct TamagotchiWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Color(red: 0.949, green: 0.949, blue: 0.949).edgesIgnoringSafeArea(.all).overlay(Group {
        VStack {
            Text(entry.date, style: .time)
                .foregroundColor(.black)
            Image("mametchi")
                .resizable()
                .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("\(entry.socialMeter)%")
                    .foregroundColor(.pink)
                    .font(.system(.body, design: .rounded))
            }
            HStack {
                Image(systemName: "triangle")
                    .foregroundColor(.orange)
                Text("\(entry.stomachMeter)%")
                    .foregroundColor(.orange)
                    .font(.system(.body, design: .rounded))
            }
        }
        })
    }
}

@main
struct TamagotchiWidget: Widget {
    let kind: String = "TamagotchiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TamagotchiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tamagotchi Widget")
        .description("This is Tamagotchi widget.")
    }
}

// プレビューに必要
struct TamagotchiWidget_Previews: PreviewProvider {
    static var previews: some View {
        TamagotchiWidgetEntryView(entry: SimpleEntry(date: Date(), stomachMeter: 100, socialMeter: 100, barometer: TamagotchiBarometer(age: 3, stomachMeter: 5, socialMeter: 5)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
