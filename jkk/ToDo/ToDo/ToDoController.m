//
//  ToDoController.m
//  ToDo
//
//  Created by Prasanth Sivanappan on 08/08/13.
//  Copyright (c) 2013 Prasanth Sivanappan. All rights reserved.
//

#import "ToDoController.h"
#import "TaskCell.h"

@interface ToDoController ()
@property (strong,nonatomic) NSMutableArray *tableItems;
@property (nonatomic, strong) UITextField *txtField;
@property (nonatomic, strong) UITableViewCell *editingCell;
@property (nonatomic, strong) NSIndexPath *editingPath;

@end

@implementation ToDoController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"To Do List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *customNib = [UINib nibWithNibName:@"TaskCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TaskCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton)];
    self.tableItems = [[NSMutableArray alloc] initWithObjects: nil];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.tableItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.tableItems objectAtIndex:indexPath.row];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self addNewCellFromTextField:textField];
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *temp = [self.tableItems objectAtIndex:fromIndexPath.row];
    [self.tableItems removeObjectAtIndex:fromIndexPath.row];
    [self.tableItems insertObject:temp atIndex:toIndexPath.row];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Private methods

-(void)onAddDoneButton {
    [self addNewCellFromTextField:self.txtField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButton)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)editCell:(NSIndexPath *)indexPath{
    if (self.editingCell && self.editingPath != indexPath){
        [self.txtField resignFirstResponder];
    }
    
    self.editingCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.editingPath = indexPath;
    
    if (self.txtField == nil){
        self.txtField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, 300, 40)];
        self.txtField.delegate = self;
    }
    
    if (self.editingCell.textLabel){
        self.txtField.text = self.editingCell.textLabel.text;
    }
    self.editingCell.textLabel.text = @"";
    [self.editingCell.contentView addSubview: self.txtField];
    [self.txtField becomeFirstResponder];
}

-(void) onAddButton{
    if (self.txtField){
        [self.txtField resignFirstResponder];
    }
    [self.tableItems insertObject:@"" atIndex:0];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onAddDoneButton)];
    self.navigationItem.leftBarButtonItem = nil;
    NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self editCell:firstIndex];
    
}

-(void)addNewCellFromTextField:(UITextField *)textField{
   
    if (textField.text.length !=0){
        
        [self.tableItems setObject:textField.text atIndexedSubscript:self.editingPath.row];
        [self.tableView reloadRowsAtIndexPaths:@[self.editingPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableItems removeObjectAtIndex:0];
        [self.tableView reloadData];
    }
    
    [textField removeFromSuperview];
    
    [self.txtField resignFirstResponder];
    
    
}

@end
