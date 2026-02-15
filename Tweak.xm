#import <UIKit/UIKit.h>

%hook UIApplication

- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{

            UIWindow *window = application.windows.firstObject;
            if (!window) return;

            UIView *overlay = [[UIView alloc] initWithFrame:window.bounds];
            overlay.backgroundColor = UIColor.blackColor;

            NSString *path = [NSString stringWithFormat:@"%@/gaevschi.png",
                              [[NSBundle mainBundle] bundlePath]];

            UIImage *img = [UIImage imageWithContentsOfFile:path];
            if (!img) return;

            UIImageView *logo = [[UIImageView alloc] initWithImage:img];
            logo.contentMode = UIViewContentModeScaleAspectFit;
            logo.frame = overlay.bounds;
            logo.alpha = 0;
            logo.transform = CGAffineTransformMakeScale(0.85, 0.85);

            [overlay addSubview:logo];
            [window addSubview:overlay];

            [UIView animateWithDuration:0.8 animations:^{
                logo.alpha = 1;
                logo.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {

                [UIView animateWithDuration:0.5
                                      delay:0.6
                                    options:0
                                 animations:^{
                    overlay.alpha = 0;
                } completion:^(BOOL finished) {
                    [overlay removeFromSuperview];
                }];
            }];
        });
    });
}

%end
