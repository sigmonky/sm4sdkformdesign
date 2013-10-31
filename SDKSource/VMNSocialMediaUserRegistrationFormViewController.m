#import "VMNSocialMediaUserRegistrationFormViewController.h"
#import "VMNSocialMediaCountrySelectionViewController.h"
#import "VMNSocialMediaSession.h"
#import "VMNSocialMediaFluxUtils.h"
#import "VMNSocialMediaUICheckbox.h"
#import "VMNSocialMediaBrowserView.h"
#import "VMNSocialMediaUIActionSheetWithDismiss.h"
#import "VMNSocialMediaConstants.h"
#import "VMNSocialMediaFluxLoginViewController.h"

@interface VMNSocialMediaUserRegistrationFormViewController ()

@end

@implementation VMNSocialMediaUserRegistrationFormViewController

//@synthesize mainTable = _mainTable;
@synthesize delegate = _delegate;
@synthesize fieldNames = _fieldNames;
@synthesize fieldData = _fieldData;
@synthesize textFieldProto = _textFieldProto;
@synthesize entryFields = _entryFields;
@synthesize textFieldBeingEdited = _textFieldBeingEdited;
@synthesize formFields;
@synthesize navBarTintColor = _navBarTintColor;
@synthesize navBarBtnTxtColor = _navBarBtnTxtColor;
@synthesize navBarTitleTxt = _navBarTitleTxt;
@synthesize navBarTitleTxtFont = _navBarTitleTxtFont;
@synthesize navBarTitleTxtColor = _navBarTitleTxtColor;
@synthesize navBarTitleTxtBgColor = _navBarTitleTxtBgColor;
@synthesize tableViewBgColor = _tableViewBgColor;
@synthesize tableViewSeparatorColor = _tableViewSeparatorColor;
@synthesize tableViewCellBgColor = _tableViewCellBgColor;
@synthesize footerViewBgColor = _footerViewBgColor;
@synthesize checkBoxLblValidTxtColor = _checkBoxValidTxtColor;
@synthesize checkBoxLblInvalidColor = _checkBoxLblInvalidColor;
@synthesize checkBoxLblBgColor = _checkBoxBgColor;
@synthesize checkBoxLblTxtFont = _checkBoxLblTxtFont;
@synthesize checkBoxLblLinkColor = _checkBoxlLblLinkColor;
@synthesize submitBtnFont = _submitBtnFont;
@synthesize submitBtnTitleColor = _submitBtnTitleColor;



@synthesize labels;
@synthesize inputFields;
@synthesize placeholders;

@synthesize missingFields;
@synthesize tocCheckBoxes;
@synthesize tocCheckBoxesUI;

@synthesize browserView = _browserView;
@synthesize doneButton = _doneButton;

#define kLabelTag   4096
#define kTextTag    4097

#define toc_line_width_iPhone  250.0
#define toc_line_width_iPad  430.0




- (void) viewWillAppear:(BOOL)animated
{
    [missingFields removeAllObjects];
    [self setValidationForLocation];
    
    /* Hack for Numeric Pad */
    
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    [super viewWillAppear:animated];
    
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = navBarTitleTxtBgColor;
    label.font = navBarTitleTxtFont; 
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = navBarTitleTxtColor; 
    label.text = self.navigationItem.title;
    label.numberOfLines = 0;
    // emboss in the same way as the native title
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    self.navigationItem.titleView = label;
    
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [super viewWillDisappear:animated];
    
    
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}



/* Hack for Numeric Pad */
- (void)createDoneButton {
	// create custom button
    if (_doneButton == nil) {
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.frame = CGRectMake(0, 163, 106, 53);
        self.doneButton.adjustsImageWhenHighlighted = NO;
        
        [self.doneButton setImage:[UIImage imageWithContentsOfFile:[[self frameworkBundle] pathForResource:@"DoneUp3" ofType:@"png"]] forState:UIControlStateNormal];
        [self.doneButton setImage:[UIImage imageWithContentsOfFile:[[self frameworkBundle] pathForResource:@"DoneDown3" ofType:@"png"]] forState:UIControlStateHighlighted];
        
        [self.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        self.doneButton.hidden = YES;  // we hide/unhide him from here on in with the appropriate method
    }
}

/* Hack for Numeric Pad */

- (void)unhideDoneButton
{
    // this here is a check that prevents NSRangeException crashes that were happening on retina devices
    int windowCount = [[[UIApplication sharedApplication] windows] count];
    if (windowCount < 2) {
        return;
    }
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex: 1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        
        // so the first time you unhide, it gets put on one subview, but in subsequent tries, it gets put on another.  this is why we have to keep adding and removing him from its superview.
        
        // THIS IS THE HACK BELOW.  I MEAN, PROPERLY HACKY!
        if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
        {
            [keyboard addSubview: self.doneButton];
        }
        else if([[keyboard description] hasPrefix:@"<UIKeyboardA"] == YES)
        {
            [keyboard addSubview: self.doneButton];
        }
    }
    self.doneButton.hidden = NO;
}


/* Hack for Numeric Pad */

- (void)keyboardDidShow:(NSNotification *)note {
    NSIndexPath *path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    if ([[(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] rightTextField] isFirstResponder]) {
        NSString *label = [self.labels objectAtIndex:_fieldBeingEdited];
        if ([label isEqualToString:@"Mobile Phone"] || [label isEqualToString:@"Zip Code"]){
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                [self unhideDoneButton];  // self.numField is firstResponder and the one that caused the keyboard to pop up
            }
        }
    }
    else
    {
        [self hideDoneButton];
    }
    
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    // unused.
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    // unused
}
- (void)keyboardDidHide:(NSNotification *)notification
{
    // unused
}

/* Hack for Numeric Pad */

- (void)doneButton:(id)sender {
    NSIndexPath *path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    [[(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] rightTextField] resignFirstResponder];
}

- (void)hideDoneButton
{
    [self.doneButton removeFromSuperview];
    self.doneButton.hidden = YES;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    tableViewBgColor = [UIColor blackColor];
    tableViewSeparatorColor = [UIColor greenColor];
    tableViewCellBgColor = [UIColor magentaColor];
    tableRowHeight = 40;
    
    navBarTintColor = [UIColor blackColor];
    navBarBgColor = [UIColor blackColor];
    navBarBtnTxtColor = [UIColor greenColor];
    navBarTitleTxt = @"Comedy Central Signup!!";
    navBarTitleTxtBgColor = [UIColor blackColor];
    navBarTitleTxtColor = [UIColor redColor];
    navBarTitleTxtFont = [UIFont fontWithName:@"Verdana Bold" size:12];
    
    footerViewBgColor = [UIColor blackColor];
    checkBoxLblLinkColor = [UIColor greenColor];
    checkBoxILblnvalidTxtColor = [UIColor redColor];
    checkBoxLblValidTxtColor = [UIColor brownColor];
    checkBoxLblBgColor = [UIColor darkGrayColor];
    checkBoxLblTxtFont = [UIFont fontWithName:@"American Typewriter" size:13];
    
   
    if (tableViewBgColor) {
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = tableViewBgColor;
    }
    
    //[self.navigationController.navigationBar setTintColor:navBarTintColor];
    
    
    /* Hack for Numeric Pad */
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        [self createDoneButton];
    }
    
    missingFields = [[NSMutableArray alloc]init];
            
    isFormValid = true;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    [navBar setBackgroundImage:[UIImage new]
                forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [UIImage new];
    navBar.backgroundColor = navBarBgColor;
    navBar.tintColor = navBarTintColor;
    
        
    if ([[VMNSocialMediaSession sharedInstance] hasFluxLocalCredentials]){
        self.title = ROADBLOCKING_NAVIGATION_BAR_TITLE_ROADBLOCKING;
    }else{
        self.title = navBarTitleTxt; //ROADBLOCKING_NAVIGATION_BAR_TITLE_SIGNUP;
    }
    // UINavigation Bar
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(submitForm)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: navBarBtnTxtColor,  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(closeView)];
    [backButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: navBarBtnTxtColor,  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
    //self.tableView.separatorColor = tableViewSeparatorColor;
    
    self.textFieldProto = [[NSMutableDictionary alloc] init];
    
    self.labels = [[NSMutableArray alloc]init];
    self.inputFields = [[NSMutableArray alloc]init];
    
    self.tocCheckBoxes = [[NSMutableArray alloc]init];
    self.tocCheckBoxesUI = [[NSMutableArray alloc]init];
    
    
    
    for( int i = 0; i < [self.formFields count];i++){
        id aField = [self.formFields objectAtIndex:i];
        
        //Dont display Terms and Agreements in the table view
        if (![[aField objectForKey:@"Field"] isEqualToString:@"AgreementTerms"]){
            [self.labels addObject:[aField objectForKey:@"Label"]];
            [self.inputFields addObject:[aField objectForKey:@"Field"]];
            [self.textFieldProto setObject:@"" forKey:[[aField valueForKey:@"Field"] lowercaseString]];
            NSLog(@"adding field %@",[[aField valueForKey:@"Field"] lowercaseString]);
        }else{
            
            [self.textFieldProto setObject:@"" forKey:@"tos_accepted"];
            // RW fix -- adding AgreementTerms to the inputFields screws up the data entry logic in textLabelAtPath
            //[self.inputFields addObject:[aField objectForKey:@"Field"]];
            
            //get the fields for TOC checkboxesxx
            
            NSString *value = [aField objectForKey:@"Value"];
            if (![value isKindOfClass:[NSNull class]]){
                for (id checkbox in [aField objectForKey:@"Value"]){
                    if (checkbox != nil)[self.tocCheckBoxes addObject:checkbox];
                }
            }
            
        }
    }
    
    footerTotalHeight = 0;
    
    BOOL isIpad = false;
    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        isIpad = true;
    }
    
    for (int i =0; i<[tocCheckBoxes count]; i++){
        
        if (isIpad){
            CGSize theSize = [ [[tocCheckBoxes objectAtIndex:i] objectForKey:@"Text"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0] constrainedToSize:CGSizeMake(toc_line_width_iPad, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            footerTotalHeight = footerTotalHeight + theSize.height + 15;
            
        }else{
            CGSize theSize = [ [[tocCheckBoxes objectAtIndex:i] objectForKey:@"Text"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0] constrainedToSize:CGSizeMake(toc_line_width_iPhone, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            footerTotalHeight = footerTotalHeight + theSize.height + 15;
        }
        
    }
    
    //44 is the height of the submit button
    footerTotalHeight = footerTotalHeight+44;
    
    //44 is the height of the footer header label it's different than nil
    footerTotalHeight = footerTotalHeight+44;
}




- (id)initWithViewLeft: (float)aViewLeft viewTop:(float)aViewTop viewWidth:(float)aViewWidth viewHeight:(float)aViewHeight {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _viewLeft = aViewLeft;
        _viewTop = aViewTop;
        _viewWidth = aViewWidth;
        _viewHeight = aViewHeight;
    }
    return self;
}

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
        return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.browserView = nil;
    self.inputFields = nil;
    self.labels = nil;
    self.doneButton = nil;
    self.tocCheckBoxesUI = nil;
    self.tocCheckBoxes = nil;
    self.missingFields = nil;
    self.formFields = nil;
    self.entryFields = nil;
    self.textFieldBeingEdited = nil;
    self.delegate = nil;
    self.fieldNames = nil;
    self.fieldData = nil;
    self.textFieldProto = nil;
    self.placeholders = nil;
    self.navBarTintColor = nil;
    self.tableViewSeparatorColor = nil;
    self.tableViewCellBgColor = nil;

}


- (BOOL)isFieldRequired:(NSString *)fieldName{
    for( int i = 0; i < [self.formFields count];i++){
        id aField = [self.formFields objectAtIndex:i];
        //Dont display Terms and Agreements in table view
        if ([[aField objectForKey:@"Label"] isEqualToString:fieldName]){
            NSNumber *val = [aField valueForKey:@"Required"];
            BOOL value = [val boolValue];
            if (value){
                return TRUE;
            }else{
                return FALSE;
            }
        }
    }
    return FALSE;
    
}

#pragma mark Table view data source

- (void)configureCell:(VMNSocialMediaTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    BOOL isFieldMandatory;
    if ([self isFieldRequired:[self.labels objectAtIndex:indexPath.row]]){
        isFieldMandatory = true;
        
    }else{
        isFieldMandatory = false;
    }
    
    NSMutableString *labelText = [self.labels objectAtIndex:indexPath.row];
    NSMutableString *finalLabel;
    
    if (isFieldMandatory){
        finalLabel = [NSString stringWithFormat:@"%@*", labelText];
    }else{
        finalLabel = [NSString stringWithFormat:@"%@", labelText];
    }
    cell.leftLabel.text = finalLabel;

    [cell setOptional];
    
    for (int i=0; i< [self.missingFields count]; i++){
        if ([[self.missingFields objectAtIndex:i] isEqualToString:[[self.labels objectAtIndex:indexPath.row]lowercaseString]]){
            [cell setMandatory];
        }
    }
    
	cell.indexPath = indexPath;
	cell.delegate = self;
    //Disables UITableViewCell from accidentally becoming selected.
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    // Set Input Field Type
    
    NSString *label = [self.labels objectAtIndex:indexPath.row];
    
    if ([label isEqualToString:@"Birthday"]){
        cell.type = date;
    }else if ([label isEqualToString:@"Gender"]){
        cell.type = options;
    }
    else if ([label isEqualToString:@"Country"]){
        cell.type = countries;
    }
    else if ([label isEqualToString:@"Mobile Phone"] || [label isEqualToString:@"Zip Code"]){
        cell.type = numberpad;
        [cell.rightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else{
        cell.type = textField;
    }
    
    //Password
    if ([label isEqualToString:@"Password"]){
        [cell.rightTextField setSecureTextEntry:YES];
    }
    
    if ([label isEqualToString:@"Email Address"]){
        [cell.rightTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
    
    //Set right input field value if already fullfilled
    NSString *fieldFilledValue = [self.textFieldProto valueForKey:[[self.inputFields objectAtIndex:indexPath.row]lowercaseString]];
    
    //    NSLog(@"setting value:%@ for input field %@", fieldFilledValue, [self.inputFields objectAtIndex:indexPath.row]);
    
    
    if (fieldFilledValue != nil){
        //        NSLog(@"setting value for input field %@", [self.textFieldProto objectForKey:[self.inputFields objectAtIndex:indexPath.row]]);
        cell.rightTextField.text = fieldFilledValue;
    }
    
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labels count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    VMNSocialMediaTextfieldCell *cell = (VMNSocialMediaTextfieldCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[VMNSocialMediaTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
 
        UIView *myBackgroundView = [[UIView alloc] init];
        myBackgroundView.frame = cell.frame;
        myBackgroundView.backgroundColor = tableViewCellBgColor;
        cell.backgroundView = myBackgroundView;
        
    }
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark VMNSocialMediaTextfieldCellDelegate Methods

-(void)textFieldDidReturnWithIndexPath:(NSIndexPath*)indexPath {
    
	if(indexPath.row < [labels count]-1) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[[(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] rightTextField] becomeFirstResponder];
		[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	
	else {
        
		[[(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:indexPath] rightTextField] resignFirstResponder];
	}
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40.0f;
//}

// =================================================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}


- (void)updateTextLabelAtIndexPath:(NSIndexPath*)indexPath string:(NSString*)string {
    NSLog(@"updateTextLabelAtIndexPath -- labels:  key %@", [self.labels objectAtIndex:indexPath.row]);
    NSLog(@"updateTextLabelAtIndexPath -- inputFields:  key %@", [self.inputFields objectAtIndex:indexPath.row]);
    if (![string isEqualToString:@""]){
        [self.textFieldProto setObject:string forKey:[[self.inputFields objectAtIndex:indexPath.row] lowercaseString]];
        
    }
    
    //	NSLog(@"See input: %@ from section: %d row: %d, should update models appropriately", string, indexPath.section, indexPath.row);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BOOL isAuthenticated = false;
    if ([[VMNSocialMediaSession sharedInstance] hasFluxLocalCredentials]){
        isAuthenticated = true;
    }
    
    float leftPadding = 0;
    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        leftPadding = 20;

    }else{
        leftPadding = 0;
    }
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    if (isAuthenticated){
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        [headerLabel setNumberOfLines:0];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = ROADBLOCKING_TOP_TEXT;
        [headerLabel setTextColor:[UIColor colorWithRed:.285 green:.376 blue:.541 alpha:1]];
        [headerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        
        CGSize labelsize;
        labelsize=[ROADBLOCKING_TOP_TEXT sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(268, 2000.0) lineBreakMode:NSLineBreakByWordWrapping];
        headerLabel.frame=CGRectMake(leftPadding, 10, tableView.frame.size.width, labelsize.height);
        headerView.frame = CGRectMake(leftPadding, 10, tableView.frame.size.width, labelsize.height);
        
        [headerView addSubview:headerLabel];
        [headerLabel release];
    }
    
    if (!isFormValid){
        float topPadding = 0;
        if (isAuthenticated){
            topPadding = 60;
        }else{
            topPadding = 0;
        }
        UILabel *formValidationLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, tableView.frame.size.width, 30)];
        formValidationLabel.textAlignment = UITextAlignmentCenter;
        formValidationLabel.backgroundColor = [UIColor clearColor];
        formValidationLabel.text = VALIDATION_NUMBER_OF_FIELDS;
        [formValidationLabel setTextColor:[UIColor darkGrayColor]];
        [formValidationLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];

        
        [headerView addSubview:formValidationLabel];
        [formValidationLabel release];
    }
    
    return headerView;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    BOOL isAuthenticated = false;
    if ([[VMNSocialMediaSession sharedInstance] hasFluxLocalCredentials]){
        isAuthenticated = true;
    }
    
    if (isAuthenticated){
        if (isFormValid){
            return 70;
        }
        else{
            return 100;
        }
    }else{
        if (isFormValid){
            return 0;
        }
        else{
            return 40;
        }
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    //allocate the view if it doesn't exist yet
    //UIView *footerView  = [[UIView alloc] init];
    
    //Calculate size of Footer view
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(20,0,tableView.frame.size.width-40,550)] autorelease];
    
    
    footerView.backgroundColor = footerViewBgColor;
    
    float labelsTotalHeight = 0;
    // Create TOC checkboxes
    //    float currentY = 70;
    float currentY = 20;
    
    BOOL isIpad = false;
    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        isIpad = true;
    }
    
    int numberOfTocCheckBoxesWithCheckTrue = 0;
    
    for (int zz=0; zz<[tocCheckBoxes count]; zz++){
        NSString *hasCheckBox = [[tocCheckBoxes objectAtIndex:zz] valueForKey:@"CheckBox"];
        if (hasCheckBox)numberOfTocCheckBoxesWithCheckTrue=numberOfTocCheckBoxesWithCheckTrue+1;
    }
    
    int currentIndexOfCheckBoxWithCheckTrue = 0;
    
    for (int i =0; i<[tocCheckBoxes count]; i++){
        
        NSString *hasCheckBox = [[tocCheckBoxes objectAtIndex:i] valueForKey:@"CheckBox"];
        
        
        CGSize theSize;
        
        if (isIpad == true) {
            theSize = [[[tocCheckBoxes objectAtIndex:i] objectForKey:@"Text" ] sizeWithFont:checkBoxLblTxtFont constrainedToSize:CGSizeMake(toc_line_width_iPad, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            
        }else{
            theSize = [[[tocCheckBoxes objectAtIndex:i] objectForKey:@"Text" ] sizeWithFont:checkBoxLblTxtFont constrainedToSize:CGSizeMake(toc_line_width_iPhone, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        }
        
        if (hasCheckBox){
            if ([tocCheckBoxesUI count ] < numberOfTocCheckBoxesWithCheckTrue){
                VMNSocialMediaUICheckbox *checkbox;
                if (isIpad == true) {
                    checkbox = [[[VMNSocialMediaUICheckbox alloc] initWithFrame:CGRectMake(30,currentY,30, 30)] autorelease];
                    
                }else{
                    checkbox = [[[VMNSocialMediaUICheckbox alloc] initWithFrame:CGRectMake(10,currentY,30, 30)] autorelease];
                }
                [tocCheckBoxesUI addObject:checkbox];
                [footerView addSubview:checkbox];
            }else{
                VMNSocialMediaUICheckbox *checkbox = (VMNSocialMediaUICheckbox *)[tocCheckBoxesUI objectAtIndex:currentIndexOfCheckBoxWithCheckTrue];
                [footerView addSubview:checkbox];
            }
        }
        
        
        VMNSocialMediaGLTapLabel *checkBoxLabel;
        if (isIpad == true) {
            checkBoxLabel = [[VMNSocialMediaGLTapLabel alloc] initWithFrame:CGRectMake(70, currentY, toc_line_width_iPad, theSize.height)];
        }else{
            checkBoxLabel = [[VMNSocialMediaGLTapLabel alloc] initWithFrame:CGRectMake(50, currentY, toc_line_width_iPhone, theSize.height)];
        }
        
        checkBoxLabel.delegate = self;
        checkBoxLabel.linkColor = checkBoxLblLinkColor;
        
        checkBoxLabel.text = [[tocCheckBoxes objectAtIndex:i] objectForKey:@"Text" ];
        
        checkBoxLabel.numberOfLines = 0;
        
        //        [checkBoxLabel sizeToFit];
        
        checkBoxLabel.tag = i;
        if (isFormValid){
            checkBoxLabel.textColor = checkBoxLblValidTxtColor; //[UIColor whiteColor];
        }else{
            checkBoxLabel.textColor = checkBoxILblnvalidTxtColor; //[UIColor redColor];
        }
        checkBoxLabel.backgroundColor = checkBoxLblBgColor;//[UIColor clearColor];
        checkBoxLabel.font = checkBoxLblTxtFont;
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnTOC:)];
        
        // if labelView is not set userInteractionEnabled, you must do so
        [checkBoxLabel setUserInteractionEnabled:YES];
        [checkBoxLabel addGestureRecognizer:gesture];
        
        [footerView addSubview:checkBoxLabel];
        
        labelsTotalHeight = currentY+theSize.height;
        currentY = labelsTotalHeight+15;
        
        if (hasCheckBox)currentIndexOfCheckBoxWithCheckTrue=currentIndexOfCheckBoxWithCheckTrue+1;
        
    }
    
    
    //create the Submission button
    submitBtnType = UIButtonTypeCustom;
    submitBtnTitleColor = [UIColor greenColor];
    submitBtnFont = [UIFont fontWithName:@"Monaco Bold" size:18];
    UIButton *button = [UIButton buttonWithType:submitBtnType];
    
    
    //the button should be as big as a table view cell
    [button setFrame:CGRectMake(tableView.frame.size.width/2-150, labelsTotalHeight+20, 300, 44)];
    
    //set title, font size and font color
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    [button.titleLabel setFont:submitBtnFont];
    [button setTitleColor:submitBtnTitleColor forState:UIControlStateNormal];
    
    //set action of the button
    [button addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [footerView addSubview:button];
    
    footerView.frame = CGRectMake(20,0,tableView.frame.size.width-40,labelsTotalHeight+44);

    //return the view for the footer
    return footerView;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *notificationName = @"VMNSocialMediaFieldChanged";
//    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
//}

- (void)userTappedOnTOC:(id)sender{
    //    NSLog(@"userTappedOnTOC with tag %d", [(UIGestureRecognizer *)sender view].tag);
    //    NSLog(@"usertappedontoc");
    //Get the index of TOC
    for( int i = 0; i < [self.formFields count];i++){
        id aField = [self.formFields objectAtIndex:i];
        //Dont display Terms and Agreements in table view
        if ([[aField objectForKey:@"Field"] isEqualToString:@"AgreementTerms"]){
            _fieldBeingEdited = i;
        }
    }
    
    VMNSocialMediaUIActionSheetWithDismiss* sheet = [[VMNSocialMediaUIActionSheetWithDismiss alloc] init];
    sheet.title = @"Terms and Conditions";
    sheet.delegate = self;
    
    _termsAndConditionsBeingViewed = [(UIGestureRecognizer *)sender view].tag;
    
    NSMutableDictionary *checkBoxes = [tocCheckBoxes objectAtIndex:[(UIGestureRecognizer *)sender view].tag];
    
    for (id option in [checkBoxes objectForKey:@"Links"]){
        [sheet addButtonWithTitle:[option objectForKey:@"Title"]];
    }
    
    if ([[checkBoxes objectForKey:@"Links"] count] >0){
        [sheet showInView:self.view];
    }
    [sheet release];
    
}

// specify the height of your footer section
- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    //calculate the height of checkboxs, text label, submit button and padding
    //    NSLog(@"footerTotalHeight %f", footerTotalHeight);
    return footerTotalHeight+50;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validatePassword: (NSString *) candidate {
    if( [candidate length] >= 6 &&  [candidate length] <=16)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) validateUrlName: (NSString *) candidate {
    if( [candidate length] >= 2 &&  [candidate length] <=25)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) validateDisplayName: (NSString *) candidate {
    if( [candidate length] >= 1 &&  [candidate length] <=100)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL) validateBirthday: (NSString *) candidate {
    
    //Convert string to date
    NSString *dateString = candidate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    NSDate *today = [NSDate date];
    
    
    if ([dateFromString compare:today] == NSOrderedDescending) {
        //        NSLog(@"validateBirthday in the future", candidate);
        
        return NO;
    }else{
        return YES;
    }
    
}



- (void)validateForm{
    //Todo: Make a validator class
    
    //Validate TOS
    
    // Array that contains any missing fields or fields that didn't pass validation
    [missingFields removeAllObjects];
    
    NSMutableString *errorMsg;
    NSUInteger errorMsgCharacterCount = 0;
    
    BOOL allTermsAgreed = true;
    for (int y =0; y<[tocCheckBoxesUI count]; y++){
        VMNSocialMediaUICheckbox *checkbox = (VMNSocialMediaUICheckbox *)[tocCheckBoxesUI objectAtIndex:y];
        if (!checkbox.checked){
            [missingFields addObject:@"tos_accepted"];
            allTermsAgreed = false;
            errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", VALIDATION_ACCEPT_TC]];
            errorMsgCharacterCount = [errorMsg length];
        }
    }
    
    
    if (allTermsAgreed){
        [self.textFieldProto setValue:@"true" forKey:@"tos_accepted"];
    }else{
        [self.textFieldProto setValue:@"false" forKey:@"tos_accepted"];
    }
    
    
   //NSLog(@"validateForm fields: %@", self.textFieldProto);
    
    
    //Validate Form
    
    
    for( int i = 0; i < [self.formFields count];i++){
        id aField = [self.formFields objectAtIndex:i];
        NSString *fieldKey = [[aField objectForKey:@"Field"] lowercaseString];
        NSString *fieldLabel= [[aField objectForKey:@"Label"] lowercaseString];
        
        //        NSString *isFieldRequired = [aField valueForKey:@"Required"];
        NSNumber *val =  [aField valueForKey:@"Required"];
        BOOL isFieldRequired = [val boolValue];
        
        NSString *response =  [self.textFieldProto objectForKey:fieldKey];
        
        if (![fieldKey isEqualToString:@"agreementterms"]){
            //            NSLog(@"key:%@ | response: %@", fieldKey, response);
            if ([response isEqualToString:@""] || response == nil){
                if (isFieldRequired){
                    [missingFields addObject:fieldLabel];
                    //                    NSLog(@"response error");
                }
            }
        }
    }
    
    
    //    if ([missingFields count]>0)return;
    
    //Required fields have been populated, now it's time to validate it.
    
    
    
    for( int x = 0; x < [self.formFields count];x++){
        id aField = [self.formFields objectAtIndex:x];
        NSString *fieldKey = [[aField objectForKey:@"Field"] lowercaseString];
        NSLog(@"validating ... %@",fieldKey);
        NSString *isFieldRequired = [aField objectForKey:@"Required"];
        NSString *response =  [self.textFieldProto objectForKey:fieldKey];
        
        
        //Validate Birthday
        if ([fieldKey isEqualToString:@"birthday"] && isFieldRequired){
            if (![self validateBirthday:response]){
                [missingFields addObject:fieldKey];
                if (errorMsgCharacterCount == 0){
                    errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:VALIDATION_BIRTHDAY]];
                    errorMsgCharacterCount = [errorMsg length];

                }
                
            }
        }
        
        //Validate email
        if ([fieldKey isEqualToString:@"email"] && isFieldRequired){
            if (![self validateEmail:response]){
                [missingFields addObject:fieldKey];
                if (errorMsgCharacterCount == 0){
                    errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat: VALIDATION_EMAIL]];
                    errorMsgCharacterCount = [errorMsg length];

                }
                
            }
        }
        
        //Validate password
        if ([fieldKey isEqualToString:@"password"] && isFieldRequired){
            if (![self validatePassword:response]){
                [missingFields addObject:fieldKey];
                if (errorMsgCharacterCount == 0){
                    errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:VALIDATION_PASSWORD]];
                    errorMsgCharacterCount = [errorMsg length];

                }
                
                
            }
        }
        
        //Validate display name
        if ([fieldKey isEqualToString:@"displayname"] && isFieldRequired){
            if (![self validateDisplayName:response]){
                [missingFields addObject:fieldKey];
                if (errorMsgCharacterCount == 0){
                    errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat: VALIDATION_DISPLAYNAME]];
                    errorMsgCharacterCount = [errorMsg length];

                }
            }
        }
        
        
        //Validate URL name
        if ([fieldKey isEqualToString:@"urlname"] && isFieldRequired){
            if ([!self validateUrlName:response]){
                [missingFields addObject:fieldKey];
                if (errorMsgCharacterCount == 0){
                    errorMsg = [[NSMutableString alloc] initWithString:[NSString stringWithFormat: VALIDATION_URLNAME]];
                    errorMsgCharacterCount = [errorMsg length];

                }
            }
        }
        
    }
    
    
    if (errorMsgCharacterCount > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithString:errorMsg] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}


- (void)setValidationForLocation{
    NSString *country = [self.textFieldProto valueForKey:@"country"];
    
    for( int x = 0; x < [self.formFields count];x++){
        id aField = [self.formFields objectAtIndex:x];
        NSString *fieldKey = [[aField objectForKey:@"Field"] lowercaseString];
        
        // ZipCode Validation
        if ([fieldKey isEqualToString:@"zipcode"]){
            
            if ([country isEqualToString:@"United States"]){
                // Zip Code is mandatory
                
                //                NSLog(@"Zip Code is mandatory");
                [aField setValue:[NSNumber numberWithBool:TRUE] forKey:@"Required"];
            }else{
                
                //ZIp Code is optional
                
                //                NSLog(@"Zip Code is optional");
                
                [aField setValue:[NSNumber numberWithBool:FALSE] forKey:@"Required"];
            }
        }
        
        // City Validation
        if ([fieldKey isEqualToString:@"city"]){
            
            if ([country isEqualToString:@"United States"]){
                // City is optional
                
                //                NSLog(@"City is optional");
                
                [aField setValue:[NSNumber numberWithBool:FALSE] forKey:@"Required"];
            }else{
                
                
                //                NSLog(@"City is mandatory");
                
                //City is mandatory
                [aField setValue:[NSNumber numberWithBool:TRUE] forKey:@"Required"];
            }
        }
        
    }
    [self.tableView reloadData];
    
}


- (void)submitForm{
    
    // Validate form on the client side
    
    [self validateForm];
    
    //NSLog(@"submit form with values %@", self.textFieldProto);
    
    // Missing fields array will be populated by form validation if there are any fields not being validated properly
    
    //NSLog(@"missing fields count %d", [missingFields count]);
    
    if ([missingFields count]==0){
        isFormValid = true;
        
        [[VMNSocialMediaSession sharedInstance] submitFluxRegistrationInfo:self.textFieldProto completion:^( NSMutableDictionary *response) {
            self.fluxStatusCode = [[response objectForKey:@"Status"] integerValue];
            
            NSLog(@"submitForm: response %@", response );
            
            //Validation will now happen on the server side
            if (self.fluxStatusCode == 2 || self.fluxStatusCode == 4 || self.fluxStatusCode == 0 || self.fluxStatusCode == 12 || self.fluxStatusCode == 36){
                // errors
                //NSString *message = [[response objectForKey:@"ErrorsDetail"] objectAtIndex:0];
                NSString *message = [response objectForKey:@"UIFriendlyMessage"];
                if (message == nil || message == (id)[NSNull null]){
                    message = [response objectForKey:@"Message"];
                }
                
                // If user is underaged, block registration on device.
                if (self.fluxStatusCode == 36) {
//                    [[VMNSocialMediaSession sharedInstance] removeBlockOnFluxRegistration];
                    [[VMNSocialMediaSession sharedInstance] blockRegistrationOnDevice];
                    BOOL blocked = [[VMNSocialMediaSession sharedInstance] fluxRegistrationIsBlocked];
                    NSLog(blocked ? @"Registration is blocked" : @"Registration not blocked");
                }
                
                if ([[response objectForKey:@"Message"] isEqualToString:@"LinkTwitterAccountNeeded"]){
                    VMNSocialMediaFluxLoginViewController *fluxLoginView = [[VMNSocialMediaFluxLoginViewController alloc]init];
                    fluxLoginView.topMsg = [NSString stringWithFormat:@"%@\n\nPlease sign in below.", message];
                    fluxLoginView.email = [self.textFieldProto objectForKey:@"email"];
                    fluxLoginView.delegate = self;
                    
                    //response - merge types: Facebook, Flux, Flux+Facebook
                    //type: mergeFacebook,mergeFlux, mergeFluxFacebook
                    NSString *linkTwitterAccountUserType = [response objectForKey:@"LinkTwitterAccountUserType"];
                    if ([linkTwitterAccountUserType isEqualToString:@"Flux"]){
                        fluxLoginView.type = mergeFlux;
                    }else if ([linkTwitterAccountUserType isEqualToString:@"Facebook"]){
                        fluxLoginView.type = mergeFacebook;
                    }else{
                        fluxLoginView.type = mergeFluxFacebook;
                    }
                    
                    [self.navigationController pushViewController:fluxLoginView animated:true];
                    [fluxLoginView release];
                    return;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }else if (self.fluxStatusCode == 1){
                // Success: Registration completed!
                
                if (![VMNSocialMediaFluxUtils hasLocalCredentials]){
                    // store Flux Cookie
                    NSString *fluxCookie = [response objectForKey:@"AuthTicket"];
                    [VMNSocialMediaFluxUtils storeLocalCredentialsWithValue:fluxCookie];
                    
                    // store Flux User ID
                    NSString *fluxUserID = [response objectForKey:@"Ucid"];
                    [VMNSocialMediaFluxUtils storeUserID:fluxUserID];
                }
                
                [_delegate registrationDidComplete:nil];
            }
        }];
    }else{
        isFormValid = false;
        [self.tableView reloadData];
    }
    
    // Close popup
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertview clicked");
    if (buttonIndex == 0){
        //cancel clicked ...do your action
        NSLog(@"cancel clicked");
        if (self.fluxStatusCode==36) {
            [self closeView];
        }
    }else if (buttonIndex == 1){
        //reset clicked
    }
}

#pragma mark ELCTextFieldDelegate Methods defined in VMNSocialMediaTextfieldCell


-(void)showOptionsForIndex:(int)index{
    _fieldBeingEdited = index;
    VMNSocialMediaUIActionSheetWithDismiss* sheet = [[VMNSocialMediaUIActionSheetWithDismiss alloc] init];
    sheet.title = @"Gender";
    sheet.delegate = self;
    NSString *fieldType = [self.labels objectAtIndex:index];
    if ([fieldType isEqualToString:@"Gender"]){
        [sheet addButtonWithTitle:@"Male"];
        [sheet addButtonWithTitle:@"Female"];
    }
    [sheet showInView:self.view];
    [sheet release];
}

-(void)showDateForIndex:(int)index{
    _fieldBeingEdited = index;
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:[NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"", @"")]
                                  delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Done", nil];
    [actionSheet showInView:self.view];
    
    _datePicker= [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 270, 220)];
    
    //    _datePicker = [[[UIDatePicker alloc] init] autorelease];
    [_datePicker addTarget:self action:@selector(changeDateInLabel:)
          forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [actionSheet addSubview:_datePicker];
}


-(void)showCountriesForIndex:(int)index{
    NSIndexPath* path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    _fieldBeingEdited = index;
    
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            VMNSocialMediaTextfieldCell* cell = (VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:cellPath];
            [[cell rightTextField] resignFirstResponder];
            //do stuff with 'cell'
        }
    }
    
    
    VMNSocialMediaCountrySelectionViewController *countriesView = [[VMNSocialMediaCountrySelectionViewController alloc]init];
    countriesView.delegate = self;
    
    //    NSLog(@"selected country %@", [self.textFieldProto valueForKey:@"country"]);
    
    if ([[self.textFieldProto valueForKey:@"country"] isEqualToString:@""]){
        countriesView.defaultCountry = @"United States";
    }else{
        countriesView.defaultCountry = [self.textFieldProto valueForKey:@"country"];
    }
    [self.navigationController pushViewController:countriesView animated:TRUE];
    [countriesView release];
}


-(void)showNumberPad:(int)index{
    _fieldBeingEdited = index;
    
}

-(void)showTextField:(int)index{
    _fieldBeingEdited = index;
    
}

- (void)changeDateInLabel:(id)sender{
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
    
    NSDate *birthDate = _datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:birthDate];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:birthDate];
    [formatter setDateFormat:@"dd"];
    NSString *day = [formatter stringFromDate:birthDate];
    
	NSString *date = [NSString stringWithFormat:@"%@/%@/%@",month,day, year];
    
    NSIndexPath* path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    [(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] setTextValueForField: date];
	[df release];
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *fieldType = [self.inputFields objectAtIndex:_fieldBeingEdited];
    NSIndexPath* path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    
    //    NSLog(@"field type %@", fieldType);
    if ([fieldType isEqualToString:@"Gender"]){
        NSString *fieldValue;
        if (buttonIndex == 0){
            fieldValue = @"male";
        }else{
            fieldValue = @"female";
        }
        //Set the value in the Cell TextField:
        [(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] setTextValueForField: fieldValue];
        //Set the value in the Form values array
        [self.textFieldProto setObject:fieldValue forKey:[[self.inputFields objectAtIndex:_fieldBeingEdited]lowercaseString]];
    } else if ([fieldType isEqualToString:@"Birthday"]){
        NSString *fieldValue = [(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] getTextValueForField];
        [self.textFieldProto setObject:fieldValue forKey:[[self.inputFields objectAtIndex:_fieldBeingEdited]lowercaseString]];
    }else{
        // It's Terms and Conditions
        
        NSMutableDictionary *checkBoxes = [tocCheckBoxes objectAtIndex:_termsAndConditionsBeingViewed];
        
        int index = 0;
        for (id option in [checkBoxes objectForKey:@"Links"]){
            
            if (buttonIndex == index){
                self.browserView = [[VMNSocialMediaBrowserView alloc] initWithFrame:self.parentViewController.view.frame url:[NSURL URLWithString:[option valueForKey:@"Url"]] delegate:self];
                [self.parentViewController.view addSubview:self.browserView];
            }
            index+=1;
        }
        
    }
}

#pragma mark VMNSocialMediaBrowserView
- (void)closeBrowser:(VMNSocialMediaBrowserView *)aBrowserView {
	[aBrowserView removeFromSuperview];
}

- (void)closeView{
    if ([_delegate respondsToSelector:@selector(closeForm)]) {
        [_delegate closeForm];       
    }
//    if (!NSClassFromString(@"UISplitViewController") != nil && !UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self.view removeFromSuperview];
//    }
}

- (void)didSelectCountry:(NSString *)country{
    //    NSLog(@"didSelectCountry %@", country);
    NSIndexPath* path = [NSIndexPath indexPathForRow:_fieldBeingEdited inSection:0];
    [(VMNSocialMediaTextfieldCell*)[self.tableView cellForRowAtIndexPath:path] setTextValueForField: country];
    [self.textFieldProto setObject:country forKey:[[self.inputFields objectAtIndex:_fieldBeingEdited]lowercaseString]];
}

-(void)label:(VMNSocialMediaGLTapLabel *)label didSelectedHotWord:(NSString *)w
{
}

// Load the framework bundle.
- (NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"VMNSocialMediaSDKResources.bundle"];
        frameworkBundle = [[NSBundle bundleWithPath:frameworkBundlePath] retain];
    });
    return frameworkBundle;
}

#pragma mark  VMNSocialMediaFluxLoginDelegate
- (void)closeFluxLoginWindow{
    [self closeView];
}

@end
