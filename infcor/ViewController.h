//
//  ViewController.h
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextField.h"
//#import "langue.h"
@class motDataSource;
@class MLPAutoCompleteTextField;

@interface ViewController : UIViewController <UIViewControllerTransitioningDelegate, UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate>
@property (strong,nonatomic) UIButton *primu;
@property (strong,nonatomic) NSString *alangue;
@property (strong, nonatomic) IBOutlet motDataSource *autocompleteDataSource;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;
@property (strong,nonatomic) MLPAutoCompleteTextField *searchText;
@property (strong,nonatomic) NSURL *searchURL;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSwitch;

@end
