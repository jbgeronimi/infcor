//
//  ViewController.m
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "ViewController.h"
#import "prefsViewController.h"
#import "SideDismissalTransition.h"
#import "SideTransition.h"
#import "AppDelegate.h"
#import "resultViewController.h"
//#import "langue.h"

@interface ViewController ()

@end

@implementation ViewController

// Present the prefsViewController as a modal
- (void) preferences:(id)sender{
    
    prefsViewController *prefsVC = [[prefsViewController alloc] init];
    
    prefsVC.modalPresentationStyle = UIModalPresentationCustom;
    prefsVC.transitioningDelegate = self;
    if (!self.alangue) {
        prefsVC.langue = @"co";
    }else {
    prefsVC.langue = self.alangue;
    }
    
    [self presentViewController:prefsVC animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[SideTransition alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[SideDismissalTransition alloc] init];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *langInit = @"Corsu - Francese";
    self.view.backgroundColor = [UIColor whiteColor];
    self.primu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.primu.frame = CGRectMake(80,30, 160, 25);
    [self.primu.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.primu setTitle:langInit forState:UIControlStateNormal];
    [self.primu addTarget:self
                   action:@selector(changeLanguage:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.primu];
    
    UIButton *prefBouton = [UIButton buttonWithType:UIButtonTypeSystem] ;
    prefBouton.frame = CGRectMake(10, 30, 40, 40);
    [prefBouton setTitle: @"pref" forState:UIControlStateNormal];
    [prefBouton addTarget:self
                   action:@selector(preferences:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prefBouton];
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 65, 260, 25)];
    [self.searchText setBorderStyle:UITextBorderStyleLine];
    self.searchText.delegate = self;
    [self.view addSubview:self.searchText];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    resultViewController *risultati=[[resultViewController alloc] init];
    risultati.text = self.searchText.text;
    [self presentViewController:risultati animated:YES completion:nil];
    NSLog(@"andemu");
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeLanguage:(UIButton *) sender {
    if ([sender.titleLabel.text isEqualToString:@"Corsu - Francese"]){
        [self.primu setTitle:@"Français - Corse" forState:UIControlStateNormal];
        self.alangue = @"fr";
            }else {
            [self.primu setTitle:@"Corsu - Francese" forState:UIControlStateNormal];
            self.alangue = @"co";
    }
//    NSLog(@"%@",self.alangue);
//   return self.alangue;
}


@end
