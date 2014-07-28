//
//  prefsViewController.h
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "langue.h"

@interface prefsViewController : UIViewController

//@property (readwrite, assign) id<langueDelegate>delegate;
@property (strong, nonatomic) NSString  *langue;
@property (strong, nonatomic) IBOutlet UISwitch *un;
@property (weak, nonatomic) IBOutlet UISwitch *deux;
@property (weak, nonatomic) UISwitch *trois;
@property (weak, nonatomic) UISwitch *quattre;
@end
