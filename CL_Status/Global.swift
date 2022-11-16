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
extension CodingKey{
	var asString: String{
		if let int = intValue{
			return "int: \(int)"
		}else{
			return stringValue
		}
	}
}
func jsonString(data: Data)->String?{
	return String(data: data, encoding: .utf8)
}
func reportError(title: String, _ error: Error, jsonData: Data? = nil){
	var msg: String?
	if let dec = error as? DecodingError{
		var title: String
		var theContext: DecodingError.Context?
		
		switch dec {
		case .typeMismatch(let any, let context):
			title="Type mismatch for \(any)"
			theContext=context
		case .valueNotFound(let any, let context):
			title="Value not found for \(any)"
			theContext=context
		case .keyNotFound(let codingKey, let context):
			title="Key not found for \(codingKey.asString)"
			theContext=context
		case .dataCorrupted(let context):
			title="Data corrupted"
			theContext=context
		@unknown default:
			title = "Unknown error"
		}
		if let context=theContext{
			let description = context.debugDescription
			let path = context.codingPath.map{$0.asString}.joined(separator: ":")
			let dataString = jsonData != nil ? jsonString(data: jsonData!) : nil
			msg = [
				title,
				description,
				"path: "+path,
				"data: "+(dataString ?? "non utf8!")
			].joined(separator: ". ")
		}
		
	}
	User.current.info.alertTitle=title
	User.current.info.alertMsg=msg ?? "non-decoding error: \(error)"
	User.current.info.hasAlert=true
}
