/*
    File: MusicTableViewController.m
Abstract: Table view controller class for AddMusic. Shows the list
of music chosen by the user.
 Version: 1.1
*/


#import "MusicTableViewController.h"
#import "MainViewController.h"

@implementation MusicTableViewController

static NSString *kCellIdentifier = @"Cell";

@synthesize mediaPickerPopover;
@synthesize delegate;					// The main view controller is the delegate for this class.
@synthesize mediaItemCollectionTable;	// The table shown in this class's view.
@synthesize addMusicButton;				// The button for invoking the media item picker. Setting the title
										//		programmatically supports localization.


// Configures the table view.
- (void) viewDidLoad {

    [super viewDidLoad];
	
	[self.addMusicButton setTitle: NSLocalizedString (@"Add Music", @"Add button shown on table view for invoking the media item picker")];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];      
}


// When the user taps Done, invokes the delegate's method that dismisses the table view.
- (IBAction) doneShowingMusicList: (id) sender {

	[self.delegate musicTableViewControllerDidFinish: self];	
}

// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {

	MPMediaPickerController *picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"Add songs to your Playlist", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];

	if (picker) {
		// Creates the popoverController object
		mediaPickerPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
		[mediaPickerPopover setDelegate:self];
       //The parameters of CGRectMake are x, y, width and height
		[mediaPickerPopover presentPopoverFromRect:CGRectMake(503, 400, 18, -10) inView:self.view 
						  permittedArrowDirections:0 animated:NO];
		[mediaPickerPopover setPopoverContentSize:CGSizeMake(325, 475)];	
	}
	[picker release];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  
	NSLog(@"didPickMediaItems: method run");
	[self.mediaPickerPopover dismissPopoverAnimated:YES];
	[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	[self.mediaItemCollectionTable reloadData];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {

	NSLog(@"mediaPickerDidCancel: method run");
	[self dismissModalViewControllerAnimated: YES];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}



#pragma mark Table view methods________________________

// To learn about using table views, see the TableViewSuite sample code  
//		and Table View Programming Guide for iPhone OS.

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {

	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	return [currentQueue.items count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
	
	if (anItem) {
		cell.textLabel.text = [anItem valueForProperty:MPMediaItemPropertyTitle];
	}

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

//	 To conform to the Human Interface Guidelines, selections should not be persistent --
//	 deselect the row after it has been selected.
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

// Handle deletion of an event.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
			forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Updates the mediaCollection array by deleting the appropriate item
		MainViewController *mainViewController = (MainViewController *) self.delegate;
		MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
		NSLog(@"currentQueue array count WAS = %d", [currentQueue.items count]);
//		NSLog(@"the item is currentQueue = %@", currentQueue.items);
		
		// cannot delete last mediaItem therefore we test for [currentQueue count] <= 1
		if (!([currentQueue count] <= 1)) {
		
			// makes a mutable copy, then removes item, then copies modified array back to the userMediaCollection
			NSMutableArray *modifiedMediaItems = [NSMutableArray arrayWithArray:currentQueue.items];
			[modifiedMediaItems removeObjectAtIndex:indexPath.row];		
			mainViewController.userMediaItemCollection = [[MPMediaItemCollection alloc] 
				initWithItems:modifiedMediaItems];

			// Update the array and table view.
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];		
			NSLog(@"currentQueue array count IS NOW = %d", [currentQueue.items count]);
		}
    }   
}

#pragma mark Application state management_____________
// Standard methods for managing application state.
- (void)didReceiveMemoryWarning {

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

	[mediaPickerPopover release];
    [super dealloc];
}


@end
