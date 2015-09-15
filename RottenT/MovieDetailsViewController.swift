//
//  MovieDetailsViewController.swift
//  RottenT
//
//  Created by Deepti Chinta on 9/13/15.
//  Copyright © 2015 DeeptiChinta. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var DetailedImageView: UIImageView!
    @IBOutlet weak var DetailedMovieNameLabel: UILabel!
    @IBOutlet weak var DetailedDescriptionLabel: UILabel!
    
    var movie:NSDictionary!
    private let FROM_STRING="resizing.flixster.com/pVDoql2vCTzNNu0t6z0EUlE5G_c=/51x81/dkpu1ddg7pbsk.cloudfront.net"
    private let TO_STRING="content6.flixster.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let posters = movie ["posters"] as! NSDictionary
        let thumb = posters["thumbnail"] as! String
        let detailedThump = thumb.stringByReplacingOccurrencesOfString(FROM_STRING, withString: TO_STRING, options: NSStringCompareOptions.LiteralSearch, range: nil)

        //print (thumb)
        //print (detailedThump)
        
        DetailedImageView.setImageWithURL(NSURL(string: detailedThump)!)
        DetailedMovieNameLabel.text = movie["title"] as? String
        DetailedDescriptionLabel.text = movie ["synopsis"] as? String
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
