//
//  APITypes.swift
//  CL_Status
//
//  Created by Andreas Loizides on 20/10/2022.
//

import Foundation
// MARK: - Response
struct Response: Codable {
	let code: Int
	let value: [String: Value]
}

// MARK: - Value
struct Value: Codable, Hashable {
	let rawPCSAvailable, rawPCSTotal, vMSAvailable, vMSTotal: String
	let health: Int
	let status: Status
	
	var availableRatio: Double?{
		guard let rawAvail = Int(rawPCSAvailable), let rawTotal = Int(rawPCSTotal) else {return nil}
		return Double(rawTotal-rawAvail)/Double(rawTotal)
	}

	enum CodingKeys: String, CodingKey {
		case rawPCSAvailable = "rawPCsAvailable"
		case rawPCSTotal = "rawPCsTotal"
		case vMSAvailable = "VMsAvailable"
		case vMSTotal = "VMsTotal"
		case health, status
	}
}

enum Status: String, Codable, Hashable {
	case success = "SUCCESS"
}
func facilityNameByIdentifier(_ id: String, onlyKnown: Bool = false)->String?{
	if let name = facilityNameByIdentifierDict[id] {return name.capitalized}
	if onlyKnown {return nil}
	let s = id.components(separatedBy: "IDN+").last?.components(separatedBy: "+authority+").first
	return s ?? nil
}
let facilityNameByIdentifierDict = [
	"urn:publicid:IDN+utah.cloudlab.us+authority+cm" : "utah",
	"urn:publicid:IDN+clemson.cloudlab.us+authority+cm" : "clemson",
	"urn:publicid:IDN+wisc.cloudlab.us+authority+cm" : "wisconsin",
	"urn:publicid:IDN+emulab.net+authority+cm" : "emulab",
	"urn:publicid:IDN+apt.emulab.net+authority+cm" : "apt",
	"urn:publicid:IDN+cloudlab.umass.edu+authority+cm" : "mass",
	"urn:publicid:IDN+lab.onelab.eu+authority+cm" : "onelab"
		]

//Sample:
//{
//	"urn:publicid:IDN+clemson.cloudlab.us+authority+cm": {
//	  "rawPCsAvailable": "48",
//	  "rawPCsTotal": "344",
//	  "VMsAvailable": "3720",
//	  "VMsTotal": "1900",
//	  "health": 100,
//	  "status": "SUCCESS"
//	}
//}


