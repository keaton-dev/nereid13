#import <MediaRemote/MediaRemote.h>
#import "Tweak.h"

@interface CSCoverSheetViewController : UIViewController
@property (nonatomic, retain) UIImageView *nrdArtworkView;
@end

@interface SBMediaController : NSObject
@property (nonatomic, retain) NSData *nrdLastImageData;
@end

BOOL CC;
NSInteger blurRadius = 1;
NSInteger darken = 0;
UIImageView *artworkView = nil;
CSNotificationAdjunctListViewController *adjunctListViewController = nil;
BOOL hasArtwork = NO;
NSInteger player = 2;    // Dawn

%hook CSNotificationAdjunctListViewController
-(void)_didUpdateDisplay {
    %orig;
    if (artworkView) artworkView.hidden = (![self isShowingMediaControls] || !hasArtwork);
}
%end

%hook SBMediaController

%property (nonatomic, retain) NSData *nrdLastImageData;

-(void)setNowPlayingInfo:(id)arg {
    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {

    NSDictionary *dict = (__bridge NSDictionary *)(information);    if(dict) {
    if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
    UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]];    NSLog(@"Got album art! %@", image);
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
    if (artworkView && adjunctListViewController) artworkView.hidden = (![adjunctListViewController isShowingMediaControls] || !hasArtwork);    });
}
%end

%hook CSCoverSheetViewController

%property (nonatomic, retain) UIImageView *nrdArtworkView;

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    if(hasArtwork && !self.nrdArtworkView) {
   self.nrdArtworkView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.nrdArtworkView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.nrdArtworkView atIndex:0];
    self.nrdArtworkView.hidden = NO;
    self.nrdArtworkView.image = [UIImage new];
    NSLog(@"setImage, set");
    }

    if (adjunctListViewController) self.nrdArtworkView.hidden = (![adjunctListViewController isShowingMediaControls] || !hasArtwork);
    //else self.nrdArtworkView.hidden = YES;

    artworkView = self.nrdArtworkView;

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
    if(CC) {
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
%hook CSNotificationAdjunctListViewController
%new
-(void)updateTraitOverride {
    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:player];
    }
}
-(id)init {
    if ((self = %orig)) {
        //[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateTraitOverride) name:@"com.keaton.mediaplus/override" object:nil];
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
%end
