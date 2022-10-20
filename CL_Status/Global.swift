//
//  Global.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import Foundation
import ActivityKit
let decoder = JSONDecoder()
var liveActivity: Activity<CL_WidgetAttributes>? = nil
func decodeLocal<T: Decodable>(name: String, type: T.Type)->T?{
	let url = Bundle.main.url(forResource: name, withExtension: "json")!
	guard let data = try? Data(contentsOf: url) else {print("Could not get data of url "+url.absoluteString);return nil}
	do{
		let decoded = try decoder.decode(T.self, from: data)
		return decoded
	}catch{
		print("Could not decode \(url.pathComponents.last!)! error: \(error)")
		return nil
	}
	
}
typealias Thing = FacilitiesListStatusView.FacilitiesStats
class User: ObservableObject{
	static let current  = User()
	struct UserState{
		var alertTitle = ""
		var hasAlert = false
		var alertMsg = ""
	}
	@Published var info: UserState = .init()
}
func reportError(title: String, _ msg: String){
	User.current.info.alertTitle=title
	User.current.info.alertMsg=msg
	User.current.info.hasAlert=true
}
