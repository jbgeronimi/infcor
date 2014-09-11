 //
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "detailViewController.h"
#import "contactViewController.h"


@interface resultViewController ()

@end

@implementation resultViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.searchURL];
    //    [self.resultTableView reloadData];
    // Requete synchrone
    if(!self.risultati){
        NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:nil
                                                            error:nil];
        // Si pas de résultats, affichage d'un msg d'erreur
        if (!theData) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas de Connexion"
                                                            message:@"la banque INFCOR a besoin de se connecter à internet. Verifiez votre connexion"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }else {
            self.risultati = [NSJSONSerialization JSONObjectWithData:theData
                                                             options:0
                                                               error:nil];
            NSLog(@"risultati %@",self.risultati);
            if (self.risultati.count == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas de Résultat"
                                                                message:@"la banque INFCOR n'a pas de réponse à proposer a votre requete"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"contacter l'ADECEC", nil];
                [alert show];
            }
        }
        // id : traduction du mot en corse, toujours présent au retour de la requete. On fait le choix d'imposer la traduction du mot recherché. id ne dois pas etre present pour la requete mot_francais mais apres
    }
    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }else if(([self.alangue isEqualToString:@"mot_francais"]) & !([self.params[@"dbb_query"] containsObject:@"id"])){
        [self.params[@"dbb_query"] insertObject:@"id" atIndex:0 ];
        [self.params[@"mot_francais"] insertObject:@"CORSU : " atIndex:0];
    }
    [self.resultTableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //       self.title = [self.detailRisultati valueForKey:self.params[@"dbb_query"][0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.resultTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 640) style:UITableViewStylePlain];
    self.resultTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.separatorStyle = UITableViewCellSelectionStyleNone;

    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }
    //cas du mot_francais : id(CORSU) est ajouté apres, dans view did appear
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/debut.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue,[self.params[@"dbb_query"] componentsJoinedByString:@" "] ];
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [risultatiVC setSearchURL:[NSURL URLWithString:cercaURL]];
    self.searchURL = [NSURL URLWithString:cercaURL];
}

-(void)alertView:(UIAlertView *)alarm clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        contactViewController *contact = [[contactViewController alloc]init];
        NSString *txtContact = @"http://adecec.net/infcor/contact.php?mot=";
        txtContact = [txtContact stringByAppendingString:self.searchText];
        NSURLRequest *urlContact = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:txtContact]];
        contact.urlContact = urlContact;
        [self.navigationController pushViewController:contact animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.risultati.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//a definir en fonction des resultats renvoyes par la base
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.risultati[indexPath.row][@"id"];
    cell.textLabel.font = self.gio;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    detailViewController *detVC = [[detailViewController alloc] init];
    detVC.detailRisultati = self.risultati[indexPath.row];
    detVC.alangue = self.alangue;
    detVC.params = self.params;
    detVC.title = self.searchText;
    detVC.gio = self.gio;

    [self.navigationController pushViewController:detVC animated:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.resultTableView reloadData];
//    [super viewDidAppear:animated];
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
