//
//  SubCategoryViewContoller.swift
//  AppyStoreApplication
//  Purpose
//  1. This class display all videos of selected category
//  2. And play video
//
//  Created by BridgeIt on 16/07/16.
//  Copyright © 2016 bridgelabz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVKit
import AVFoundation
import ReactiveKit
import ReactiveUIKit

class SubCategoryViewContoller: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mBackButtonLabel: UIButton!
    @IBOutlet weak var mVideoButtonLabel: UIButton!
    @IBOutlet weak var mHistoryButtonLabel: UIButton!
    @IBOutlet weak var mSearchButtonLabel: UIButton!
    @IBOutlet weak var mCartButtonLabel: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var mSubcategoryViewModelObj : SubCategoryViewModel!
    var collectionViewCell : CollectionViewCell? 
    var mCategory : categorylist!   //to store selected category from category view
    //------------------------------
    var mVideoPlayer : AVPlayer!
    var mPlayerViewController : AVPlayerViewController!
    var index : Int!
    var historyChecker = false
    
    var mSelectedCategoryCount = 0
    var offset = 0
    //------------------------------
    
    override func viewDidLoad() {
        
        //setting background for buttons
        mBackButtonLabel.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        mVideoButtonLabel.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        mHistoryButtonLabel.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        mSearchButtonLabel.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        mCartButtonLabel.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        
        //setting image for buttons
        mChangeButtonImage()
        mVideoButtonLabel.setImage(UIImage(named: "videobackground.png"), forState: UIControlState.Normal)
        super.viewDidLoad()
        
        //CollectionViewCell class registeration
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.registerNib(UINib(nibName: "CollectionHeaderReusableView", bundle: nil), forCellWithReuseIdentifier: "Header")
        
        //creating layout for cell in collection view
        collectionView.collectionViewLayout = CustomViewFlowLayout(width : CGRectGetWidth(self.view.frame),height : CGRectGetHeight(self.view.frame))

        
        mSubcategoryViewModelObj = SubCategoryViewModel(category: mCategory!)
       // mSubcategoryViewModelObj.mFetchSubCategoryDetailsFromController(mCategory.categoryId,p_Id: mCategory.parentId,offSet: offset)
        
        // setting background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundimage.jpg")!)
        collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundimage.jpg")!)
        headerView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.1)
        
        headerLabel.text = mCategory.name.value

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SubCategoryViewContoller.updataSubCategoryViewController(_:)), name: "UpdateSubCategoryViewController", object: nil)
    }

    override func didReceiveMemoryWarning() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UpdateSubCategoryViewController", object: nil)
        super.didReceiveMemoryWarning()
    }
    //method to return number of section in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //method to return number of item in each section of collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mSubcategoryViewModelObj.mTotalSubCategoryCount
    }

    //method to create collection view cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let subCategory : SubCategorylist? = mSubcategoryViewModelObj.mGetSubCategory(indexPath.row)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        Utility().mBindCollectionViewCell(cell, subCategory: subCategory!,collectionViewRef: collectionView,index: indexPath)
        
        return cell
    }
    //method wil be called when item in collection view is selected
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: mSubcategoryViewModelObj.mSubcategoryList[indexPath.row].downloadUrl.value)
        mVideoPlayer = AVPlayer(URL: url!)
        mPlayerViewController = AVPlayerViewController()
        
        mPlayerViewController.player = mVideoPlayer
        self.presentViewController(mPlayerViewController, animated: true ){
            self.mPlayerViewController.player?.play()
        }
        
        let LocalDB = LocalDataBase()
        LocalDB.mInsertInToHistoryTabel(mSubcategoryViewModelObj.mSubcategoryList[indexPath.row])
    }
    //mehtod will be called before performing segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    //buttons actions
    @IBAction func mBackButtonPressed(sender: UIButton) {
        mChangeButtonImage()
        mBackButtonLabel.setImage(UIImage(named: "backY.png"), forState: UIControlState.Normal)
        performSegueWithIdentifier("SubCategoryToCategory", sender: nil)
    }
    
    @IBAction func mVideoButtonPressed(sender: UIButton) {
        mChangeButtonImage()
        mVideoButtonLabel.setImage(UIImage(named: "videobackground.png"), forState: UIControlState.Normal)
    }
    
    @IBAction func mHistoryButtonPressed(sender: UIButton) {
        mChangeButtonImage()
        mHistoryButtonLabel.setImage(UIImage(named: "historybackground.png"), forState: UIControlState.Normal)
        performSegueWithIdentifier("SubCategoryToHistory", sender: nil)
    }
    
    @IBAction func mSearchButtonPressed(sender: UIButton) {
        mChangeButtonImage()
        mSearchButtonLabel.setImage(UIImage(named: "searchbackground.png"), forState: UIControlState.Normal)
        performSegueWithIdentifier("SubCategoryToSearch", sender: nil)
    }
    
    @IBAction func mCartButtonPressed(sender: UIButton) {
        mChangeButtonImage()
        mCartButtonLabel.setImage(UIImage(named: "cartbackground.png"), forState: UIControlState.Normal)
        
        //creating alert view
        let alertController = UIAlertController(title: "Sorry !!", message: "Cart is not available at this time", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            self.mChangeButtonImage()
            self.mVideoButtonLabel.setImage(UIImage(named: "videobackground.png"), forState: UIControlState.Normal)
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //method to change background image of buttons
    func mChangeButtonImage () {
        mBackButtonLabel.setImage(UIImage(named: "backarrow.png"), forState: UIControlState.Normal)
        mVideoButtonLabel.setImage(UIImage(named: "videoimage.png"), forState: UIControlState.Normal)
        mHistoryButtonLabel.setImage(UIImage(named: "historyimage.png"), forState: UIControlState.Normal)
        mSearchButtonLabel.setImage(UIImage(named: "searchimage.png"), forState: UIControlState.Normal)
        mCartButtonLabel.setImage(UIImage(named: "carimage.png"), forState: UIControlState.Normal)
    }
    
    //method to update subcategory view controller
    func updataSubCategoryViewController(notification : NSNotification) {
        collectionView.reloadData()
    }

}
