//
//  ContentView.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
	typealias FacStats = FacilitiesListStatusView.FacilitiesStats
	@ObservedObject var user = User.current
	@State private var stats: [FacStats]? = []
	let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
	@State private var lastUpdated: Date? = nil
    var body: some View {
		NavigationView{
			VStack {
				if let lastUpdated=lastUpdated{
					HStack{
						Text("Last updated")
						Text(lastUpdated, style: .relative)
						Text("ago")
					}
				}
				if let stats=stats{
					FacilitiesListStatusView(stats: stats)
						.refreshable(action: refreshData)
						.toolbar{
							ToolbarItem(placement: .navigationBarTrailing){
								AsyncButton(action: refreshData){
									Text("Refresh")
								}
							}
						}
						
				}
				if let liveActivity=liveActivity{
					Button(action: {stopLiveActivity(liveActivity)}, label: {
						Text("Stop Live Activity")
					})
				}else{
					Button(action: startLiveActivity, label: {
						Text("Start Live Activity")
					})
				}
			}
			.padding()
			.alert(Text(user.info.alertTitle), isPresented: $user.info.hasAlert, actions: {Text("Ok")})
			.onReceive(timer){_ in
				Task{
					await refreshData()
					let up = Date()
					DispatchQueue.main.async {
						withAnimation{self.lastUpdated = up}
					}
				}
			}
		}
		
    }
	func stopLiveActivity(_ a: Activity<CL_WidgetAttributes>){
		Task{
			await a.end(using:nil, dismissalPolicy: .immediate)
		}
	}
	func startLiveActivity(){
		if let liveActivity=liveActivity{stopLiveActivity(liveActivity);return}
		let initialContentState = CL_WidgetAttributes.ContentState(things: samples.value.map{.init(id: $0.key, v: $0.value)}.filter{facilityNameByIdentifier($0.id, onlyKnown: true) != nil})
		let activityAttributes = CL_WidgetAttributes(name: "d")

		do {
			liveActivity = try Activity.request(attributes: activityAttributes, contentState: initialContentState, pushType: nil)
			print("Requested a pizza delivery Live Activity \(String(describing: liveActivity?.id)).")
		} catch (let error) {
			print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
		}
	}
	@Sendable
	func refreshData()async{
		if let new = await Response.getFromSite(){
			DispatchQueue.main.async {
				if let liveActivity=liveActivity{updateLiveActivity(liveActivity, with: new.value.map{.init(id: $0.key, v: $0.value)})}
				withAnimation{
					let newStuff: [FacStats] = new.value.map{.init(id: $0.key, v: $0.value)}
					newStuff.forEach{stat in
						if let index = self.stats?.firstIndex(where: {$0.id==stat.id}){
							self.stats![index]=stat
						}else{
							if self.stats == nil {self.stats = .init()}
							self.stats?.append(stat)
						}
					}
				}
			}
		}
	}
}
func updateLiveActivity(_ a: Activity<CL_WidgetAttributes>, with: [Thing]){
	Task{
		await a.update(using: .init(things: with.filter({facilityNameByIdentifier($0.id, onlyKnown: true) != nil})))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
