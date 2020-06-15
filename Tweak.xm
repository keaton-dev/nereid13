#import "Tweak.h"
#import <MediaRemote/MediaRemote.h>

BOOL enabled;
BOOL artworkAsBackground;
BOOL hideVolumeSlider;
BOOL CC;
NSInteger blurRadius = 0;
NSInteger darken = 0;
//NSInteger color = 0;
NSInteger artworkMode = 0;

UIImageView *artworkView = nil;
CSNotificationAdjunctListViewController *adjunctListViewController = nil;

BOOL hasArtwork = NO;

NSInteger player = 0;    // Dawn

%hook CSNotificationAdjunctListViewController
-(id)init {
    %orig;
    adjunctListViewController = self;
    //return self;

    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:player];
    }
    return self;
}

-(void)_didUpdateDisplay {
    %orig;
    if (artworkView) artworkView.hidden = (!artworkAsBackground || ![self isShowingMediaControls] || !hasArtwork);
}

%new
-(void)updateTraitOverride {
    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:player];
    }
}
/*-(id)init {
    if ((self = %orig)) {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:player];
        }
    }
    return self;
}*/
-(void)viewDidLoad {
    if (player >= 0) {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:player];
        }
    }
    %orig;
}
%end

%hook SBMediaController

%property (nonatomic, retain) NSData *nrdLastImageData;

-(void)setNowPlayingInfo:(id)arg {
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {

    if(!artworkAsBackground) return;

    NSDictionary *dict = (__bridge NSDictionary *)(information);    if(dict) {
    if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
    UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]];    //NSLog(@"Got album art! %@", image);
    if(!image) return;
    hasArtwork = YES;

    if (self.nrdLastImageData && [self.nrdLastImageData isEqualToData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]]) return;
                self.nrdLastImageData = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];

    UIImage *toImage = image;
                if (blurRadius > 0 || darken > 0) {
                    toImage = [image darkened:((CGFloat)darken/100.0f) andBlurredImage:blurRadius];
                }

    [UIView transitionWithView:artworkView duration:0.4f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    artworkView.image = toImage;
                } completion:nil];
    }
    }
    if (artworkView && adjunctListViewController) artworkView.hidden = (!artworkAsBackground || ![adjunctListViewController isShowingMediaControls] || !hasArtwork);    });
}
%end

%hook CSCoverSheetViewController

%property (nonatomic, retain) UIImageView *nrdArtworkView;

-(void)viewWillAppear:(BOOL)animated {
    %orig;
    if(!self.nrdArtworkView) {
   self.nrdArtworkView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.nrdArtworkView atIndex:0];
    self.nrdArtworkView.hidden = NO;
    self.nrdArtworkView.image = [UIImage new];
    //NSLog(@"setImage, set");
    }

    artworkView = self.nrdArtworkView;

    if (artworkMode == 0) self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFill;
    else self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFit;

    if (adjunctListViewController) self.nrdArtworkView.hidden = (!artworkAsBackground || ![adjunctListViewController isShowingMediaControls] || !hasArtwork);
    else self.nrdArtworkView.hidden = YES;

    self.nrdArtworkView.frame = self.view.bounds;
}

-(void)viewDidLayoutSubviews {
    %orig;
    [self.view sendSubviewToBack:self.nrdArtworkView];
    self.nrdArtworkView.frame = self.view.bounds;
}
%end

%hook SBControlCenterController
-(void)init {
    CC = YES;
    %orig;
}
%end

%hook MTMaterialView
-(void)setFrame:(CGRect)arg1 {
    %orig;
    if (([self.superview class] == objc_getClass("PLPlatterView"))) {
        self.hidden = YES;
    }
}
%end

%hook MRPlatterViewController
-(void)viewDidLoad {
    if(CC || !hideVolumeSlider) {
        %orig;
    } else {
        %orig;
        [self.volumeContainerView removeFromSuperview];
    }
}
%end

%hook MediaControlsHeaderView
-(void)layoutSubviews {
    if(CC) {
        %orig;
    } else {

        /* Remove routing stuff */
        [self.routingButton removeFromSuperview];
        if ([self respondsToSelector:@selector(routeLabel)]) [self.routeLabel removeFromSuperview];
        if ([self respondsToSelector:@selector(titleLabel)]) [self.titleLabel removeFromSuperview];

        /* Remove artwork view */
        [self.artworkView removeFromSuperview];
        [self.placeholderArtworkView removeFromSuperview];
        if ([self respondsToSelector:@selector(artworkBackgroundView)]) [self.artworkBackgroundView removeFromSuperview];
        if ([self respondsToSelector:@selector(artworkBackground)]) [self.artworkBackground removeFromSuperview];
        [self.shadow removeFromSuperview];
    }
    if([[[UIApplication sharedApplication] keyWindow] isKindOfClass:%c(SBCoverSheetWindow)]) {
        /* Remove scrolling text */
        self.primaryLabel.textAlignment = NSTextAlignmentCenter;
        self.secondaryLabel.textAlignment = NSTextAlignmentCenter;

        self.primaryMarqueeView.frame = CGRectMake(0, self.primaryMarqueeView.frame.origin.y, self.bounds.size.width, self.primaryMarqueeView.frame.size.height);
        self.secondaryMarqueeView.frame = CGRectMake(0, self.secondaryMarqueeView.frame.origin.y, self.bounds.size.width, self.secondaryMarqueeView.frame.size.height);

        self.primaryLabel.frame = CGRectMake(0, self.primaryLabel.frame.origin.y, self.bounds.size.width, self.primaryLabel.frame.size.height);
        self.secondaryLabel.frame = CGRectMake(0, self.secondaryLabel.frame.origin.y, self.bounds.size.width, self.secondaryLabel.frame.size.height);
    } else {
        %orig;
    }
}
%end

// Dawn
/*%hook CSNotificationAdjunctListViewController
%new
-(void)updateTraitOverride {
    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:player];
    }
}
-(id)init {
    if ((self = %orig)) {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:player];
        }
    }
    return self;
}
-(void)viewDidLoad {
    if (player > 0) {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:player];
        }
    }
    %orig;
}
%end*/

static void loadPrefs() {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.keaton.nereid13.plist"];
    if(prefs) {
        enabled = [prefs objectForKey:@"tweakEnabled"] ? [[prefs objectForKey:@"tweakEnabled"] boolValue] : enabled;   
        artworkAsBackground = [prefs objectForKey:@"artworkAsBackground"] ? [[prefs objectForKey:@"artworkAsBackground"] boolValue] : enabled;
        hideVolumeSlider = [prefs objectForKey:@"hideVolumeSlider"] ? [[prefs objectForKey:@"hideVolumeSlider"] boolValue] : enabled;
        blurRadius = [prefs objectForKey:@"blurRadius"] ? [[prefs objectForKey:@"blurRadius"] floatValue] : 0;
        darken = [prefs objectForKey:@"darken"] ? [[prefs objectForKey:@"darken"] floatValue] : 0;
        //color = [prefs objectForKey:@"color"] ? [[prefs objectForKey:@"color"] floatValue] : 0;
        player = [prefs objectForKey:@"player"] ? [[prefs objectForKey:@"player"] intValue] : 0;
        artworkMode = [prefs objectForKey:@"artworkMode"] ? [[prefs objectForKey:@"artworkMode"] intValue] : 0;
    }
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.keaton.nereid13/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}
