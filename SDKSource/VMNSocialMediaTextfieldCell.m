#import "VMNSocialMediaTextfieldCell.h"


@implementation VMNSocialMediaTextfieldCell

@synthesize delegate;
@synthesize leftLabel;
@synthesize isMandatory;
@synthesize rightTextField;
@synthesize indexPath;
@synthesize type = _type;
@synthesize labelBgColor;
@synthesize labelTxtColor;
@synthesize labelTxtErrorColor;
@synthesize labelFont;
@synthesize txtFldBgColor;
@synthesize txtFldTxtColor;
@synthesize txtFldFont;







- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
        
        
        labelBgColor =  [UIColor blackColor];
        labelTxtColor = [UIColor yellowColor];
        labelTxtErrorColor = [UIColor redColor];
        labelFont = [UIFont fontWithName:@"Arial" size:13];
        labelHeight = 40;
        labelWidth = 105;
        labelTopOffset = 0;
        labelLeftOffset = 0;
        
        txtFldTxtColor = [UIColor blackColor];
        txtFldBgColor = [UIColor lightGrayColor];
        txtFldFont = [UIFont fontWithName:@"Monaco" size:13];
        txtFldBorderStyle = UITextBorderStyleRoundedRect;
        txtFldHeight = 35;
        txtFldTopOffset = 0;
        txtFldWidth = 185;
        txtFldLeftOffset = 115;
        
        
        leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[leftLabel setBackgroundColor:labelBgColor];
		[leftLabel setTextColor:labelTxtColor];
		[leftLabel setFont:labelFont];
		[leftLabel setTextAlignment:UITextAlignmentRight];
		[leftLabel setText:@"Left Field"];
		[self addSubview:leftLabel];
        
        /*isMandatory = [[UILabel alloc] initWithFrame:CGRectMake(0,20,0,0)];
		[isMandatory setBackgroundColor:[UIColor clearColor]];
		[isMandatory setTextColor:[UIColor blackColor]];
		[isMandatory setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        //[isMandatory setBackgroundColor:[UIColor blueColor]];
		[isMandatory setTextAlignment:UITextAlignmentRight];
		[isMandatory setText:@"required"];
		[self addSubview:isMandatory];*/
    
		//inputField = [[UITextField alloc] initWithFrame:CGRectZero];
        rightTextField.adjustsFontSizeToFitWidth = YES;
		rightTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        [rightTextField setBorderStyle:txtFldBorderStyle];
        
		rightTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[rightTextField setDelegate:self];
		
        [rightTextField setFont:txtFldFont];
        [rightTextField setBackgroundColor:txtFldBgColor];
		[rightTextField setTextColor:txtFldTxtColor];
		
        [rightTextField setReturnKeyType:UIReturnKeyDone];
		
		[self addSubview:rightTextField];

    }
    
    return self;
}


- (void)setMandatory{
    [leftLabel setTextColor:labelTxtErrorColor];
}

- (void)setOptional{
    [leftLabel setTextColor:labelTxtColor];
}

//Layout our fields in case of a layoutchange (fix for iPad doing strange things with margins if width is > 400)
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect origFrame = self.contentView.frame;
	if (leftLabel.text != nil) {
		leftLabel.frame = CGRectMake(origFrame.origin.x + labelLeftOffset,
                                     origFrame.origin.y + labelTopOffset,
                                     labelWidth,
                                     labelHeight);
//        isMandatory.frame = CGRectMake(origFrame.origin.x, 10, 105, origFrame.size.height-1);

		rightTextField.frame = CGRectMake(origFrame.origin.x+txtFldLeftOffset,
                                          origFrame.origin.y + txtFldTopOffset,
                                          txtFldWidth,
                                          txtFldHeight);
	} else {
		leftLabel.hidden = YES;
		NSInteger imageWidth = 0;
		if (self.imageView.image != nil) {
			imageWidth = self.imageView.image.size.width + 5;
		}
		rightTextField.frame = CGRectMake(origFrame.origin.x+imageWidth+10, origFrame.origin.y, origFrame.size.width-imageWidth-20, origFrame.size.height-1);
	}
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (_type == options){
        [textField resignFirstResponder];
        [delegate showOptionsForIndex:[indexPath row]];
    }else if (_type == date){
        [textField resignFirstResponder];
        [delegate showDateForIndex:[indexPath row]];
    }
    else if (_type == countries){
        [textField resignFirstResponder];
        [delegate showCountriesForIndex:[indexPath row]];
    }else if (_type == numberpad){
        [delegate showNumberPad:[indexPath row]];
        [delegate unhideDoneButton];

    }else{
        [delegate showTextField:[indexPath row]];
        [delegate hideDoneButton];

    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    if (_type == numberpad) {
//        [delegate hideDoneButton];
//    }
    [textField resignFirstResponder];

    
    return YES;
}

- (void)setTextValueForField:(NSString *)text{
    self.rightTextField.text = text;
}

- (NSString *)getTextValueForField{
    return self.rightTextField.text;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

	NSString *textString = self.rightTextField.text;
	
	if (range.length > 0) {
		
		textString = [textString stringByReplacingCharactersInRange:range withString:@""];
	} 
	
	else {
		
		if(range.location == [textString length]) {
			
			textString = [textString stringByAppendingString:string];
		}

		else {
			
			textString = [textString stringByReplacingCharactersInRange:range withString:string];	
		}
	}
	
	if([delegate respondsToSelector:@selector(updateTextLabelAtIndexPath:string:)]) {		
		[delegate performSelector:@selector(updateTextLabelAtIndexPath:string:) withObject:indexPath withObject:textString];
	}
	
	return YES;
}

- (void)dealloc {
    [isMandatory release];
	[leftLabel release];
	[rightTextField release];
	[indexPath release];
    
    [labelBgColor release];
    [labelTxtColor release];
    [labelTxtErrorColor release];
    [labelFont release];
    
    
    [txtFldBgColor release];
    [txtFldTxtColor release];
    [txtFldFont release];

    [super dealloc];
}

@end
