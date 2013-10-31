#import <UIKit/UIKit.h>


typedef enum type {
    textField,
    date,
    countries,
    options,
    numberpad
} type;

@interface VMNSocialMediaTextfieldCell : UITableViewCell <UITextFieldDelegate> {
    type _type;
	id delegate;
	UILabel *leftLabel;
    UILabel *isMandatory;
	UITextField *rightTextField;
	NSIndexPath *indexPath;
    
    UIColor *labelBgColor;
    UIColor *labelTxtColor;
    UIColor *labelTxtErrorColor;
    UIFont  *labelFont; //includes family and size
    CGFloat labelHeight;
    CGFloat labelWidth;
    CGFloat labelTopOffset;
    CGFloat labelLeftOffset;
    
    
    UIColor *txtFldBgColor;
    UIColor *txtFldTxtColor;
    UIFont  *txtFldFont; //includes family and size
    UITextBorderStyle txtFldBorderStyle;
    CGFloat txtFldHeight;
    CGFloat txtFldWidth;
    CGFloat txtFldTopOffset;
    CGFloat txtFldLeftOffset;

    
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UILabel *isMandatory;
@property (nonatomic, retain) UITextField *rightTextField;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic, retain) UIColor *labelBgColor;
@property (nonatomic, retain) UIColor *labelTxtColor;
@property (nonatomic, retain) UIColor *labelTxtErrorColor;
@property (nonatomic, retain) UIColor *labelErrorTxtColor;
@property (nonatomic, retain) UIFont  *labelFont;

@property (nonatomic, retain) UIColor *txtFldBgColor;
@property (nonatomic, retain) UIColor *txtFldTxtColor;
@property (nonatomic, retain) UIFont  *txtFldFont;


@property (nonatomic, assign) type type;
- (void)setTextValueForField:(NSString *)text;
- (void)setMandatory;
- (void)setOptional;
- (NSString *)getTextValueForField;

@end

@protocol ELCTextFieldDelegate
@optional
-(void)textFieldDidReturnWithIndexPath:(NSIndexPath*)_indexPath;
-(void)updateTextLabelAtIndexPath:(NSIndexPath*)_indexPath string:(NSString*)_string;
-(void)showOptionsForIndex:(int)index;
-(void)showDateForIndex:(int)index;
-(void)showCountriesForIndex:(int)index;
-(void)showNumberPad:(int)index;
-(void)showTextField:(int)index;
-(void)showTextField:(int)index forCell:(VMNSocialMediaTextfieldCell *)cell;
-(void)showNumberPad:(int)index forCell:(VMNSocialMediaTextfieldCell *)cell;
- (void)unhideDoneButton;
- (void)hideDoneButton;

@end