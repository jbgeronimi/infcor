//
//  ViewController.h
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "langue.h"

@interface ViewController : UIViewController <UIViewControllerTransitioningDelegate, UITextFieldDelegate>
@property (strong,nonatomic) UIButton *primu;
@property (strong,nonatomic) NSString *alangue;
@property (strong,nonatomic) UITextField *searchText;
@property (strong,nonatomic) NSURL *searchURL;


@end
