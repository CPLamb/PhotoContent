/*
    File: MainViewController.h
Abstract: View controller class for AddMusic. Sets up user interface, responds 
to and manages user interaction.
 Version: 1.1
*/

#define PLAYER_TYPE_PREF_KEY @"player_type_preference"
#define AUDIO_TYPE_PREF_KEY @"audio_technology_preference"

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MusicTableViewController.h"
#import "SlideShowAppDelegate.h"

@interface MainViewController : UIViewController <MPMediaPickerControllerDelegate, 
			MusicTableViewControllerDelegate, AVAudioPlayerDelegate, UIPopoverControllerDelegate> {

	SlideShowAppDelegate	*applicationDelegate;	
	UIPopoverController *musicTablePopover;
	IBOutlet UIBarButtonItem	*artworkItem;
	IBOutlet UINavigationBar	*navigationBar;
	IBOutlet UILabel			*nowPlayingLabel;
	BOOL						playedMusicOnce;

	AVAudioPlayer				*appSoundPlayer;
	NSURL						*soundFileURL;
	IBOutlet UIButton			*appSoundButton;
	IBOutlet UIButton			*addOrShowMusicButton;
	BOOL						interruptedOnPlayback;
	BOOL						playing ;
	IBOutlet UIButton *playPauseButton;
		

	UIBarButtonItem				*playBarButton;
	UIBarButtonItem				*pauseBarButton;
	MPMusicPlayerController		*musicPlayer;	
	MPMediaItemCollection		*userMediaItemCollection;
	UIImage						*noArtworkImage;
	NSTimer						*backgroundColorTimer;
}

@property (nonatomic, retain)	UIBarButtonItem			*artworkItem;
@property (nonatomic, retain)	UINavigationBar			*navigationBar;
@property (nonatomic, retain)	UILabel					*nowPlayingLabel;
@property (readwrite)			BOOL					playedMusicOnce;

@property (nonatomic, retain)	UIBarButtonItem			*playBarButton;
@property (nonatomic, retain)	UIBarButtonItem			*pauseBarButton;
@property (nonatomic, retain)	MPMediaItemCollection	*userMediaItemCollection; 
@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, retain)	UIImage					*noArtworkImage;
@property (nonatomic, retain)	NSTimer					*backgroundColorTimer;

@property (nonatomic, retain)	AVAudioPlayer			*appSoundPlayer;
@property (nonatomic, retain)	NSURL					*soundFileURL;
@property (nonatomic, retain)	IBOutlet UIButton		*appSoundButton;
@property (nonatomic, retain)	IBOutlet UIButton		*addOrShowMusicButton;
@property (readwrite)			BOOL					interruptedOnPlayback;
@property (readwrite)			BOOL					playing;
@property (nonatomic, retain)	IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain)	UIPopoverController *musicTablePopover;

- (IBAction)	playOrPauseMusic:		(id) sender;
- (IBAction)	AddMusicOrShowMusic:	(id) sender;
- (IBAction)	playAppSound:			(id) sender;
- (IBAction)	skipForward:			(id) sender;
- (IBAction)	skipBackward:			(id) sender;

- (BOOL) useiPodPlayer;

@end
