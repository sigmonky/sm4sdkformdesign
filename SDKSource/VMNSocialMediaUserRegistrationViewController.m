#import "VMNSocialMediaUserRegistrationViewController.h"

//Import Form Table View UI
#import "VMNSocialMediaUserRegistrationFormViewController.h"

#define kViewHeight CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define kViewWidth  CGRectGetWidth([UIScreen mainScreen].applicationFrame)


@interface VMNSocialMediaUserRegistrationViewController ()

@end

@implementation VMNSocialMediaUserRegistrationViewController

@synthesize delegate = _delegate;
@synthesize formFields;
@synthesize navigationController = _navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithDelegate:(id<VMNSocialMediaUserRegistrationCompletionDelegate>)feedbackDelegate{
	self = [super init];
	if (self != nil) {
		_delegate = feedbackDelegate;
        _navigationController = [[UINavigationController alloc] init];

	}
	return self;
}

-(void) close_clicked:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad{
    [self.view setFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
    self.navigationController.view.frame = self.view.frame;
    
    VMNSocialMediaUserRegistrationFormViewController *formView = [[VMNSocialMediaUserRegistrationFormViewController alloc] init];
    
    formView.formFields = self.formFields;
    formView.delegate = self;
    
    [self.navigationController pushViewController:formView animated:YES];
    [formView release];
    
    self.navigationController.delegate = self;
    [self.view addSubview:self.navigationController.view];
}

- (void) closeButtonClick {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self.view removeFromSuperview];
}


#pragma mark VMNSocialMediaRequestDelegate

- (void)closeForm{
    
//    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self dismissModalViewControllerAnimated:YES];
//    }else{
////        [self.view removeFromSuperview];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark VMNSocialMediaUserRegistrationCompletionDelegate

- (void)registrationDidComplete:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(userRegistrationDidComplete:)]) {
        [_delegate userRegistrationDidComplete:error];
    }
    [self closeForm];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [super dealloc];
    self.navigationController = nil;
    self.formFields = nil;
    self.delegate = nil;

}
@end
