 //
//  motViewController.m
//  infcor
//
//  Created by admin notte on 30/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "motViewController.h"
#import "AppDelegate.h"

@interface motViewController ()

@end

@implementation motViewController

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = self.searchText;
    }
    return self;
}

- (void)loadView {
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize=CGSizeMake(320,758);
    
    // do any further configuration to the scroll view
    // add a view, or views, as a subview of the scroll view.
    
    // release scrollView as self.view retains it
    self.view=scrollView;
//    [scrollView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"params %@", self.params[self.alangue]);
    NSString *cercaURL = [NSString stringWithFormat:@"http://adecec.net/infcor/try/traitement.php?mot=%@&langue=%@&param=%@", self.searchText, self.alangue, [self.params[@"mot_corse"] componentsJoinedByString:@" "]];
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
    NSLog(@"JSON ligne 0 : %@",[self.risultati valueForKey:@"DEFINIZIONE"]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self afficheMot:self.alangue];
}

-(void)afficheMot:(id)sender {
    if([sender isEqualToString:@"mot_corse"]){
        UILabel *motDef = [[UILabel alloc] init];
        CGRect viewrect = CGRectMake(10, 60, 300, 20);
        UIView *vueDeMot = [[UIView alloc] initWithFrame:viewrect];
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSInteger p=0; p < [self.params[@"mot_corse"] count]; p ++) {
            CGFloat offset;
            offset = 0 + offset;
            CGSize maximumLabelSize = CGSizeMake(300,9999);
            motDef.text = [self.params[self.alangue][p] stringByAppendingString:[self.risultati valueForKey:self.params[@"mot_corse"][p]][0]];
            NSLog(@"pour la clef %@",[self.risultati valueForKey:self.params[@"mot_corse"][p]][0]);
            UIFont *arial= [UIFont fontWithName:@"arial" size:14];
            CGRect titleRect = [self rectForText:motDef.text
                                       usingFont:arial
                                   boundedBySize:maximumLabelSize];
    //        motDef.textAlignment = NSTextAlignmentCenter;
            motDef.frame = CGRectMake(10, 60 + offset, titleRect.size.width, titleRect.size.height + 20);
            motDef.font = arial;
            offset = offset + motDef.frame.size.height;
            viewrect = CGRectMake(10, offset, titleRect.size.width, titleRect.size.height + 20);
            [vueDeMot addSubview:motDef];
    //        motDef.editable = NO;
            NSLog(@"offset : %f",offset);
//            [self.view setValue:vueDeMot forKey:[NSString stringWithFormat:@"label ,%d",p]];
            [tmp insertObject:motDef atIndex:p];
        NSLog(@"la matrice %@", tmp);
            [motDef setNumberOfLines:0];
    //        [motDef textRectForBounds:CGRectMake(10, 50, textSize.width, textSize.height) limitedToNumberOfLines:10];
    //        [motDef adjustsFontSizeToFitWidth];
            
            motDef.autoresizingMask = UIViewAutoresizingFlexibleWidth;
         }
        [self.view addSubview:vueDeMot];
    }
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
