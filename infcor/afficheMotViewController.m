//
//  afficheMotViewController.m
//  INFCOR
//
//  Created by admin notte on 16/08/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "afficheMotViewController.h"

@interface afficheMotViewController ()

@end

@implementation afficheMotViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = self.searchText;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"params %@", self.params[self.alangue]);
    // id : traduction du mot en corse, toujours présent au retour de la requete. On fait le choix d'imposer la traduction du mot recherché. id ne dois pas etre present pour la requete mais apres
    if([self.alangue isEqualToString:@"mot_corse"]){
        [self.params[@"dbb_query"] insertObject:@"FRANCESE" atIndex:0];
        [self.params[@"mot_corse"] insertObject:@"FRANCESE" atIndex:0];
    }else{
        [self.params[@"mot_francais"] insertObject:@"CORSU : " atIndex:0];
    }
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue,[self.params[@"dbb_query"] componentsJoinedByString:@" "] ];
    if([self.alangue isEqualToString:@"mot_francais"]){[self.params[@"dbb_query"] insertObject:@"id" atIndex:0 ];}
    cercaURL = [cercaURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [risultatiVC setSearchURL:[NSURL URLWithString:cercaURL]];
    NSURL *cerca = [NSURL URLWithString:cercaURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cerca];
    NSLog(@"cerca : %@",cercaURL);
    // Requete synchrone
    NSData *theData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:nil
                                                        error:nil];
    
    self.risultati = [NSJSONSerialization JSONObjectWithData:theData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];

    self.title = self.searchText;
    NSLog(@"Sync JSON: %@", self.risultati);
    NSLog(@"les params %@",self.params[@"dbb_query"]);
 //   NSLog(@"JSON ligne 0 : %@",[self.risultati valueForKey:@"DEFINIZIONE"]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.afficheMotTableView=[[UITableView alloc] init];
    self.afficheMotTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.afficheMotTableView.delegate = self;
    self.afficheMotTableView.dataSource = self;
    [self.afficheMotTableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

//    [self afficheMot:self.alangue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.params[self.alangue] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSLog(@"cell %@",cellIdentifier);
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
    cell.textLabel.font = arial;
    if ([self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]) {cell.textLabel.text = [self.params[self.alangue][indexPath.row] stringByAppendingString:[self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]];}
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(300,9999);
    NSLog(@"la cle %@,  la valeur %@",self.params[self.alangue][indexPath.row], [self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]);
    UIFont *arial= [UIFont fontWithName:@"arial" size:15];
//    NSLog(@"recherche %@",[self.params[self.alangue][indexPath.row] stringByAppendingString:[self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]]);
    CGRect titleRect = [self rectForText:[self.params[self.alangue][indexPath.row] stringByAppendingString:[self.risultati valueForKey:self.params[@"dbb_query"][indexPath.row]][0]]
                               usingFont:arial
                           boundedBySize:maximumLabelSize];
    return titleRect.size.height + 10;
}

-(CGRect)rectForText:(NSString *)text
           usingFont:(UIFont *)font
       boundedBySize:(CGSize)maxSize
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:font}];
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    if ([[self.params[@"dbb_query"] firstObject] isEqualToString:@"FRANCESE"]) {
            [self.params[@"dbb_query"] removeObject:@"FRANCESE"];
            [self.params[@"mot_corse"] removeObject:@"FRANCESE"];
            NSLog(@"a enleve fcese");
    }
    else if ([[self.params[@"dbb_query"] firstObject] isEqualToString:@"id" ]) {
            [self.params[@"dbb_query"] removeObject:@"id"];
            [self.params[@"mot_francais"] removeObject:@"CORSU : "];}

}
@end
