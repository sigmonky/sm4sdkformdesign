#import <UIKit/UIKit.h>

#import "VMNSocialMediaUserRegistrationProtocols.h"
#import "VMNSocialMediaTextfieldCell.h"
#import "VMNSocialMediaBrowserView.h"
#import "VMNSocialMediaGLTapLabelDelegate.h"
#import "VMNSocialMediaGLTapLabel.h"
#import "VMNSocialMediaProtocols.h"

@interface VMNSocialMediaUserRegistrationFormViewController : UITableViewController <ELCTextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate, UITextViewDelegate, SelectCountryDelegate, VMNSocialMediaGLTapLabelDelegate, VMNSocialMediaBrowserViewDelegate, VMNSocialMediaFluxLoginDelegate, UIAlertViewDelegate>{
    
    //Form elements
    //    UITableView *_mainTable;
    NSMutableArray *_entryFields;
    BOOL editing;
	NSMutableArray *_fieldNames;
	NSMutableDictionary* _fieldData;
	UITextView *_textFieldBeingEdited;
	NSMutableDictionary *_textFieldProto;
    id<VMNSocialMediaUserRegistrationDelegate>_delegate;
    
    int _fieldBeingEdited;
    
    int _termsAndConditionsBeingViewed;
    
    VMNSocialMediaBrowserView *_browserView;
    
    
    //UI
    float _viewTop;
    float _viewLeft;
    float _viewWidth;
    float _viewHeight;
    UIDatePicker *_datePicker;
	NSMutableArray *labels;
    NSMutableArray *inputFields;
	NSMutableArray *placeholders;
    NSMutableArray *missingFields;
    NSMutableArray *tocCheckBoxes;
    NSMutableArray *tocCheckBoxesUI;
    BOOL isFormValid;
    float footerTotalHeight;
    VMNSocialMediaTextfieldCell *_aCell;
    UIButton *_doneButton;
    
    UIColor *navBarBgColor;
    UIColor *navBarTintColor;
    UIColor *navBarBtnTxtColor;
    UIColor *navBarTitleTxtBgColor;
    UIColor *navBarTitleTxtColor;
    UIFont  *navBarTitleTxtFont;
    NSString *navBarTitleTxt;
    
    UIColor *tableViewBgColor;
    UIColor *tableViewSeparatorColor;
    UIColor *tableViewCellBgColor;
    CGFloat tableRowHeight;
    
    UIColor *checkBoxLblValidTxtColor;
    UIColor *checkBoxILblnvalidTxtColor;
    UIColor *checkBoxLblBgColor;
    UIColor *checkBoxLblLinkColor;
    UIFont  *checkBoxLblTxtFont;
     
    UIColor *footerViewBgColor;
    
    UIButtonType submitBtnType;
    UIColor     *submitBtnTitleColor;
    UIFont      *submitBtnFont;
    
    

}
@property (nonatomic, retain) VMNSocialMediaBrowserView *browserView;
@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) NSMutableArray *missingFields;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) NSMutableArray *inputFields;
@property (nonatomic, retain) NSMutableArray *placeholders;
@property (nonatomic, retain) NSMutableArray *tocCheckBoxes;
@property (nonatomic, retain) NSMutableArray *tocCheckBoxesUI;
@property (nonatomic, assign) id<VMNSocialMediaUserRegistrationDelegate>delegate;
@property (nonatomic, retain) NSMutableArray *entryFields;
@property (nonatomic, retain) UIColor *navBarTintColor;
@property (nonatomic, retain) UIColor *navBarBgColor;
@property (nonatomic, retain) UIColor *navBarBtnTxtColor;
@property (nonatomic, retain) UIColor *navBarTitleTxtColor;
@property (nonatomic, retain) UIColor *navBarTitleTxtBgColor;
@property (nonatomic, retain) UIFont  *navBarTitleTxtFont;
@property (nonatomic, retain) NSString *navBarTitleTxt;
@property (nonatomic, retain) UIColor *tableViewSeparatorColor;
@property (nonatomic, retain) UIColor *tableViewCellBgColor;
@property (nonatomic, retain) UIColor *tableViewBgColor;
@property (nonatomic, retain) UIColor *checkBoxLblValidTxtColor;
@property (nonatomic, retain) UIColor *checkBoxLblInvalidColor;
@property (nonatomic, retain) UIColor *checkBoxLblBgColor;
@property (nonatomic, retain) UIColor *checkBoxLblLinkColor;
@property (nonatomic, retain) UIFont  *checkBoxLblTxtFont;
@property (nonatomic, retain) UIFont  *submitBtnFont;
@property (nonatomic, retain) UIColor  *submitBtnTitleColor;


@property (nonatomic, retain) UIColor *footerViewBgColor;


// PRIVATE
@property (nonatomic,retain) UITextView *textFieldBeingEdited;

// PUBLIC
@property (nonatomic,retain) NSMutableArray *fieldNames;
@property (nonatomic,retain) NSMutableDictionary* fieldData;
@property (nonatomic,retain) NSMutableDictionary* textFieldProto;
@property NSInteger firstFocusRow;
@property (nonatomic, retain) NSArray *formFields;
@property (nonatomic, assign) NSInteger fluxStatusCode;


- (id)initWithViewLeft: (float)aViewLeft viewTop:(float)aViewTop viewWidth:(float)aViewWidth viewHeight:(float)aViewHeight;
- (void)validateForm;
- (void)submitForm;
- (BOOL) validateDisplayName: (NSString *) candidate;
- (BOOL) validateUrlName: (NSString *) candidate;
- (BOOL) validatePassword: (NSString *) candidate;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL)isFieldRequired:(NSString *)fieldName;
- (void)setValidationForLocation;
- (void)addButtonToKeyboard;
- (void)doneButton:(id)sender;
- (void)createDoneButton;
- (void)unhideDoneButton;
- (void)hideDoneButton;
- (NSBundle *)frameworkBundle;
@end
