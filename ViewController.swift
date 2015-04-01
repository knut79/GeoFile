//
//  ViewController.swift
//  GeoFile
//
//  Created by knut on 23/03/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GMSMapViewDelegate {
    
    //#2
    var gmaps: GMSMapView?
    var project: String!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: 10, bearing: 0, viewingAngle: 0)
        //super.tabBarController
        //var tabbarHeigt:CGFloat = self.tabBarController!.tabBar.frame.height
       
        gmaps = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width,
            self.view.bounds.height))// - tabbarHeigt))
        
        if let map = gmaps? {
            map.myLocationEnabled = true
            map.camera = camera
            map.delegate = self
            
            self.view.addSubview(gmaps!)
        }
        
        var marker1 = GMSMarker()
        marker1.title = "project1"
        marker1.position = CLLocationCoordinate2DMake(59.95, 10.75)
        marker1.appearAnimation = kGMSMarkerAnimationPop
        marker1.icon = UIImage(named: "flag_icon")
        marker1.map = gmaps
        
        var marker2 = GMSMarker()
        marker2.title = "project2"
        marker2.position = CLLocationCoordinate2DMake(59.8, 10.8)
        marker2.appearAnimation = kGMSMarkerAnimationPop
        marker2.icon = UIImage(named: "flag_icon")
        marker2.map = gmaps

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        
        
        let filesViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FilesViewController") as FilesViewController
        //self.navigationController!.pushViewController(filesViewController, animated: true)
        self.performSegueWithIdentifier("ShowFilesViewController", sender: nil)

        project = marker.title
        /*
        if marker.title == nil{
            makeApiRequest(["id": marker.userData],
                success: {
                    (response: Dictionary<String, JSONValue>?) in
                    if let name = response?["name"]?.string{
                        marker.title = name
                    }
                },
                failure: {
                    (error: NSError) in
            })
        }*/
       return true
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "FilesViewController") {
            var svc = segue!.destinationViewController as FilesViewController
            //var filesViewController = self.storyboard!.instantiateViewControllerWithIdentifier("FilesViewController") as FilesViewController
            
            svc.project = project
        }
    }
    
}

