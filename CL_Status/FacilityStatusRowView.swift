//
//  FacilityStatusRowView.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import SwiftUI

struct FacilityStatusRowView: View {
	init(id: String, thing: Value) {
		self.id = id
		self.thing = thing
	}
	
	let id: String
	var name: String?{
		facilityNameByIdentifier(id)
	}
	let thing: Value
	var body: some View {
		VStack {
			HStack{
				Text(name ?? id)
//				ProgressView(value: thing.availableRatio)
//					.foregroundColor(.blue)
				if let ratio = thing.availableRatio{
					CustomProgressView(progress: ratio)
						.frame(height: 12)
						.foregroundColor(.blue)
					Text(String(format: "%.2f %%", ratio*100))
				}
			}
		}
		.padding()
	}
}

struct FacilityStatusRowView_Previews: PreviewProvider {
    static var previews: some View {
		let first = samples.value.first!
        FacilityStatusRowView(id: first.key, thing: first.value)
    }
}
