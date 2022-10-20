//
//  APIMethods.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import Foundation
extension Response{
	static func getFromSite()async->Self?{
		let url: URL = .init(string: "https://cloudlab.us/server-ajax.php?ajax_args[]=noargs&ajax_method=GetHealthStatus&ajax_route=frontpage")!
		do{
			let (data, _) = try await URLSession.shared.data(from: url)
			do{
				let decoded = try decoder.decode(Self.self, from: data)
				return decoded
			}catch{
				reportError(title: "Decoding error", "\(error)")
			}
		}catch{
			reportError(title: "Retrieving error", "\(error)")
		}
		return nil
	}
}
