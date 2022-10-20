//
//  CL_Widget.swift
//  CL_Widget
//
//  Created by Andreas Loizides on 20/10/2022.
//

import WidgetKit
import SwiftUI
import Intents
var lastUpdateTime = Date()
struct Provider: TimelineProvider {
	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
		let entry = SimpleEntry(date: Date(), vm: .init())
		completion(entry)
	}
	let vm = VM()
	func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
		let differenceInSeconds = Int(Date().timeIntervalSince(lastUpdateTime))
		if differenceInSeconds < 5 {
			Task{
				// testing to see how often this gets hit. remove before release.
				print("Fetching stats")
				guard let new = await Response.getFromSite() else {return}
				vm.things = new.value.map{.init(id: $0.key, v: $0.value)}
				let entry = SimpleEntry(date: Date(), vm: vm)
				// make sure that we get refreshed
				// to be really usefull to the user it would be better to do this more like
				// every 15 minutes. But, that would be more api calls per day than we get
				let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
				let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
				completion(timeline)
			}
		}
		lastUpdateTime = Date()
		var entries: [SimpleEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, vm: .init())
			entries.append(entry)
		}

		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
	
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), vm: .init())
    }


   
}
class VM: ObservableObject{
	@Published var things: [Thing]
	init(){things=samples.value.map{.init(id: $0.key, v: $0.value)}}
	func update(){
		Task{
			guard let s = await Response.getFromSite() else{return}
			withAnimation{
				self.things = s.value.map{.init(id: $0.key, v: $0.value)}
			}
		}
	}
}
struct SimpleEntry: TimelineEntry {
    let date: Date
	let vm: VM
}

struct CL_WidgetEntryView : View {
	
    var entry: SimpleEntry
    var body: some View {
		VStack{
			Text(entry.date, style: .relative)
			ForEach(entry.vm.things.filter({facilityNameByIdentifier($0.id, onlyKnown: true) != nil}).sorted(by: {$0.v.availableRatio!  < $1.v.availableRatio!})){thing in
				HStack{
					Text(facilityNameByIdentifier(thing.id)!)
						.font(.caption2)
					let ratio = thing.v.availableRatio
					Spacer()
					ProgressView(value: ratio)
					if let ratio=ratio{
						Text(String(format: "%.f %%", ratio*100))
					}
				}.font(.footnote)
			}
		}.padding()
    }
}

struct CL_Widget: Widget {
    let kind: String = "CL_Widget"

    var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider(), content: {entry in
			CL_WidgetEntryView(entry: entry)
		})
        .configurationDisplayName("CloudLab Status")
        .description("CloudLab facilities status")
    }
}

struct CL_Widget_Previews: PreviewProvider {
    static var previews: some View {
        CL_WidgetEntryView(entry: SimpleEntry(date: Date(), vm: .init()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
		CL_WidgetEntryView(entry: SimpleEntry(date: Date(), vm: .init()))
			.previewContext(WidgetPreviewContext(family: .systemMedium))
		CL_WidgetEntryView(entry: SimpleEntry(date: Date(), vm: .init()))
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
