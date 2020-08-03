//
//  UserAnnotation.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 8/2/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation: MKPointAnnotation {
    var uid: String?
    var age: Int?
    var profileImage: UIImage? 
}
