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
    self.allParams = @{
        @"dbb_query":@[@"TALIANU",@"INGLESE",@"NATURA",@"PRUNUNCIA",@"DEFINIZIONE",@"ETIMULUGIA",@"GRAMMATICA",@"VARIANTESD",@"SINONIMI",@"ANTONIMI",@"DERIVADICOMPOSTI",@"SPRESSIONIEPRUVERBII",@"ANALUGIE",@"CITAZIONIDAAUTORI",@"BIBLIOGRAFIA",@"INDICE"],
        @"mot_corse": @[@"TALIANU",@"INGLESE",@"NATURA",@"PRUNUNCIA",@"DEFINIZIONE",@"ETIMULUGIA",@"GRAMMATICA",@"VARIANTESD",@"SINONIMI",@"ANTONIMI",@"DERIVATI COMPOSTI",@"SPRESSIONI E PRUVERBII",@"ANALUGIE",@"CITAZIONI DA AUTORI",@"BIBLIOGRAFIA",@"INDICE"],
    @"mot_francais" : @[@"ITALIEN",@"ANGLAIS",@"GENRE",@"PRONONCIATION",@"DEFINITION EN CORSE",@"ETYMOLOGIE",@"GRAMMAIRE",@"VARIANTES GRAPHIQUES",@"SYNONYMES",@"ANTONYMES",@"DERIVES COMPOSES",@"EXPRESSIONS ET PROVERBES",@"ANALOGIES",@"CITATIONS D'AUTEURS",@"BIBLIOGRAPHIE",@"INDICE"]
                    };
// un tableau avec tous les elements de params
    self.afficheParams=[[UITableView alloc] init];
    self.afficheParams.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.afficheParams.delegate = self;
    self.afficheParams.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (self.modalPresentationStyle == UIModalPresentationCustom) {
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    UIButton *vabe = [UIButton buttonWithType:UIButtonTypeSystem];
 //   vabe.frame = CGRectMake(100, 800, 40, 20);
    [vabe setTitle:@"OK" forState:UIControlStateNormal];
    [vabe addTarget:self action:@selector(goodJob:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vabe];
    return vabe;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allParams[self.alangue] count ];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    cell.textLabel.font = arial;
//    self.lindex = indexPath;
    cell.textLabel.text = self.allParams[self.alangue][indexPath.row];
    NSLog(@"params : %@",self.allParams[self.alangue][indexPath.row]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setTag:indexPath.row];
    [switchView setOn:[self.params[self.alangue] containsObject:self.allParams[self.alangue][indexPath.row]] animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    NSLog(@"etat switch %hhd",switchView.isOn);
    return cell;
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if(switchControl.isOn){
//        NSLog(@"contient : %@", [self.params[self.alangue] containsObject:self.allParams[self.alangue][switchControl.tag]] ? @"oui": @"non");
//        NSLog(@"a ajouter : %@",self.allParams[@"dbb_query"][switchControl.tag]);
        if (![self.params[self.alangue] containsObject:self.allParams[self.alangue][switchControl.tag]]){
            NSLog(@"ajouté");
            [self.params[@"dbb_query"] addObject:self.allParams[@"dbb_query"][switchControl.tag]];
            [self.params[@"mot_corse"] addObject:self.allParams[@"mot_corse"][switchControl.tag]];
            [self.params[@"mot_francais"] addObject:self.allParams[@"mot_francais"][switchControl.tag]];
            NSLog(@"params %@", self.params);
        }
    }
    if (!switchControl.isOn){
        if ([self.params[self.alangue] containsObject:self.allParams[self.alangue][switchControl.tag]]){
        NSLog(@"efface");
        [self.params[@"dbb_query"] removeObject:self.allParams[@"dbb_query"][switchControl.tag]];
        [self.params[@"mot_corse"] removeObject:self.allParams[@"mot_corse"][switchControl.tag]];
        [self.params[@"mot_francais"] removeObject:self.allParams[@"mot_francais"][switchControl.tag]];
        }
    }
    if(switchControl.on){
    }
   // NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
}

- (IBAction) goodJob:(id)sender;
{
    NSLog(@" dbb_selct %@",self.params[@"dbb_query"]);
    ViewController *VC = [[ViewController alloc] init];
    VC.params = self.params;
    [self dismissViewControllerAnimated:YES completion:nil];
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
