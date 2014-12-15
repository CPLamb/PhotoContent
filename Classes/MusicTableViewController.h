/*
    File: MusicTableViewController.h
Abstract: Table view controller class for AddMusic. Shows the list
of music chosen by the user.
 Version: 1.1
*/

#import <MediaPlayer/MediaPlayer.h>

@protocol MusicTableViewControllerDelegate; // forward declaration


@interface MusicTableViewController : UIViewController <MPMediaPickerControllerDelegate,
			UIPopoverControllerDelegate, UITableViewDelegate> {

	id <MusicTableViewControllerDelegate>	delegate;
	UIPopoverController *mediaPickerPopover;
	IBOutlet UITableView					*mediaItemCollectionTable;
	IBOutlet UIBarButtonItem				*addMusicButton;
}

@property (nonatomic, assign) id <MusicTableViewControllerDelegate>	delegate;
@property (nonatomic, retain) UITableView							*mediaItemCollectionTable;
@property (nonatomic, retain) UIBarButtonItem						*addMusicButton;
@property (nonatomic, retain) UIPopoverController *mediaPickerPopover;

- (IBAction) showMediaPicker: (id) sender;
- (IBAction) doneShowingMusicList: (id) sender;

@end



@protocol MusicTableViewControllerDelegate

// implemented in MainViewController.m
- (void) musicTableViewControllerDidFinish: (MusicTableViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end

