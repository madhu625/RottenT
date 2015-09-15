//
//  PhotosViewController.swift
//  RottenT
//
//  Created by Deepti Chinta on 9/13/15.
//  Copyright © 2015 DeeptiChinta. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD


private let CELL_NAME="com.deeptichinta.rottent.customcell"

class PhotosViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var PhotosTableView: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var networkErrorView: UIView!
    

    
    var scrollView: UIScrollView?
    var movies:NSArray?

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexpath:NSIndexPath) -> UITableViewCell {
        let movieDictionary = movies![indexpath.row] as! NSDictionary

        let title = movieDictionary["title"] as! String
        let description = movieDictionary["synopsis"] as! String
        let posters = movieDictionary["posters"] as! NSDictionary
        let thumb = posters["thumbnail"] as! String
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! MovieCell
        cell.MovieNameLabel.text = title
        cell.MovieDescriptionLabel.text = description
        cell.MovieImageView.setImageWithURL(NSURL(string: thumb)!)
        
        return cell
    }

    
    override func viewDidLoad() {
        self.networkErrorView.hidden = true
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        scrollView?.insertSubview(refreshControl, atIndex: 0)
        self.PhotosTableView.addSubview(self.refreshControl)


        // API Async call
        NSLog("TableView? \(PhotosTableView.frame)")
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=f2fk8pundhpxf77fscxvkupy"
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        SVProgressHUD.show()
        delay(10, closure: {
            //do nothing
            })
        
        // Method 1
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            print(error)
            if ((error) != nil) {
                SVProgressHUD.dismiss()
                print("Network Error1")
                if (error?.code)! as Int == -1009 {
                    print("Network Error2")
                    self.networkErrorView.hidden = false
                }
                else {
                    print ("Unknown Network error")
                    self.networkErrorView.hidden = false
                }
            }
            else {
                self.networkErrorView.hidden = true
                print ("hiding error")
                let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                self.movies = responseDictionary["movies"] as? NSArray
                SVProgressHUD.dismiss()
                self.PhotosTableView!.reloadData()
            }
       
       // let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
       // self.movies = responseDictionary["movies"] as? NSArray
        SVProgressHUD.dismiss()
        self.PhotosTableView!.reloadData()
        //NSLog("response: \(self.movies)")
        }
        // Method 1 end
    }

    
    func onRefresh() {
        super.viewDidLoad()
        print("reload completed")
        self.refreshControl.endRefreshing()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = PhotosTableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie as! NSDictionary
    }

}

class MovieCell:UITableViewCell{
    @IBOutlet weak var MovieNameLabel: UILabel!
    @IBOutlet weak var MovieDescriptionLabel: UILabel!
    @IBOutlet weak var MovieImageView: UIImageView!
}