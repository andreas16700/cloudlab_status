//
//  FacilitiesListStatusView.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import SwiftUI

struct FacilitiesListStatusView: View {
	init(response: Response){
		self.stats = response.value.map{.init(id: $0.key, v: $0.value)}
	}
	init(stats: [FacilitiesListStatusView.FacilitiesStats]) {
		self.stats = stats
	}
	
	struct FacilitiesStats: Identifiable, Comparable, Hashable, Codable{
		static func < (lhs: FacilitiesListStatusView.FacilitiesStats, rhs: FacilitiesListStatusView.FacilitiesStats) -> Bool {
			facilityNameByIdentifier(lhs.id) ?? lhs.id < facilityNameByIdentifier(rhs.id) ?? rhs.id
		}
		
		static func == (lhs: FacilitiesListStatusView.FacilitiesStats, rhs: FacilitiesListStatusView.FacilitiesStats) -> Bool {
			lhs.id == rhs.id
		}
		
		let id: String
		let v: Value
	}
	let stats: [FacilitiesStats]
	@State private var onlyKnown: Bool = true
    var body: some View {
		VStack {
			Toggle("Only known", isOn: $onlyKnown)
			List(stats.filter({facilityNameByIdentifier($0.id, onlyKnown: onlyKnown) != nil}).sorted(by: {$0.v.availableRatio! < $1.v.availableRatio!})){stat in
				FacilityStatusRowView(id: stat.id, thing: stat.v)
			}.navigationTitle(.init(verbatim: "CloudLab Usage"))
		}
    }
}

struct FacilitiesListStatusView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView{
			FacilitiesListStatusView(stats: samples.value.map{FacilitiesListStatusView.FacilitiesStats(id: $0.key, v: $0.value)})
		}
    }
}
