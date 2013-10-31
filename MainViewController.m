//
//  ViewController.m
//  SM4SDK
//
//  Created by Xue, Yi Ning on 8/26/13.
//  Copyright (c) 2013 Dasilva, Isaac. All rights reserved.
//

#import "MainViewController.h"
#import "StringInputTableViewCell.h"
#import "LoginTableViewCell.h"
#import "VMNSocialMediaMediator.h"
#import "CommentingViewController.h"
#import "ActionsViewController.h"
#import "FluxUserViewController.h"
#import "TrackShareViewController.h"
#import "SentimentsViewController.h"
#import "CommentsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)dealloc
{
    self.tableViewItems = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Viacom Social Media SDK"];
    
    self.userNameIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    self.passwordIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Build the array from the plist
//    NSBundle* bundle = [NSBundle mainBundle];
//    NSString* plistPath = nil;
//    plistPath = [bundle pathForResource:@"data" ofType:@"plist"];
//    NSMutableArray* plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//    self.tableViewItems = plist;
    [self refreshUI];
//    if ([[VMNSocialMediaMediator sharedInstance] isAuthenticatedOnFlux]){
//        plistPath = [bundle pathForResource:@"loggedIn" ofType:@"plist"];
//        NSMutableArray* plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//        self.tableViewItems = plist;
//    } else {
//        plistPath = [bundle pathForResource:@"data" ofType:@"plist"];
//        NSMutableArray* plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//        self.tableViewItems = plist;
//    }

}

- (void)viewDidAppear:(BOOL)animated
{
//    [self refreshUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    NSLog(@"number of sections = %d", [self.tableViewItems count]);
    return [self.tableViewItems count];
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    NSDictionary *tableSection = [self.tableViewItems objectAtIndex:section];
    return [(NSArray*)[tableSection objectForKey:@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tableSection = [self.tableViewItems objectAtIndex:indexPath.section];
    NSMutableArray *items = [tableSection objectForKey:@"items"];
    NSDictionary *row = [items objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [row objectForKey:@"label"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([[row objectForKey:@"type"] isEqualToString:@"input"]) {
        static NSString *CellIdentifier = @"InputCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [row objectForKey:@"label"];
        ((StringInputTableViewCell*)cell).textField.placeholder = [row objectForKey:@"placeholder"];
        ((StringInputTableViewCell*)cell).textField.text = @"";
        
        if ([cell.textLabel.text isEqualToString:@"Password"]) {
            ((StringInputTableViewCell*)cell).textField.secureTextEntry = YES;
        } else if ([cell.textLabel.text isEqualToString:@"User Name"]) {
            ((StringInputTableViewCell*)cell).textField.secureTextEntry = NO;
        }

        return cell;
    }
    else if ([[row objectForKey:@"type"] isEqualToString:@"login"]) {
        static NSString *CellIdentifier = @"LoginCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[LoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [row objectForKey:@"label"];
        
//        if ([[VMNSocialMediaMediator sharedInstance] isAuthenticatedOnFlux]){
//            
//            if (indexPath.row==0 && indexPath.section==1)
//            {
//                cell.textLabel.text = @"Logout from Flux";
//            }
//        }
        
        return cell;
    }
    else if ([[row objectForKey:@"type"] isEqualToString:@"disclosure"]) {
        VMNSocialMediaSession *session = [[VMNSocialMediaMediator sharedInstance] socialMediaSession];
        NSLog(@"profile = %@", session.currentUser.fluxProfile);
        NSString *userName = [session.currentUser.fluxProfile objectForKey:@"Title"];
        cell.textLabel.text = userName;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tableSection = [self.tableViewItems objectAtIndex:section];
    NSString *sectionName = [tableSection objectForKey:@"header"];
    return sectionName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSDictionary *tableSection = [self.tableViewItems objectAtIndex:section];
    NSString *sectionName = [tableSection objectForKey:@"footer"];
    return sectionName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get user name and password value
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *tableSection = [self.tableViewItems objectAtIndex:indexPath.section];
    NSArray *items = [tableSection objectForKey:@"items"];
    NSDictionary *row = [items objectAtIndex:indexPath.row];
    
    if (indexPath.row==0 && indexPath.section==0)
    {
        if ([[row objectForKey:@"type"] isEqualToString:@"disclosure"]) {
            [self viewFluxProfile];
        }
    }
    // Login with Flux
    if ([cell.textLabel.text isEqualToString:@"Login with Flux"] || [cell.textLabel.text isEqualToString:@"Sign out"])
    {
        [self fluxLoginButtonClicked:tableView indexPath:indexPath];
    }
    else if ([cell.textLabel.text isEqualToString:@"Login with Facebook"])
    {
        [self fbLoginButtonClicked];
    }
    // Login with Twitter
    else if ([cell.textLabel.text isEqualToString:@"Login with Twitter"])
    {
        [self twitterLoginButtonClicked:cell];
    }
    else if ([cell.textLabel.text isEqualToString:@"Create Account"])
    {
        [self createAccount];
    }
    else if ([cell.textLabel.text isEqualToString:@"Comments"])
    {
        [self viewCommentsDemo];
    }
    else if ([cell.textLabel.text isEqualToString:@"Activities"])
    {
        [self viewActionsDemo];
    }
    else if ([cell.textLabel.text isEqualToString:@"Track Share"])
    {
        [self viewTrackShareDemo];
    }
    else if ([cell.textLabel.text isEqualToString:@"Sentiment Tags"])
    {
        [self viewSentimentTagsDemo];
    }
}

- (void)refreshUI
{
    if ([[VMNSocialMediaMediator sharedInstance] isAuthenticatedOnFlux]){
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* plistPath = [bundle pathForResource:@"loggedIn" ofType:@"plist"];
        NSMutableArray* plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        self.tableViewItems = plist;
        [self.tableView reloadData:YES];
        
    } else {
        
        // Not authenticated on Flux
        NSBundle* bundle = [NSBundle mainBundle];
        NSString* plistPath = [bundle pathForResource:@"data" ofType:@"plist"];
        NSMutableArray* plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        self.tableViewItems = plist;
        [self.tableView reloadData:YES];
        
        [[VMNSocialMediaMediator sharedInstance].socialMediaSession removeTwitterLocalCredentials];
        [[VMNSocialMediaMediator sharedInstance].socialMediaSession removeZeeBoxLocalCredentials];
        [[VMNSocialMediaMediator sharedInstance].socialMediaSession removeFluxLocalCredentials];
        [[VMNSocialMediaMediator sharedInstance].socialMediaSession removeFacebookLocalCredentials];
    }
//    }
}

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value
{
    NSLog(@"finished editing");
}

-(void)fluxLoginButtonClicked:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *user = nil;
    NSString *password = nil;
    if ([[tableView cellForRowAtIndexPath:self.userNameIndexPath] class] == [StringInputTableViewCell class]) {
        cell = (StringInputTableViewCell*)[tableView cellForRowAtIndexPath:self.userNameIndexPath];
        ((StringInputTableViewCell *)cell).delegate = self;
        if ([cell.textLabel.text isEqualToString:@"User Name"]) {
            user = ((StringInputTableViewCell *)cell).textField.text;
        }
    }
    
    if ([[tableView cellForRowAtIndexPath:self.passwordIndexPath] class] == [StringInputTableViewCell class]) {
        cell = (StringInputTableViewCell*)[tableView cellForRowAtIndexPath:self.passwordIndexPath];
        ((StringInputTableViewCell*)cell).delegate = self;
        if ([cell.textLabel.text isEqualToString:@"Password"]) {
            password = ((StringInputTableViewCell*)cell).textField.text;
        }
    }
    
    [[VMNSocialMediaMediator sharedInstance] fluxAuthInView:self username:user password:password completion:^( NSError *error)
    {
        if (error == nil)
        {
            // Flux login has been successfull
            NSLog(@"successful login");
        }
        else
        {
            //handle error
            NSString *errorMsg = [error localizedDescription];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flux Error" message:errorMsg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            });
        }
        [self refreshUI];
    }];
}

-(void)fbLoginButtonClicked {
    [[VMNSocialMediaMediator sharedInstance] facebookAuthInView:self
                                                  fbPermissions:@[@"read_friendlists",@"xmpp_login", @"friends_online_presence", @"read_mailbox"]
                                                     completion:^( NSError *error) {
        if (error == nil){
            // Facebook login has been successfull
        }else{
            //handle error
            NSString *errorMsg = [error localizedDescription];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            });
        }
        
        // Referesh UI to show change in the authentication state.
        [self refreshUI];
        
    }];
}



-(void)twitterLoginButtonClicked:(UITableViewCell*)cell {
    UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    [activityView startAnimating];
    [cell setAccessoryView:activityView];
    
    [[VMNSocialMediaMediator sharedInstance] twitterAuthInView:self completion:^( NSError *error) {
        if (error == nil){
            // Twitter login has been successfull
            [activityView stopAnimating];
            [cell setAccessoryView:nil];
            NSLog(@"twitter login successful");
        }else{
            [activityView stopAnimating];
            //handle error
            NSString *errorMsg = [error localizedDescription];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            });
            
        }
        
        // Referesh UI to show change in the authentication state.
        [self refreshUI];
        
    }];
}

- (void)createAccount
{
    // Create an Account with Flux
    [[VMNSocialMediaMediator sharedInstance] registerFluxUserInView:self.navigationController completion:^( NSError *error) {
        if (error == nil){
            // Flux user registration has been successfull
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"You have been successfully registered." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            // Get Viacom Flux User Profile. User information is stored in the property 'currentUser' of VMNSocialMediaSession.
            [[VMNSocialMediaMediator sharedInstance] fluxUserProfile:^( NSError *error){
                if (error == nil){
                    // Referesh UI to show change in the authentication state.
                    [self refreshUI];
                }
                
            }];
            
        }else{
            // Show error message
            NSString *errorMsg = [error localizedDescription];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }];
}

-(void)viewFluxProfile
{
    FluxUserViewController *fluxUserProfile = [[FluxUserViewController alloc]init];
//    fluxUserProfile.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:fluxUserProfile animated:YES];
}

-(void)viewCommentsDemo {
    NSLog(@"Starting Commenting Demo");
    
    /*NSString *xibName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"CommentingViewController_iPad" : @"CommentingViewController_iPhone";
    CommentingViewController *actionsHubController = [[CommentingViewController alloc] initWithNibName:xibName bundle:nil];
//    actionsHubController.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:actionsHubController];
    navigationController.navigationItem.title = @"Actions";
    [self presentViewController:navigationController animated:YES completion:nil];
     */
    NSString *xibName = @"CommentsViewController";
    
    CommentsViewController *commentsViewController = [[CommentsViewController alloc] initWithNibName:xibName bundle:nil];
    //    actionsViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:commentsViewController];
    navigationController.navigationItem.title = @"Comments";
    
    [self presentViewController:navigationController animated:YES completion:nil];

    
}

-(void)viewActionsDemo {
    NSString *xibName = @"ActionsViewController";
    
    ActionsViewController *actionsViewController = [[ActionsViewController alloc] initWithNibName:xibName bundle:nil];
//    actionsViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:actionsViewController];
    navigationController.navigationItem.title = @"Actions";
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

-(void)viewTrackShareDemo {
    NSString *xibName = @"TrackShareViewController";
    
    TrackShareViewController *trackShareViewController = [[TrackShareViewController alloc] initWithNibName:xibName bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:trackShareViewController];
    navigationController.navigationItem.title = @"Actions";
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

-(void)viewSentimentTagsDemo {
    NSString *xibName = @"SentimentsViewController";
    
    SentimentsViewController *sentimentsViewController = [[SentimentsViewController alloc] initWithNibName:xibName bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:sentimentsViewController];
    navigationController.navigationItem.title = @"Sentiment Tags";
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
