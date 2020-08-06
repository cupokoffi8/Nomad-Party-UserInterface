//
//  UserAnnotation.swift
//  Nomad-Party 

import Foundation
import MapKit

// User profile with map setup 
class UserAnnotation: MKPointAnnotation {
    var uid: String?
    var age: Int?
    var profileImage: UIImage? 
}
