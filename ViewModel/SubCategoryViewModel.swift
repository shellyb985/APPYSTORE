//
//  SubCategoryViewModel.swift
//  AppyStoreBLZ
//
//  Purpose
//  1. This class responsible for getting Subcategory deatils from controller
//  2. And also update Subcategory view controller
//
//  Created by BridgeIt on 04/08/16.
//  Copyright © 2016 bridgelabz. All rights reserved.
//

import UIKit
import ReactiveKit

class SubCategoryViewModel: NSObject {
    
    var mControllerObj : Controller!  //create controller object
    var mSubcategoryList = [SubCategorylist]()  //variable hold list of sub categories details
    var mTotalSubCategoryCount = 8    //varible to store total number of subCategories
    var mReceivedCategoryCount = 0 //variable to store number of recived categories
    var mCategory : categorylist! // varibale to store total selected category
    
    init(category : categorylist) {
        super.init()
//        mSubCategoryViewControllerObj = subCategory
        mCategory = category
        //observing notification for subategory view model
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SubCategoryViewModel.updateSubCategoryViewModel(_:)), name: "UpdateSubCategoryViewModel", object: nil)
    }
    
    //method to fetch subcategory details from controller
    func mFetchSubCategoryDetailsFromController (c_Id : Int,p_Id : Int,offSet : Int) {
        mControllerObj = Controller()
        mControllerObj.mGetSubCategoryDetails(c_Id,pId : p_Id,offSet: offSet)
    }
    
    //method to send sub category details 
    func mGetSubCategory(index : Int) -> SubCategorylist? {
        //if data available in list
        if index < mSubcategoryList.count {
            return mSubcategoryList[index]
        }
        //if not available then create dummy data and return it to coleciton view
        else {
            //every eigth index it will call method to fetch data from rest..
            if index%8 == 0 {
                //method calling to fetch data
                mFetchSubCategoryDetailsFromController(mCategory.categoryId, p_Id: mCategory.parentId, offSet: index)
            }
            //creating dummy data
            let category = SubCategorylist(title: "", duration: "", downloadUrl: "", imageUrl: "", totalCount: index)
            //insertingdummy data into list
            category.ObImage = Observable<UIImage>.init(UIImage(named: "videoimage")!)
            mSubcategoryList.insert(category, atIndex: index)

            return mSubcategoryList[index]
        }
    }
    
    //mehtod to update subcategory list in sub category view controller
    @objc func updateSubCategoryViewModel(notification : NSNotification){
        var subCategoryList = notification.userInfo!["SubCategory"] as! [SubCategorylist]
        
        mTotalSubCategoryCount = subCategoryList[0].totalCount
        //adding content to list
        for category in subCategoryList {
            //if search result don't have dummy value
            if mReceivedCategoryCount < mSubcategoryList.count {
                mSubcategoryList[mReceivedCategoryCount] = category
            }
                //if search list contain dummy value
            else {
                //inserting subcategory into list
                mSubcategoryList.insert(category, atIndex: mReceivedCategoryCount)
            }
            //incrementing
            mReceivedCategoryCount += 1
        }
//        if mSubcategoryList.count < 9 {
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateSubCategoryViewController", object: nil)
//        }
        if mTotalSubCategoryCount == mReceivedCategoryCount {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "UpdateSubCategoryViewModel", object: nil)
        }
    }
}
