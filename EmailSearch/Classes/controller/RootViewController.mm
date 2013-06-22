//
//  RootViewController.m
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/22/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#import "RootViewController.h"
#include "Search.h"

@interface RootViewController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation RootViewController{
    IBOutlet UITextField *_textField;
    IBOutlet UIButton *_button;
    IBOutlet UITextView *_textView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(id)sender {
    self.view.userInteractionEnabled=FALSE;
    [_textField resignFirstResponder];
    _textView.text=@"...";

    NSString * queryString=_textField.text;
    if (!queryString.length)
        return;
    
    EmailSearch::Search([queryString UTF8String], [=](std::string query, const EmailSearch::results_t & results, long timeMillis){
        std::string retVal;
        for (auto & result : results)
            retVal+=(result.word + " - " + result.emailLine()+ "\n");
        
        
        _textView.text=@(retVal.c_str());
        self.view.userInteractionEnabled=TRUE;
    });
    
}

- (void)dealloc {
    [_textField release];
    [_button release];
    [_textView release];
    [super dealloc];
}
@end
