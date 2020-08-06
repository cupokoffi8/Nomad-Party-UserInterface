//
//  MapTableViewCell.swift
//  Nomad-Party 

import UIKit
import MapKit 

class MapTableViewCell: UITableViewCell {

    // UI Elements corresponding to MapTableViewCell
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var directionsTap: UIImageView!
    
    
    var controller: DetailViewController!
        
        // Implements map view in DetailViewController
        override func awakeFromNib() {
            super.awakeFromNib()
            mapIcon.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMap))
            mapIcon.addGestureRecognizer(tapGesture)
            directionsTap.isUserInteractionEnabled = true
            let tapDirections = UITapGestureRecognizer(target: self, action: #selector(showMap))
            directionsTap.addGestureRecognizer(tapDirections)
            mapView.isUserInteractionEnabled = true
            let tapMap = UITapGestureRecognizer(target: self, action: #selector(showMap))
            mapView.addGestureRecognizer(tapMap)
        }
        
        // Takes user to map screen
        @objc func showMap() {
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let mapVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_MAP) as! MapViewController
            mapVC.users = [controller.user]
            controller.navigationController?.pushViewController(mapVC, animated: true)
            
        }

        // User location 
        func configure(location: CLLocation) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            self.mapView.setRegion(region, animated: true)
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
