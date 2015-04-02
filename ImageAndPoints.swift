//
//  ImageAndPoints.swift
//  GeoFile
//
//  Created by knut on 02/04/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation


class ImageAndPoints
{
    var originPoint:CGPoint
    var labels:[UILabel]
    var refPoints:[ImageAndPoints]
    var image: String
    
    init(origin: CGPoint)
    {
        self.image = ""
        self.originPoint = origin
        self.labels = []
        self.refPoints = []
    }
    
    func addImage(image:String)
    {
        self.image = image
    }
    
    func addPoint(point:CGPoint)
    {
        var imageAndPoints = ImageAndPoints(origin:point)
        refPoints.append(imageAndPoints)
    }
    
}