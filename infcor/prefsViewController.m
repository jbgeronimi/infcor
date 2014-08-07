//
//  prefsViewController.m
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "prefsViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
//#import "langue.h"

@interface prefsViewController ()

@end

@implementation prefsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    self.title = @"Options";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *corsu = @[@"chì hè esattamente :",@"chì cummecia cù :",@"chì finisce cù :",@"chì cuntene :"];
    NSArray *francais = @[@"Qui est exactement :",@"Qui commence par :", @"Qui finit par :", @"Qui contient :"];
    
    UILabel *exact = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 180, 20)];
    if ([self.langue isEqualToString:@"co"]){
        exact.text = corsu[0];
    }else{
        exact.text = francais[0];
    }
    [self.view addSubview:exact];
    UISwitch *exactSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 55, 0, 0)];
    [exactSwitch addTarget:self action:@selector(exactSwitchChange:) forControlEvents:UIControlEventTouchUpInside];
    [exactSwitch setOn:YES];
    self.un = exactSwitch;
    [self.view addSubview:self.un];
    
    UILabel *debut = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 180, 20)];
    if ([self.langue isEqualToString:@"co"]){
        debut.text = corsu[1];
    }else{
        debut.text = francais[1];
    }
    [self.view addSubview:debut];
    UISwitch *debutSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 95, 0, 0)];
    [debutSwitch addTarget:self action:@selector(debutSwitch:) forControlEvents:UIControlEventValueChanged];
    self.deux = debutSwitch;
    [self.view addSubview:self.deux];
    
    
    UILabel *fin = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, 180, 20)];
    if ([self.langue isEqualToString:@"co"]){
        fin.text = corsu[2];
    }else{
        fin.text = francais[2];
    }
    [self.view addSubview:fin];
    UISwitch *finSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 135, 0, 0)];
    [finSwitch addTarget:self action:@selector(finSwitch:) forControlEvents:UIControlEventValueChanged];
    self.trois = finSwitch;
    [self.view addSubview:self.trois];
    
    
    UILabel *contient = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, 180, 20)];
    if ([self.langue isEqualToString:@"co"]){
        contient.text = corsu[3];
    }else{
        contient.text = francais[3];
    }
    [self.view addSubview:contient];
    UISwitch *contientSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 175, 0, 0)];
    [contientSwitch addTarget:self action:@selector(contientSwitch:) forControlEvents:UIControlEventValueChanged];
    self.quattre = contientSwitch;
    [self.view addSubview:self.quattre];
    
    
    
    if (self.modalPresentationStyle == UIModalPresentationCustom) {
        self.view.layer.borderColor = [UIColor grayColor].CGColor;
        self.view.layer.borderWidth = 2.0f;
        UIButton *vabe = [UIButton buttonWithType:UIButtonTypeSystem];
        vabe.frame = CGRectMake(100, 300, 40, 20);
        [vabe setTitle:@"OK" forState:UIControlStateNormal];
        [vabe addTarget:self action:@selector(goodJob:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vabe];
        
    }
}

- (IBAction) goodJob:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) exactSwitchChange:(id)sender;{
    if ([sender isOn]) {
        [self.deux setOn:NO animated:YES];
        [self.trois setOn:NO animated:YES];
        [self.quattre setOn:NO animated:YES];
    }
}

- (void) debutSwitch:(id)sender;{
    if ([sender isOn]) {
        [self.un setOn:NO animated:YES];
        [self.trois setOn:NO animated:YES];
        [self.quattre setOn:NO animated:YES];
    }
}

- (void) finSwitch:(id)sender
{
    if ([sender isOn]) {
        [self.un setOn:NO animated:YES];
        [self.deux setOn:NO animated:YES];
        [self.quattre setOn:NO animated:YES];
 }
}

- (void) contientSwitch:(id)sender
{
    if ([sender isOn]) {
        [self.un setOn:NO animated:YES];
        [self.deux setOn:NO animated:YES];
        [self.trois setOn:NO animated:YES];
    }

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
