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
#import "afficheMotViewController.h"
//#import "langue.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultValuesForVariables];
    }
    return self;
}

// Present the prefsViewController as a modal
- (void) preferences:(id)sender{
    
    prefsViewController *prefsVC = [[prefsViewController alloc] init];
    
    prefsVC.modalPresentationStyle = UIModalPresentationCustom;
    prefsVC.transitioningDelegate = self;
    prefsVC.langue = self.alangue;
    
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

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIFont *code = [UIFont fontWithName:@"Giorgio" size:20];

//    NSMutableURLRequest *cerca = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:cercaURL]];
//    [cerca setHTTPMethod:@"GET"];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:cerca delegate:self];
//    [connection start];
    NSLog(@"search url : %@",self.searchURL);

    NSString *langInit = @"Corsu - Francese";
    self.alangue = @"mot_corse";
    self.view.backgroundColor = [UIColor whiteColor];
    self.primu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.primu.frame = CGRectMake(70,10, 180, 45);
    [self.primu.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.primu.titleLabel setFont:code];
    [self.primu setTitle:langInit forState:UIControlStateNormal];
    [self.primu addTarget:self
                   action:@selector(changeLanguage:)
         forControlEvents:UIControlEventTouchUpInside];
    self.primu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.primu];
    
    UIButton *prefBouton = [UIButton buttonWithType:UIButtonTypeSystem] ;
    prefBouton.frame = CGRectMake(10, 30, 40, 40);
    [prefBouton setTitle: @"pref" forState:UIControlStateNormal];
    [prefBouton addTarget:self
                   action:@selector(preferences:)
         forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addSubview:prefBouton];
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 65, 260, 25)];
    [self.searchText setBorderStyle:UITextBorderStyleLine];
//    self.searchText.delegate = self;
    [self.searchText addTarget:self
                  action:@selector(editingChanged:)
        forControlEvents:UIControlEventEditingChanged];
    self.searchText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.searchText];

    self.suggestTableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 90, 260, 200)];
    self.suggestTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.suggestTableView.delegate = self;
    self.suggestTableView.dataSource = self;
    [self.view addSubview:self.suggestTableView];
}

-(void)editingChanged:(id)sender {
 //   NSLog(@" sender : %@", self.searchText.text);
    NSString *cercaString = [NSString stringWithFormat:@"http://adecec.net/infcor/try/suggestion.php?mot=%@&langue=%@", self.searchText.text, self.alangue];
    NSLog(@"cerca : %@", cercaString);
    NSURL *cercaURL = [[NSURL alloc] initWithString:cercaString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cercaURL];
    // Requete ASynchrone
       __block NSMutableArray *json;
     [NSURLConnection sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     json = [NSJSONSerialization JSONObjectWithData:data
     options:0
     error:nil];
     self.suggest = json;
     [self.suggestTableView reloadData];
     NSLog(@"Async JSON: %@", self.suggest);
     }];
}

//Une Table pour les suggestions
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.suggest.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.suggest[indexPath.row];
    NSLog(@"cell : %@", cell.textLabel.text);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    afficheMotViewController *motVC=[[afficheMotViewController alloc] init];
    motVC.searchText = self.suggest[indexPath.row];
    motVC.alangue = self.alangue;
    motVC.params = self.params;
    NSLog(@"risultati VC : %@",motVC.searchText);
//    risultatiVC.searchURL = self.searchURL;
    // on garde notre fichier JSON et on affiche d'autres champs
    //    motVC.detail = self.risultati[indexPath.row][@"detail"];
    //    motVC.synonyme = self.risultati[indexPath.row][@"synonyme"];
    
    [self.navigationController pushViewController:motVC animated:YES];
}

//si le mot a ete tape en entier et que "enter" a ete presse
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    resultViewController *risultatiVC=[[resultViewController alloc] init];
//    risultatiVC.searchText = self.searchText.text;
    if (![risultatiVC.searchText isEqualToString:@""]){
//        NSLog(@"URL = %@",cercaURL);
        //[self presentViewController:risultati animated:YES completion:nil];
        [self.navigationController pushViewController:risultatiVC animated:YES];
    }
    [textField resignFirstResponder];
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
        self.alangue = @"mot_francais";
            }else {
            [self.primu setTitle:@"Corsu - Francese" forState:UIControlStateNormal];
            self.alangue = @"mot_corse";
    }
//    NSLog(@"%@",self.alangue);
//   return self.alangue;
}

- (void)setDefaultValuesForVariables
{
    self.params = @{@"mot_corse": @[@"FRANCESE",@"DEFINIZIONE",@"SINONIMI",@"TALIANU"],
                    @"mot_francais" : @[@"FRANCAIS",@"DEFINITION",@"SYNONIME",@"ITALIEN"]};
    self.lindex = 0;
}


@end
