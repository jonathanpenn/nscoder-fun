//
//  NSCPasswordListViewController.m
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import "NSCPasswordListViewController.h"
#import "NSCPasswordDocument.h"

@interface NSCPasswordListViewController ()
<UIAlertViewDelegate>

@property (nonatomic, strong) NSCPasswordDocument *document;

@end

@implementation NSCPasswordListViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.document = [[NSCPasswordDocument alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (IBAction)addButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Password" message:@"Enter your password, fool!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;

    UITextField *usernameField = [alertView textFieldAtIndex:0];
    UITextField *passwordField = [alertView textFieldAtIndex:1];

    NSCPassword *password = [NSCPassword passwordWithUsername:usernameField.text password:passwordField.text];

    [self.document addPassword:password];

    NSUInteger index = [self.document.items count]-1;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *usernameField = [alertView textFieldAtIndex:0];
    UITextField *passwordField = [alertView textFieldAtIndex:1];
 
    NSPredicate *atLeastOne = [NSPredicate predicateWithFormat:@"text matches %@",@".{1,}"];
    NSPredicate *notNil = [NSPredicate predicateWithFormat:@"text != NULL"];

    NSPredicate *matches = [NSCompoundPredicate andPredicateWithSubpredicates:@[notNil, atLeastOne]];

    return [matches evaluateWithObject:usernameField] && [matches evaluateWithObject:passwordField];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.document.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSCPassword *password = self.document.items[indexPath.row];

    cell.textLabel.text = password.username;
    cell.detailTextLabel.text = password.password;

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.document removePasswordAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

@end
