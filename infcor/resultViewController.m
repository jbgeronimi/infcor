 //
//  resultViewController.m
//  infcor
//
//  Created by admin notte on 26/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "resultViewController.h"
#import "afficheMotViewController.h"
#import "detailViewController.h"
#import "contactViewController.h"
//#import "AFJSONRequestOperation.h"
//#import "AFNetworking.h"

@interface resultViewController ()

@end

@implementation resultViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 //       self.title = self.searchText;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //cas de mot_corse, il faut faire la ajouter FRANCESE a dbb_query
    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }
    //cas du mot corse, CORSU : est ajouté apres, dans view did appear
    
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue,[self.params[@"dbb_query"] componentsJoinedByString:@" "] ];
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [risultatiVC setSearchURL:[NSURL URLWithString:cercaURL]];
    NSURL *cerca = [NSURL URLWithString:cercaURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cerca];
    NSLog(@"cerca : %@",cercaURL);
// Requete synchrone
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
        if (self.risultati.count == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas de Résultat"
                                                            message:@"la banque INFCOR n'a pas de réponse à proposer a votre requete"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"contacter l'ADECEC", nil];
            [alert show];
        }
    NSLog(@"Sync JSON: %@", self.risultati);
    }
}

-(void)alertView:(UIAlertView *)alarm clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(buttonIndex == 1){
        contactViewController *contact = [[contactViewController alloc]init];
        NSString *txtContact = @"http://infcor.adecec.net/mailInfcor.php?moterrone=";
        [txtContact stringByAppendingString:self.searchText];
        NSURLRequest *urlContact = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:txtContact]];
        contact.urlContact = urlContact;
        [self.navigationController pushViewController:contact animated:YES];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    // id : traduction du mot en corse, toujours présent au retour de la requete. On fait le choix d'imposer la traduction du mot recherché. id ne dois pas etre present pour la requete mot_francais mais apres
    if(([self.alangue isEqualToString:@"mot_corse"]) && !([self.params[@"dbb_query"] containsObject:@"FRANCESE"])){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }else if(([self.alangue isEqualToString:@"mot_francais"]) & !([self.params[@"dbb_query"] containsObject:@"id"])){
        [self.params[@"dbb_query"] insertObject:@"id" atIndex:0 ];
        [self.params[@"mot_francais"] insertObject:@"CORSU : " atIndex:0];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
//a definir en fonction des resultats renvoyes par la base
    cell.textLabel.text = self.risultati[indexPath.row][@"id"];
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
