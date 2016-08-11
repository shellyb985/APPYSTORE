//
//  Controller.swift
//  AppyStoreBLZ
//  Purpose
//  1. purpose of controller to supply date to view mode from source
//  2. All view models getting data from controller
//  3. Controller have method to update viewmodes
//  
//  Created by BridgeIt on 04/08/16.
//  Copyright © 2016 bridgelabz. All rights reserved.
//

import UIKit

class Controller : NSObject,PController{
    
    var ApiRequesrObj = ApiRequest() //create object to make rest call
    var mLocalDataBaseObj = LocalDataBase() //object of local database
    var mCategoryViewModelObj : PCategoryViewModel! //object od category view model
    var mSubCategoryViewModelObj : PSubCategoryViewModel! //object of sub category view model
    var mSearchViewModelObj : PSearchViewModel! //object od search view model
    var mHistoryViewModel : HistoryViewModel! //object of history view model
    
    //init for category
    override init() {
        super.init()
        //observe notification for category list updates
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Controller.updateCategoryDetails(_:)), name:"ControllerCategoryUpdate", object: nil)
        //observe notification for subcategory list updates
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Controller.updateSubCategoryList(_:)), name: "ControllerSubCategoryUpdate", object: nil)
    }
//    //init for subcategory
//    init(subCategoryVMObj : SubCategoryViewModel) {
//        mSubCategoryViewModelObj = subCategoryVMObj
//    }
    //init for search
    init(searchViewMode : PSearchViewModel) {
        mSearchViewModelObj = searchViewMode
    }
    //init for history
    init(historyVMObj : HistoryViewModel) {
        mHistoryViewModel = historyVMObj
        //mLocalDataBaseObj = LocalDataBase()
    }

    //method to get category list from rest api
    func mGetCategoryDetailsFromRest() {
        ApiRequesrObj.mFetchCategoryList()
    }
    
    //method to get category lisf from local database
    func mGetCategoryDetailsFromLB() {
        mLocalDataBaseObj.mFetchCategoryDetails()
    }
    
    //method to get subcategory from rest api
    func mGetSubCategoryDetails(cId : Int,pId : Int,offSet : Int) {
        ApiRequesrObj.mFetchSubCategoryList(cId,p_Id : pId,offset: offSet)
    }
    
    //medthod to get SearchDetails from api
    func mGetSearchCategory(keyword : String) {
        ApiRequesrObj.mFetchSearchDetails(self,keyword: keyword)
    }
    
    //method to get history details
    func mGetHistoryRecords() ->[SubCategorylist] {
        return mLocalDataBaseObj.mFetchHistoryDetails()
    }
    
    //method to save played video in lacal database
    func mSaveVideoInHistory(subCategory : SubCategorylist) {
        mLocalDataBaseObj.mInsertInToHistoryTabel(subCategory)
    }
    //method to update category view model
    func updateCategoryDetails(notification : NSNotification){
//        for category in categortList {
//            mLocalDataBaseObj.mInsertInToCategoryTable(category)
//        }
//        
//        mCategoryViewModelObj.updateCategoryViewModel(categortList)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ControllerCategoryUodate", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ControllerSubCategoryUpdate", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateCategoryViewModel", object: self, userInfo: notification.userInfo)
    }
    
    //method to update SubCategory View model
    func updateSubCategoryList(notification : NSNotification){
        //mSubCategoryViewModelObj.updateSubCategoryViewModel(subCategoryList)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ControllerSubCategoryUpdate", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateSubCategoryViewModel", object: self, userInfo: notification.userInfo)
        
    }
    
    //method to update Search CAtegory view model
    func updateSearchCategoryList(subCategoryList : [SubCategorylist]){
        mSearchViewModelObj.updateSearchViewModel(subCategoryList)
    }

    
}
