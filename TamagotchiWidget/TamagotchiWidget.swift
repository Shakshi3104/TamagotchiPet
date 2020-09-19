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
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), stomachMeter: self.meterMax, socialMeter: self.meterMax)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, stomachMeter: Int(self.meterMax * (5 - hourOffset) / 5), socialMeter: Int(self.meterMax * (5 - hourOffset) / 5))
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
}

struct TamagotchiWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Color.white.edgesIgnoringSafeArea(.all).overlay(Group {
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
            }
            HStack {
                Image(systemName: "triangle")
                    .foregroundColor(.orange)
                Text("\(entry.stomachMeter)%")
                    .foregroundColor(.orange)
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

struct TamagotchiWidget_Previews: PreviewProvider {
    static var previews: some View {
        TamagotchiWidgetEntryView(entry: SimpleEntry(date: Date(), stomachMeter: 100, socialMeter: 100))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
