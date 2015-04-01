//
//  FilesViewController.swift
//  GeoFile
//
//  Created by knut on 23/03/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation


class FilesViewController: UIViewController, UIScrollViewDelegate{

    var project:String!
    var frontPicture: Bool = false
    var overviewImageView: UIImageView!
    var overviewScrollView: UIScrollView!
    let dynamicButtonsHeight:CGFloat = 44.0
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var viewFrame = self.view.frame
        
        // Adjust it down by 20 points
        viewFrame.origin.y += (UIApplication.sharedApplication().statusBarFrame.size.height )
        
        addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - self.tabBarController!.tabBar.frame.size.height - dynamicButtonsHeight, UIScreen.mainScreen().bounds.size.width, dynamicButtonsHeight))
        addButton.setTitle("add point", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        addButton.addTarget(self, action: "addPoint", forControlEvents: .TouchUpInside)
        
        let strechedHeight = UIScreen.mainScreen().bounds.size.height - (self.tabBarController!.tabBar.frame.size.height +
            UIApplication.sharedApplication().statusBarFrame.size.height + addButton.frame.size.height)
        overviewScrollView = UIScrollView(frame: CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height , UIScreen.mainScreen().bounds.size.width, strechedHeight))
        
        
        
        //collect picture from server
        var imageName = "pictureOverview.png"
        if let image = UIImage(named: imageName)
        {
            
            overviewImageView = UIImageView(frame: CGRectMake(0, 0, image.size.width, image.size.height))
            overviewImageView.image = image
            //overviewImageView = UIImageView(image:image)
            
            overviewScrollView.addSubview(overviewImageView)
            overviewScrollView.contentSize = overviewImageView.frame.size
            /*
            overviewImageView = UIImageView(image: imageResize(image,CGSizeMake(UIScreen.mainScreen().bounds.size.width,strechedHeight)))
            //overviewImageView.frame.origin.y += 20.0
            self.view.addSubview(overviewImageView)*/
        }
        
        overviewScrollView.delegate = self
        
        self.view.addSubview(overviewScrollView)
        self.view.addSubview(addButton)
        
        
        let scrollViewFrame = overviewScrollView.frame
        let scaleWidth = scrollViewFrame.size.width / overviewScrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / overviewScrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        overviewScrollView.minimumZoomScale = minScale;
        
        // 5
        overviewScrollView.maximumZoomScale = 1.0
        overviewScrollView.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
        
        
        // Reduce the total height by 20 points for the status bar, and 44 points for the bottom button
        viewFrame.size.height -= (self.tabBarController!.tabBar.frame.size.height +
            UIApplication.sharedApplication().statusBarFrame.size.height + addButton.frame.size.height)
        
    }
    
    func centerScrollViewContents() {
        let boundsSize = overviewScrollView.bounds.size
        var contentsFrame = overviewImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        overviewImageView.frame = contentsFrame
    }
    
    var labels:[UILabel] = []
    var positions:[CGPoint] = []
    //var pointLabel: UILabel!
    //var realPosition: CGPoint = CGPointMake(0, 0)
    func addPoint()
    {
        addButton.frame.size.width = UIScreen.mainScreen().bounds.size.width * 0.7
        var pointLabel = UILabel(frame: CGRectMake(addButton.frame.size.width + 2, UIScreen.mainScreen().bounds.size.height - self.tabBarController!.tabBar.frame.size.height - dynamicButtonsHeight, UIScreen.mainScreen().bounds.size.width * 0.30, dynamicButtonsHeight))
        pointLabel.text = "+"
        pointLabel.textAlignment = NSTextAlignment.Center
        pointLabel.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        pointLabel.userInteractionEnabled = true
        
        pointLabel.tag = labels.count
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "pointTapped:")
        tapRecognizer.numberOfTapsRequired = 1
        pointLabel.addGestureRecognizer(tapRecognizer)

        var temp:CGPoint = CGPointMake(0, 0)
        positions.append(temp)
        
        labels.append(pointLabel)
        self.view.addSubview(pointLabel)
        
        
    }
    
    func pointTapped()
    {
        
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return overviewImageView
    }

    func scrollViewDidZoom(scrollView: UIScrollView!) {
        println("zoomscale \(overviewScrollView.zoomScale)")
        //println("realpoint \(realPosition.x) , \(realPosition.y)")
       
        
        
        println("scrollview height is  \(overviewScrollView.frame.height)")
        println("imageview height is  \(overviewImageView.frame.height)")
        
        var yVoidOffset = overviewImageView.frame.height < overviewScrollView.frame.height ? (overviewScrollView.frame.height - overviewImageView.frame.height)/2 : 0.0
        var xVoidOffset = overviewImageView.frame.width < overviewScrollView.frame.width ? (overviewScrollView.frame.width - overviewImageView.frame.width)/2 : 0.0
        
        if(labels.count > 0)
        {
            for( var i = 0 ; i < labels.count ; i++)
            {
                var label = labels[i]
                var position = positions[i]
                //pointLabel.center = CGPointMake(pointLabel.center.x * overviewScrollView.zoomScale, pointLabel.center.y * overviewScrollView.zoomScale)
                label.center = CGPointMake(position.x * overviewScrollView.zoomScale,position.y * overviewScrollView.zoomScale)
                label.center = CGPointMake(label.center.x + xVoidOffset,label.center.y + yVoidOffset)
            }
            
        }

        centerScrollViewContents()
    }
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var pointLabel = labels[labels.count-1]
        let point = touches.anyObject()!.locationInView(self.view)
        xOffset = point.x - pointLabel.center.x
        yOffset = point.y - pointLabel.center.y
        pointLabel.transform = CGAffineTransformMakeRotation(10.0 * CGFloat(Float(M_PI)) / 180.0)
    }
    
    //Mark: UIResponder
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent)  {
        var pointLabel = labels[labels.count-1]
        let point = touches.anyObject()!.locationInView(self.view)
        pointLabel.center = CGPointMake(point.x - xOffset, point.y - yOffset)
        
    }
    
    //om man har lyst til å legge label rett på imageview. den vil da skaleres ned med resten av bildet. 
    //lables kan ende opp meg lite synlig text
    
    /*
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var pointLabel = labels[labels.count-1]
        
        self.touchesMoved(touches, withEvent: event)
        pointLabel.removeFromSuperview()
        pointLabel.transform = CGAffineTransformMakeRotation(0.0 * CGFloat(Float(M_PI)) / 180.0)
        //pointLabel.frame.size.width = dynamicButtonsHeight
        
        pointLabel.center = CGPointMake(pointLabel.center.x + overviewScrollView.contentOffset.x, pointLabel.center.y + overviewScrollView.contentOffset.y - (pointLabel.frame.size.height/2))
        
        pointLabel.center = CGPointMake(pointLabel.center.x / overviewScrollView.zoomScale, pointLabel.center.y / overviewScrollView.zoomScale)
        pointLabel.alpha = 0.75
        
        overviewImageView.addSubview(pointLabel)

        
    }
    */
    //Mark: UIResponder

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var pointLabel = labels[labels.count-1]
        
        self.touchesMoved(touches, withEvent: event)
        pointLabel.removeFromSuperview()
        pointLabel.transform = CGAffineTransformMakeRotation(0.0 * CGFloat(Float(M_PI)) / 180.0)
        //pointLabel.frame.size.width = dynamicButtonsHeight
        pointLabel.center = CGPointMake(pointLabel.center.x + overviewScrollView.contentOffset.x, pointLabel.center.y + overviewScrollView.contentOffset.y - (pointLabel.frame.size.height/2))
        
        pointLabel.alpha = 0.75
        
        
        overviewImageView.addSubview(pointLabel)
        
        var realPosition = CGPointMake(pointLabel.center.x / overviewScrollView.zoomScale, pointLabel.center.y / overviewScrollView.zoomScale)
        var yVoidOffset = overviewImageView.frame.height < overviewScrollView.frame.height ? (overviewScrollView.frame.height - overviewImageView.frame.height)/2 : 0.0
        var xVoidOffset = overviewImageView.frame.width < overviewScrollView.frame.width ? (overviewScrollView.frame.width - overviewImageView.frame.width)/2 : 0.0
        //realPosition = CGPointMake(realPosition.x - xVoidOffset, realPosition.y - yVoidOffset)
        realPosition = CGPointMake(realPosition.x - (xVoidOffset/overviewScrollView.zoomScale), realPosition.y - (yVoidOffset/overviewScrollView.zoomScale))
        
        positions[labels.count-1] = realPosition
        
        
        pointLabel.removeFromSuperview()
        
        overviewScrollView.addSubview(pointLabel)

    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}