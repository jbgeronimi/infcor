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
    //customisation de la barre de nav
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Code-BOLD" size:17.0f]
                                                            }];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.129 green:0.512 blue:1.000 alpha:1.000]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:0.010 green:0.000 blue:0.098 alpha:1.000];
    self.gio = [UIFont fontWithName:@"Klill" size:19];
    // je cree une vue pour le fond bleu
    UIView *lefond = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    [lefond setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    lefond.backgroundColor = [UIColor colorWithRed:0.129 green:0.512 blue:1.000 alpha:1.000];
    [self.view addSubview:lefond];
    //detection du clavier pour adapter la hauteur des suggestions
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    UIFont *titre = [UIFont fontWithName:@"Sansation" size:20];
    NSString *langInit = @"Corsu \u21c4 Francese";
    self.alangue = @"mot_corse";
    //corsu - francese ou  francais-corse
    self.primu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.primu.frame = CGRectMake(70,23, self.view.frame.size.width - 140, 41);
    [self.primu.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.primu.titleLabel setFont:titre];
    self.primu.tintColor = [UIColor colorWithWhite:1 alpha:1];
    [self.primu setTitle:langInit forState:UIControlStateNormal];
    [self.primu addTarget:self
                   action:@selector(changeLanguage:)
         forControlEvents:UIControlEventTouchUpInside];
    self.primu.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.primu];
    
    //le bouton d'acces aux preferences
    UIButton *prefBouton = [UIButton buttonWithType:UIButtonTypeSystem] ;
    prefBouton.tintColor = [UIColor colorWithWhite:.8 alpha:1];
    prefBouton.frame = CGRectMake(10, 20, 30, 30);
    UIImage *btn = [UIImage imageNamed:@"prefs.png"];
    [prefBouton setImage:btn forState:UIControlStateNormal];
    [prefBouton addTarget:self
                   action:@selector(preferences:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prefBouton];
    
    //la zone de saisie du texte et son bouton d'effacement
    self.searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 66, self.view.frame.size.width - 60, 35)];
    [self.searchText setBorderStyle:UITextBorderStyleRoundedRect];
    //le bouton d'effacement
    UIButton *effaceBouton= [UIButton buttonWithType:UIButtonTypeCustom];
    [effaceBouton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    effaceBouton.frame = CGRectMake(0,0, 24, 20);
    [effaceBouton addTarget:self
                     action:@selector(clearTextField:)
           forControlEvents:UIControlEventTouchUpInside];
    self.searchText.rightViewMode = UITextFieldViewModeWhileEditing;
    self.searchText.rightView = effaceBouton;
    
    self.searchText.font = self.gio;
    self.searchText.textColor = [UIColor whiteColor];
    [self.searchText setAutocorrectionType:UITextAutocorrectionTypeNo],
    [self.searchText setBackgroundColor:[UIColor colorWithRed:0.000 green:0.000 blue:0.200 alpha:0.850]];
    //on interroge la base a chaque lettre tapée (editingChanged)
    [self.searchText addTarget:self
                  action:@selector(editingChanged:)
        forControlEvents:UIControlEventEditingChanged];
    self.searchText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.searchText];
    //on range le clavier
    [self.searchText addTarget:self
                  action:@selector(enleveClavier)
        forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //un tableau avec les suggestions
    self.suggestTableView=[[UITableView alloc] initWithFrame:CGRectMake(30, 115, self.view.frame.size.width - 60, self.view.frame.size.height - 286)];
    self.suggestTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.suggestTableView.delegate = self;
    self.suggestTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.suggestTableView.backgroundColor = [[UIColor alloc] initWithWhite:0.5 alpha:0.08];
    self.suggestTableView.dataSource = self;
    self.suggestTableView.rowHeight = 28;
    [self.view addSubview:self.suggestTableView];
}

//la croix d'effacement
-(void)clearTextField:(id)sender {
    self.searchText.text = @"";
}

-(void)editingChanged:(id)sender {
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
   	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //cas ou on selectionne la suggestion -> definition du mot direct
    afficheMotViewController *motVC=[[afficheMotViewController alloc] init];
    motVC.searchText = self.suggest[indexPath.row];
    motVC.alangue = self.alangue;
    motVC.params = self.params;
    motVC.gio = self.gio;
    [self.navigationController pushViewController:motVC animated:YES];
}

//si le mot a ete tape en entier et que "enter" a ete presse -> nouveau tableau avec toutes les possibilités associées au mot
-(BOOL)enleveClavier {
    resultViewController *risultatiVC=[[resultViewController alloc] init];
    risultatiVC.params = self.params;
    risultatiVC.alangue = self.alangue;
    risultatiVC.searchText = self.searchText.text;
    risultatiVC.title = self.searchText.text;
    risultatiVC.gio = self.gio;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (![risultatiVC.searchText isEqualToString:@""]){
        [self.navigationController pushViewController:risultatiVC animated:YES];
    }
    [self.searchText resignFirstResponder];
  return YES;
}

//redimensionnement des suggestions en fonction de la taille du clavier
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize keySize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect newTable = self.suggestTableView.frame;
    newTable.size.height = self.view.frame.size.height - 115 - MIN(keySize.height, keySize.width);
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

-(void)viewWillDisappear:(BOOL)animated {
}
@end
