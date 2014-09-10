//
//  spinnerViewController.m
//  INFCOR
//
//  Created by admin notte on 10/09/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "spinnerViewController.h"

@interface spinnerViewController ()

@end

@implementation spinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    //Un spinner d'attente
    //self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.spinner.frame = CGRectMake(40, 40, 200, 200);
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    //[self.view addSubview:self.spinner];
    [self.spinner startAnimating];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
