//
//  RootViewController.m
//  EmailSearch
//
//  Created by Radif Sharafullin on 6/22/13.
//  Copyright (c) 2013 MCB. All rights reserved.
//

#import "RootViewController.h"
#include "Search.h"

@interface RootViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController{
    IBOutlet UITextField *_textField;
    IBOutlet UIButton *_button;
    IBOutlet UITableView *_tableView;
    EmailSearch::p_results_t _searchResults;
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

- (void)dealloc {
    [_textField release];
    [_button release];
    [_tableView release];
    [super dealloc];
}
- (IBAction)buttonPressed:(id)sender {
    [self search];
}
#pragma mark search
-(void)search{
    self.view.userInteractionEnabled=FALSE;
    [_textField resignFirstResponder];
    _searchResults=nullptr;
    [_tableView reloadData];
    
    std::string queryString=[_textField.text UTF8String];
    
    EmailSearch::Search(queryString, [=](std::string query, EmailSearch::p_results_t results, long timeMillis){
        _searchResults=results;
        [_tableView reloadData];
        self.view.userInteractionEnabled=TRUE;
    });
}
#pragma mark textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    return TRUE;
}
#pragma mark tableView
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}

#pragma mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_searchResults)
        return _searchResults->size();
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"content_cell";
    
    UITableViewCell  *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.numberOfLines=3;
    }
    
    
    // Configure the cell...
    
    auto & result(_searchResults->at(indexPath.row));
    cell.textLabel.text=@((result.word + " - " + result.emailPath()).c_str());
    cell.detailTextLabel.text=@(result.emailLine().c_str());
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


@end
