//
//  CircularProgressRowView.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import SwiftUI

struct CircularProgressRowView: View {
	let things: [Thing]
    var body: some View {
		HStack(alignment: .center){
			ForEach(things.filter({facilityNameByIdentifier($0.id, onlyKnown: true) != nil}).sorted(by: {$0.v.availableRatio! < $1.v.availableRatio!}).prefix(5)){thing in
				let r = thing.v.availableRatio!
				VStack{
					Gauge(value: r, label: {
						Text(String(format: "%.f%%", r*100))
						
					})
					.gaugeStyle(AccessoryCircularCapacityGaugeStyle())
					Text(facilityNameByIdentifier(thing.id)!.prefix(6))
						.font(.caption)
				}
					
//				ProgressView(value: r).progressViewStyle(.circular)
			}
		}.padding()
    }
}

struct CircularProgressRowView_Previews: PreviewProvider {
    static var previews: some View {
		CircularProgressRowView(things: samples.value.map{.init(id: $0.key, v: $0.value)}).frame(height: 150)
    }
}
