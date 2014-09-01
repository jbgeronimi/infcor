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
    prefsVC.alangue = self.alangue;
    prefsVC.params = self.params;
    
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
    //En fonction du contexte de langue il faut modifier les matrices dbb_query, mot_corse et mot_francais pour avoir l'affichage de la traduction voulue
    if(([self.alangue isEqualToString:@"mot_corse"]) && ([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] removeObject:@"FRANCESE"];
        [self.params[@"mot_corse"] removeObject:@"FRANCESE"];
    }else if(([self.alangue isEqualToString:@"mot_francais"]) & ([self.params[@"dbb_query"] containsObject:@"id"])){
        [self.params[@"dbb_query"] removeObject:@"id"];
        [self.params[@"mot_francais"] removeObject:@"CORSU : "];
    }
 }


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            UITextAttributeTextColor: [UIColor whiteColor],
                                                            UITextAttributeFont: [UIFont fontWithName:@"Code-BOLD" size:17.0f]
                                                            }];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.129 green:0.512 blue:1.000 alpha:1.000]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    self.view.backgroundColor = [UIColor colorWithRed:0.098 green:0.048 blue:0.051 alpha:1.000];
    UIView *lefond = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 95)];
    [lefond setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    lefond.backgroundColor = [UIColor colorWithRed:0.129 green:0.512 blue:1.000 alpha:1.000];
    [self.view addSubview:lefond];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    UIFont *titre = [UIFont fontWithName:@"Giorgio" size:20];
    NSString *langInit = @"Corsu \u21c4 Francese";
    self.alangue = @"mot_corse";
    self.primu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.primu.frame = CGRectMake(70,14, 180, 41);
    [self.primu.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.primu.titleLabel setFont:titre];
    self.primu.tintColor = [UIColor colorWithWhite:1 alpha:1];
    [self.primu setTitle:langInit forState:UIControlStateNormal];
    [self.primu addTarget:self
                   action:@selector(changeLanguage:)
         forControlEvents:UIControlEventTouchUpInside];
    self.primu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.primu];
    
    self.gio = [UIFont fontWithName:@"Code BOLD" size:17];
    UIButton *prefBouton = [UIButton buttonWithType:UIButtonTypeSystem] ;
    prefBouton.tintColor = [UIColor colorWithWhite:.8 alpha:1];
    prefBouton.frame = CGRectMake(10, 20, 25, 25);
    UIImage *btn = [UIImage imageNamed:@"prefs.png"];
    //[prefBouton setTitle: @"pref" forState:UIControlStateNormal];
    [prefBouton setImage:btn forState:UIControlStateNormal];
    [prefBouton addTarget:self
                   action:@selector(preferences:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prefBouton];
    
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 50, 260, 35)];
    [self.searchText setBorderStyle:UITextBorderStyleRoundedRect];
    self.searchText.font = self.gio;
    self.searchText.textColor = [UIColor whiteColor];
    [self.searchText setAutocorrectionType:UITextAutocorrectionTypeNo],
    [self.searchText setBackgroundColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.200 alpha:0.850]];
//    self.searchText.delegate = self;
    [self.searchText addTarget:self
                  action:@selector(editingChanged:)
        forControlEvents:UIControlEventEditingChanged];
    self.searchText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.searchText];
    
    [self.searchText addTarget:self
                  action:@selector(enleveClavier)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    self.suggestTableView=[[UITableView alloc] initWithFrame:CGRectMake(30, 95, 260, self.view.frame.size.height - 261)];
    self.suggestTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.suggestTableView.delegate = self;
    self.suggestTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.suggestTableView.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.08];
    self.suggestTableView.dataSource = self;
    self.suggestTableView.rowHeight = 28;
    [self.view addSubview:self.suggestTableView];
}

-(void)editingChanged:(id)sender {
 //   NSLog(@" sender : %@", self.searchText.text);
    NSString *cercaString = [NSString stringWithFormat:@"http://adecec.net/infcor/try/suggestion.php?mot=%@&langue=%@", self.searchText.text, self.alangue];
    NSURL *cercaURL = [[NSURL alloc] initWithString:cercaString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cercaURL];
    // Requete ASynchrone
       __block NSMutableArray *json;
     [NSURLConnection sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data) {json = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:nil];}
     self.suggest = json;
     [self.suggestTableView reloadData];
     NSLog(@"Async JSON: %@", self.suggest);
     }];
}

//Une Table pour les suggestions
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //return 9;
    return self.suggest.count;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //couleur du texte
    cell.textLabel.textColor = [UIColor colorWithWhite:.8 alpha:1];
    //couleur des cellules
    if (indexPath.row %2) {
        UIColor *couleurPaire = [[UIColor alloc] initWithWhite:0.5 alpha:0.1];
        cell.backgroundColor = couleurPaire;
    }else{
        UIColor *couleurImpaire = [[UIColor alloc] initWithWhite:0.5 alpha:0.2];
        cell.backgroundColor = couleurImpaire;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = self.gio;
    cell.textLabel.text = self.suggest[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    afficheMotViewController *motVC=[[afficheMotViewController alloc] init];
    motVC.searchText = self.suggest[indexPath.row];
    motVC.alangue = self.alangue;
    motVC.params = self.params;
    motVC.gio = self.gio;
//    [self.searchText resignFirstResponder];
    [self.navigationController pushViewController:motVC animated:YES];
}

//si le mot a ete tape en entier et que "enter" a ete presse
-(BOOL)enleveClavier {
    [self.searchText resignFirstResponder];
    resultViewController *risultatiVC=[[resultViewController alloc] init];
    risultatiVC.params = self.params;
    risultatiVC.alangue = self.alangue;
    risultatiVC.searchText = self.searchText.text;
    risultatiVC.title = self.searchText.text;
    risultatiVC.gio = self.gio;

    if (![risultatiVC.searchText isEqualToString:@""]){
        [self.navigationController pushViewController:risultatiVC animated:YES];
    }
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize keySize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //self.tableHeight = MIN(keySize.height, keySize.width);
    CGRect newTable = self.suggestTableView.frame;
    newTable.size.height = self.view.frame.size.height - 90 - MIN(keySize.height, keySize.width);
    self.suggestTableView.frame = newTable;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeLanguage:(UIButton *) sender {
    if ([sender.titleLabel.text isEqualToString:@"Corsu \u21c4 Francese"]){
        [self.primu setTitle:@"Français \u21c4 Corse" forState:UIControlStateNormal];
        self.alangue = @"mot_francais";
            }else {
            [self.primu setTitle:@"Corsu \u21c4 Francese" forState:UIControlStateNormal];
            self.alangue = @"mot_corse";
    }
}

- (void)setDefaultValuesForVariables
{
    NSMutableArray *dbb = [[NSMutableArray alloc] init];
   // [dbb addObject:@"FRANCESE" ];
    [dbb addObject:@"DEFINIZIONE"];
    [dbb addObject:@"SINONIMI"];
    NSMutableArray *corsu = [[NSMutableArray alloc] init];
 //   [corsu addObject: @"FRANCESE"];
    [corsu addObject:@"DEFINIZIONE"];
    [corsu addObject:@"SINONIMI"];
    NSMutableArray *fcese = [[NSMutableArray alloc] init];
  //  [fcese addObject:@"FRANCAIS"];
    [fcese addObject:@"DEFINITION EN CORSE"];
    [fcese addObject:@"SYNONYMES"];
    self.params = @{
                    @"dbb_query":dbb,
                    @"mot_corse":corsu,
                    @"mot_francais" : fcese};
    self.lindex = 0;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
