/*#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIControl.h>*/
#import "UIImage+BlurAndDarken.h"

@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface MediaControlsVolumeContainerView : UIView <UIGestureRecognizerDelegate>
@end

@interface MRPlatterViewController : UIViewController
@property(retain, nonatomic) MediaControlsVolumeContainerView *volumeContainerView; // @synthesize volumeContainerView=_volumeContainerView;
@end

@interface MPButton : UIButton
@end

@interface MPUMarqueeView : UIView <CAAnimationDelegate>
@end

@interface MediaControlsHeaderView : UIView
@property (nonatomic,retain) UIView * artworkBackground;   
@property (nonatomic,retain) UIImageView * artworkView;                                            //@synthesize artworkView=_artworkView - In the implementation block
@property (nonatomic,retain) UIImageView * placeholderArtworkView;                                 //@synthesize placeholderArtworkView=_placeholderArtworkView - In the implementation block
//@property (assign,nonatomic) CGSize artworkSize;                                                   //@synthesize artworkSize=_artworkSize - In the implementation block
@property (nonatomic,retain) UIView * artworkBackgroundView;                                       //@synthesize artworkBackgroundView=_artworkBackgroundView - In the implementation block
@property (nonatomic,retain) UIView * shadow;                                                      //@synthesize shadow=_shadow - In the implementation block
@property (nonatomic,retain) UILabel * titleLabel;                                                 //@synthesize titleLabel=_titleLabel - In the implementation block
@property (nonatomic,retain) UILabel * routeLabel;     
@property (nonatomic,retain) MPUMarqueeView * primaryMarqueeView;                                  //@synthesize primaryMarqueeView=_primaryMarqueeView - In the implementation block
@property (nonatomic,retain) UILabel * primaryLabel;                                               //@synthesize primaryLabel=_primaryLabel - In the implementation block
@property (nonatomic,retain) MPUMarqueeView * secondaryMarqueeView;                                //@synthesize secondaryMarqueeView=_secondaryMarqueeView - In the implementation block
@property (nonatomic,retain) UILabel * secondaryLabel;                                             //@synthesize secondaryLabel=_secondaryLabel - In the implementation block
@property (nonatomic,retain) UIView * buttonBackground;                                            //@synthesize buttonBackground=_buttonBackground - In the implementation block

@property (nonatomic,retain) MPButton * routingButton;                                             //@synthesize routingButton=_routingButton - In the implementation block

@end

// Dawn
@interface UIView (Nereid13)
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
@end

@interface CSNotificationAdjunctListViewController : UIViewController
-(void)updateTraitOverride;
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
//Nereid13
@property(readonly, nonatomic, getter=isShowingMediaControls) _Bool showingMediaControls;
@end
