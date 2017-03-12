//
//	ReaderViewController.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderViewController.h"
#import "ThumbsViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ReaderContentView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"
#import "ReaderAlertView.h"

#import <MessageUI/MessageUI.h>
#import "UIImageView+WebCache.h"

#define kPHONE_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define kPHONE_HEIGHT ([UIScreen mainScreen].bounds.size.height)


static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImageDownloderOldShouldDecompressImages = YES;
static NSUInteger SDImageCacheOldMaxMemoryCost = 0;
static NSUInteger SDImageCacheOldshouldCacheImagesInMemory = YES;



@interface ReaderViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate,
									ReaderMainToolbarDelegate, ReaderMainPagebarDelegate, ReaderContentViewDelegate, ThumbsViewControllerDelegate,ReaderAlertViewDelegate>

@property(nonatomic,strong) ReaderDocument *document;
@end

@implementation ReaderViewController
{


	UIScrollView *theScrollView;

	ReaderMainToolbar *mainToolbar;

	ReaderMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;

	UIUserInterfaceIdiom userInterfaceIdiom;

	NSInteger currentPage, minimumPage, maximumPage;

	UIDocumentInteractionController *documentInteraction;

	UIPrintInteractionController *printInteraction;

	CGFloat scrollViewOutset;

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL ignoreDidScroll;
    
    UIButton *backButton;
    ReaderAlertView *alertView;
    BOOL isScrolling;
    UIDeviceOrientation theCurrentOrientation;
}

#pragma mark - Constants

#define STATUS_HEIGHT 20.0f
/**
 *  修改三方 44--> 64 TOOLBAR_HEIGHT
 */
#define TOOLBAR_HEIGHT 64.0f
#define PAGEBAR_HEIGHT 48.0f

#define SCROLLVIEW_OUTSET_SMALL 4.0f
#define SCROLLVIEW_OUTSET_LARGE 8.0f

#define TAP_AREA_SIZE 48.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ReaderViewController methods

- (void)updateContentSize:(UIScrollView *)scrollView
{
	CGFloat contentHeight = scrollView.bounds.size.height; // Height

	CGFloat contentWidth = (scrollView.bounds.size.width * maximumPage);

	scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateContentViews:(UIScrollView *)scrollView
{
	[self updateContentSize:scrollView]; // Update content size first

	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
		^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
		{
			NSInteger page = [key integerValue]; // Page number value

			CGRect viewRect = CGRectZero; viewRect.size = scrollView.bounds.size;

			viewRect.origin.x = (viewRect.size.width * (page - 1)); // Update X

			contentView.frame = CGRectInset(viewRect, scrollViewOutset, 0.0f);
		}
	];

	NSInteger page = currentPage; // Update scroll view offset to current page
	CGPoint contentOffset = CGPointMake((scrollView.bounds.size.width * (page - 1)), 0.0f);

	if (CGPointEqualToPoint(scrollView.contentOffset, contentOffset) == false) // Update
	{
		scrollView.contentOffset = contentOffset; // Update content offset
	}

	[mainToolbar setBookmarkState:[self.document.bookmarks containsIndex:page]];

	[mainPagebar updatePagebar]; // Update page bar
}

- (void)addContentView:(UIScrollView *)scrollView page:(NSInteger)page
{
	CGRect viewRect = CGRectZero; viewRect.size = scrollView.bounds.size;

	viewRect.origin.x = (viewRect.size.width * (page - 1)); viewRect = CGRectInset(viewRect, scrollViewOutset, 0.0f);

	NSURL *fileURL = self.document.fileURL; NSString *phrase = self.document.password; NSString *guid = self.document.guid; // Document properties
    /**
     修改三方
     */
	ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:page password:phrase document:self.document]; // ReaderContentView

	contentView.message = self; [contentViews setObject:contentView forKey:[NSNumber numberWithInteger:page]]; [scrollView addSubview:contentView];

	[contentView showPageThumb:fileURL page:page password:phrase guid:guid]; // Request page preview thumb
}

- (void)layoutContentViews:(UIScrollView *)scrollView
{
	CGFloat viewWidth = scrollView.bounds.size.width; // View width

	CGFloat contentOffsetX = scrollView.contentOffset.x; // Content offset X

	NSInteger pageB = ((contentOffsetX + viewWidth - 1.0f) / viewWidth); // Pages

	NSInteger pageA = (contentOffsetX / viewWidth); pageB += 2; // Add extra pages

	if (pageA < minimumPage) pageA = minimumPage; if (pageB > maximumPage) pageB = maximumPage;

	NSRange pageRange = NSMakeRange(pageA, (pageB - pageA + 1)); // Make page range (A to B)

	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSetWithIndexesInRange:pageRange];

	for (NSNumber *key in [contentViews allKeys]) // Enumerate content views
	{
		NSInteger page = [key integerValue]; // Page number value

		if ([pageSet containsIndex:page] == NO) // Remove content view
		{
			ReaderContentView *contentView = [contentViews objectForKey:key];
            
			[contentView removeFromSuperview]; [contentViews removeObjectForKey:key];
            /**
             *  修改三方
             */
            contentView = nil;
		}
		else // Visible content view - so remove it from page set
		{
			[pageSet removeIndex:page];
		}
	}

	NSInteger pages = pageSet.count;


	if (pages > 0) // We have pages to add
	{
		NSEnumerationOptions options = 0; // Default

		if (pages == 2) // Handle case of only two content views
		{
			if ((maximumPage > 2) && ([pageSet lastIndex] == maximumPage)) options = NSEnumerationReverse;
		}
		else if (pages == 3) // Handle three content views - show the middle one first
		{
			NSMutableIndexSet *workSet = [pageSet mutableCopy]; options = NSEnumerationReverse;

			[workSet removeIndex:[pageSet firstIndex]]; [workSet removeIndex:[pageSet lastIndex]];

			NSInteger page = [workSet firstIndex]; [pageSet removeIndex:page];

			[self addContentView:scrollView page:page];
		}

		[pageSet enumerateIndexesWithOptions:options usingBlock: // Enumerate page set
			^(NSUInteger page, BOOL *stop)
			{
				[self addContentView:scrollView page:page];
			}
		];
	}
}

- (void)handleScrollViewDidEnd:(UIScrollView *)scrollView
{
	CGFloat viewWidth = scrollView.bounds.size.width; // Scroll view width

	CGFloat contentOffsetX = scrollView.contentOffset.x; // Content offset X

	NSInteger page = (contentOffsetX / viewWidth); page++; // Page number

	if (page != currentPage) // Only if on different page
	{
		currentPage = page; self.document.pageNumber = [NSNumber numberWithInteger:page];
		[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
			^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
			{
				if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
			}
		];

		[mainToolbar setBookmarkState:[self.document.bookmarks containsIndex:page]];

		[mainPagebar updatePagebar]; // Update page bar
	}
    
}

- (void)showDocumentPage:(NSInteger)page
{
	if (page != currentPage) // Only if on different page
	{
		if ((page < minimumPage) || (page > maximumPage)) return;

		currentPage = page; self.document.pageNumber = [NSNumber numberWithInteger:page];

		CGPoint contentOffset = CGPointMake((theScrollView.bounds.size.width * (page - 1)), 0.0f);

		if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == true)
			[self layoutContentViews:theScrollView];
		else
			[theScrollView setContentOffset:contentOffset];

		[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
			^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
			{
				if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
			}
		];

		[mainToolbar setBookmarkState:[self.document.bookmarks containsIndex:page]];

		[mainPagebar updatePagebar]; // Update page bar
	}
}

- (void)showDocument
{
	[self updateContentSize:theScrollView]; // Update content size first

	[self showDocumentPage:[self.document.pageNumber integerValue]]; // Show page

	self.document.lastOpen = [NSDate date]; // Update document last opened date
}

- (void)closeDocument
{
	if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	[self.document archiveDocumentProperties]; // Save any ReaderDocument changes

	[[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:self.document.guid];

	[[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache

    [self.document archiveDocumentProperties];
    if (self.dismissReaderControll) {
        self.dismissReaderControll(self);
    }

//	if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
//	{
//		[delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
//	}
//	else // We have a "Delegate must respond to -dismissReaderViewController:" error
//	{
//		NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
//	}
}

#pragma mark - UIViewController methods

- (instancetype)initWithReaderDocument:(ReaderDocument *)object
{
	if ((self = [super initWithNibName:nil bundle:nil])) // Initialize superclass
	{
		if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]])) // Valid object
		{
			userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom; // User interface idiom

			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter]; // Default notification center

			[notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillTerminateNotification object:nil];

			[notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillResignActiveNotification object:nil];

			scrollViewOutset = ((userInterfaceIdiom == UIUserInterfaceIdiomPad) ? SCROLLVIEW_OUTSET_LARGE : SCROLLVIEW_OUTSET_SMALL);

			[object updateDocumentProperties]; self.document = object; // Retain the supplied ReaderDocument object for our use

			[ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
		}
		else // Invalid ReaderDocument object
		{
			self = nil;
		}
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    mainToolbar = nil; mainPagebar = nil;
    
    theScrollView.delegate = nil;
    [theScrollView removeFromSuperview];
    [contentViews removeAllObjects];
    theScrollView = nil; contentViews = nil; lastHideTime = nil;
    
    documentInteraction = nil; printInteraction = nil;
    
    lastAppearSize = CGSizeZero; currentPage = 0;
    

    self.document = nil;
    
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.shouldDecompressImages = SDImageCacheOldShouldDecompressImages;
    canche.maxMemoryCost =SDImageCacheOldMaxMemoryCost;
    canche.shouldCacheImagesInMemory = SDImageCacheOldshouldCacheImagesInMemory;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImageDownloderOldShouldDecompressImages;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	assert(self.document != nil); // Must have a valid ReaderDocument
    // 设定pdf缓存
    SDImageCache *canche = [SDImageCache sharedImageCache];
    SDImageCacheOldShouldDecompressImages = canche.shouldDecompressImages;
    SDImageCacheOldMaxMemoryCost = canche.maxMemoryCost;
    SDImageCacheOldshouldCacheImagesInMemory = canche.shouldCacheImagesInMemory;
    canche.shouldDecompressImages = NO;
    canche.shouldCacheImagesInMemory = NO;
    canche.maxMemoryCost = 300*(1024*1024);
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImageDownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
    
    /**
     *  背景颜色
     */
	self.view.backgroundColor = [UIColor whiteColor]; // Neutral gray

	UIView *fakeStatusBar = nil; CGRect viewRect = self.view.bounds; // View bounds

	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
	{
		if ([self prefersStatusBarHidden] == NO) // Visible status bar
		{
            /**
             *  修改
             */
//			CGRect statusBarRect = viewRect; statusBarRect.size.height = STATUS_HEIGHT;
//			fakeStatusBar = [[UIView alloc] initWithFrame:statusBarRect]; // UIView
//			fakeStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//			fakeStatusBar.backgroundColor = [UIColor blackColor];
//			fakeStatusBar.contentMode = UIViewContentModeRedraw;
//			fakeStatusBar.userInteractionEnabled = NO;
//
//			viewRect.origin.y += STATUS_HEIGHT; viewRect.size.height -= STATUS_HEIGHT;
		}
	}

	CGRect scrollViewRect = CGRectInset(viewRect, -scrollViewOutset, 0.0f);
	theScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect]; // All
	theScrollView.autoresizesSubviews = NO; theScrollView.contentMode = UIViewContentModeRedraw;
	theScrollView.showsHorizontalScrollIndicator = NO; theScrollView.showsVerticalScrollIndicator = NO;
	theScrollView.scrollsToTop = NO; theScrollView.delaysContentTouches = NO; theScrollView.pagingEnabled = YES;
	theScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	theScrollView.backgroundColor = [UIColor clearColor]; theScrollView.delegate = self;
	[self.view addSubview:theScrollView];

	CGRect toolbarRect = viewRect; toolbarRect.size.height = TOOLBAR_HEIGHT;


	CGRect pagebarRect = self.view.bounds; pagebarRect.size.height = PAGEBAR_HEIGHT;
	pagebarRect.origin.y = (self.view.bounds.size.height - pagebarRect.size.height);
    /**
     *  修改三方
     */
    if (self.document.appType == eReaderMedPlusType) {
        /**
         医栈 菜单在上
         */
        mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:toolbarRect document:self.document]; // ReaderMainPagebar
    }
    else
    {
        /**
         唯医 菜单在下
         */
        mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:pagebarRect document:self.document]; // ReaderMainPagebar
    }
	
	mainPagebar.delegate = self; // ReaderMainPagebarDelegate
	[self.view addSubview:mainPagebar];

    /**
     *  修改三方 添加返回
     */
    CGSize size = [UIScreen mainScreen].bounds.size;
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, size.height - 60, 40, 40)];
    /**
     *  返回按钮
     */
    if (self.document.appType == eReaderMedPlusType) {
        
        [self.view addSubview:backButton];
//          backButton.widthAndHeight = 40;
//        [backButton setBackBtnClick:^{
//            // 归档
//            [weakSelf.document archiveDocumentProperties];
//            if (weakSelf.dismissReaderControll) {
//                weakSelf.dismissReaderControll(weakSelf);
//            }
//        }];
        backButton.backgroundColor = [UIColor colorWithRed:2/255.0f green:184/255.0f blue:117/255.0f alpha:1.0];// RGBACOLOR(2,184,117,1.0)
        backButton.layer.cornerRadius = 20;
        backButton.layer.shadowColor = [UIColor grayColor].CGColor;
        backButton.layer.shadowOpacity = 0.5;
        backButton.layer.shadowRadius = 2;
        backButton.layer.shadowOffset = CGSizeMake(0, 2);
        
        [backButton setImage:[UIImage imageNamed:@"BottomBackeView_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"BottomBackeView_back"] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(mybackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        mainToolbar = [[ReaderMainToolbar alloc] initWithFrame:toolbarRect document:self.document]; // ReaderMainToolbar
        mainToolbar.delegate = self; // ReaderMainToolbarDelegate
        /**
         *  修改三方
         */
        [self.view addSubview:mainToolbar];
    }

    
    
	if (fakeStatusBar != nil) [self.view addSubview:fakeStatusBar]; // Add status bar background view

	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	[self.view addGestureRecognizer:singleTapOne];

	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
	[self.view addGestureRecognizer:doubleTapOne];

	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
	[self.view addGestureRecognizer:doubleTapTwo];

	[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail

	contentViews = [NSMutableDictionary new]; lastHideTime = [NSDate date];

	minimumPage = 1; maximumPage = [self.document.pageCount integerValue];
    
    if (self.document.appType == eReaderMedPlusType) {
        // 发送旋转通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        theCurrentOrientation = UIDeviceOrientationPortrait;
        
        alertView = [[ReaderAlertView alloc] init];
        alertView.delegate = self;
        NSString *pageStr = [NSString stringWithFormat:@"您上次浏览到%zd页，是否继续浏览？",[self.document.pageNumber integerValue]];
        [alertView setAlertTitle:@"提示" Message:pageStr cancelButton:@"重新浏览" configButtonTitle:@"继续浏览"];
        
    }
    
}

-(void)mybackButtonClick:(UIButton *)sender
{
    // 归档
    [self.document archiveDocumentProperties];
    if (self.dismissReaderControll) {
        self.dismissReaderControll(self);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
			[self updateContentViews:theScrollView]; // Update content views
		}

		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
    /**
     *  修改三方
     */
    if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == true)
    {
        [self performSelector:@selector(showDocument) withObject:nil afterDelay:0.0];
        if ([self.document.pageNumber integerValue] != 1) {
            [alertView show];
        }
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidAppear:(BOOL)animated
{

	[super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = YES;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	lastAppearSize = self.view.bounds.size; // Track view size

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = NO;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	mainToolbar = nil; mainPagebar = nil;
    
    theScrollView.delegate = nil;
    [theScrollView removeFromSuperview];
    [contentViews removeAllObjects];
	theScrollView = nil; contentViews = nil; lastHideTime = nil;

	documentInteraction = nil; printInteraction = nil;

	lastAppearSize = CGSizeZero; currentPage = 0;

	[super viewDidUnload];
}

//- (BOOL)prefersStatusBarHidden
//{
//	return YES;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//	return UIStatusBarStyleDefault;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	ignoreDidScroll = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
	{
		[self updateContentViews:theScrollView]; lastAppearSize = CGSizeZero;
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	ignoreDidScroll = NO;
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (ignoreDidScroll == NO) [self layoutContentViews:scrollView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self handleScrollViewDidEnd:scrollView];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
	[self handleScrollViewDidEnd:scrollView];
    isScrolling = NO;
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;

	return NO;
}

#pragma mark - UIGestureRecognizer action methods

- (void)decrementPageNumber
{
	if ((maximumPage > minimumPage) && (currentPage != minimumPage))
	{
		CGPoint contentOffset = theScrollView.contentOffset; // Offset

		contentOffset.x -= theScrollView.bounds.size.width; // View X--

		[theScrollView setContentOffset:contentOffset animated:YES];
	}
}

- (void)incrementPageNumber
{
	if ((maximumPage > minimumPage) && (currentPage != maximumPage))
	{
		CGPoint contentOffset = theScrollView.contentOffset; // Offset

		contentOffset.x += theScrollView.bounds.size.width; // View X++

		[theScrollView setContentOffset:contentOffset animated:YES];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view]; // Point

		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area rect

		if (CGRectContainsPoint(areaRect, point) == true) // Single tap is inside area
		{
			NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key]; // View

			id target = [targetView processSingleTap:recognizer]; // Target object

            [targetView renewedlyLoadingBtnClick];
            
			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object

					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string

						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [[NSString alloc] initWithFormat:@"http://%@", www];

							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}

					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
						#ifdef DEBUG
							NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
						#endif
					}
				}
				else // Not a URL, so check for another possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger number = [target integerValue]; // Number

						[self showDocumentPage:number]; // Show the page
					}
				}
			}
			else // Nothing active tapped in the target content view
			{
				if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
				{
					if ((mainToolbar.alpha < 1.0f) || (mainPagebar.alpha < 1.0f)) // Hidden
					{
						[mainToolbar showToolbar]; [mainPagebar showPagebar]; // Show
                        /**
                         *  修改三方 返回显示
                         */
                        [UIView animateWithDuration:0.25 delay:0.0
                                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                         animations:^(void)
                         {
                             backButton.hidden = NO;
                             backButton.alpha = 1.0f;
                         }
                                         completion:NULL
                         ];
                            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

					}
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point) == true) // page++
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point) == true) // page--
		{
			[self decrementPageNumber]; return;
		}
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view]; // Point

		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE); // Area

		if (CGRectContainsPoint(zoomArea, point) == true) // Double tap is inside zoom area
		{
			NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key]; // View

			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom++
				{
					[targetView zoomIncrement:recognizer]; break;
				}

				case 2: // Two finger double tap: zoom--
				{
					[targetView zoomDecrement:recognizer]; break;
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point) == true) // page++
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point) == true) // page--
		{
			[self decrementPageNumber]; return;
		}
	}
}

#pragma mark - ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
	if ((mainToolbar.alpha > 0.0f) || (mainPagebar.alpha > 0.0f))
	{
		if (touches.count == 1) // Single touches only
		{
			UITouch *touch = [touches anyObject]; // Touch info

			CGPoint point = [touch locationInView:self.view]; // Touch location

			CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);

			if (CGRectContainsPoint(areaRect, point) == false) return;
		}

		[mainToolbar hideToolbar]; [mainPagebar hidePagebar]; // Hide
        /**
         *  修改三方 返回隐藏
         */
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             backButton.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             backButton.hidden = YES;
         }
         ];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
		lastHideTime = [NSDate date]; // Set last hide time
	}
}

#pragma mark - ReaderMainToolbarDelegate methods

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (READER_STANDALONE == FALSE) // Option

	[self closeDocument]; // Close ReaderViewController

#endif // end of READER_STANDALONE Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:self.document];

	thumbsViewController.title = self.title; thumbsViewController.delegate = self; // ThumbsViewControllerDelegate

	thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;

	[self presentViewController:thumbsViewController animated:NO completion:NULL];

#endif // end of READER_ENABLE_THUMBS Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar exportButton:(UIButton *)button
{
	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	NSURL *fileURL = self.document.fileURL; // Document file URL

	documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];

	documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate

	[documentInteraction presentOpenInMenuFromRect:button.bounds inView:button animated:YES];
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar printButton:(UIButton *)button
{
	if ([UIPrintInteractionController isPrintingAvailable] == YES)
	{
		NSURL *fileURL = self.document.fileURL; // Document file URL

		if ([UIPrintInteractionController canPrintURL:fileURL] == YES)
		{
			printInteraction = [UIPrintInteractionController sharedPrintController];

			UIPrintInfo *printInfo = [UIPrintInfo printInfo];
			printInfo.duplex = UIPrintInfoDuplexLongEdge;
			printInfo.outputType = UIPrintInfoOutputGeneral;
			printInfo.jobName = self.document.fileName;

			printInteraction.printInfo = printInfo;
			printInteraction.printingItem = fileURL;
			printInteraction.showsPageRange = YES;

			if (userInterfaceIdiom == UIUserInterfaceIdiomPad) // Large device printing
			{
				[printInteraction presentFromRect:button.bounds inView:button animated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
			else // Handle printing on small device
			{
				[printInteraction presentAnimated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
		}
	}
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar emailButton:(UIButton *)button
{
	if ([MFMailComposeViewController canSendMail] == NO) return;

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	unsigned long long fileSize = [self.document.fileSize unsignedLongLongValue];

	if (fileSize < 15728640ull) // Check attachment size limit (15MB)
	{
		NSURL *fileURL = self.document.fileURL; NSString *fileName = self.document.fileName;

		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];

		if (attachment != nil) // Ensure that we have valid document file attachment data available
		{
			MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

			[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];

			[mailComposer setSubject:fileName]; // Use the document file name for the subject

			mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;

			mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate

			[self presentViewController:mailComposer animated:YES completion:NULL];
		}
	}
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	if ([self.document.bookmarks containsIndex:currentPage]) // Remove bookmark
	{
		[self.document.bookmarks removeIndex:currentPage]; [mainToolbar setBookmarkState:NO];
	}
	else // Add the bookmarked page number to the bookmark index set
	{
		[self.document.bookmarks addIndex:currentPage]; [mainToolbar setBookmarkState:YES];
	}

#endif // end of READER_BOOKMARKS Option
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
	if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif

	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
	documentInteraction = nil;
}

#pragma mark - ThumbsViewControllerDelegate methods

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	[self showDocumentPage:page];

#endif // end of READER_ENABLE_THUMBS Option
}

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	[self dismissViewControllerAnimated:NO completion:NULL];

#endif // end of READER_ENABLE_THUMBS Option
}

#pragma mark - ReaderMainPagebarDelegate methods

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
{
	[self showDocumentPage:page];
}

#pragma mark -ReaderAlertViewDelegate
-(void)altertView:(ReaderAlertView *)alertView didSelectedAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        
        self.document.pageNumber = @(1);
        [self showDocument];
        
    }else{
    }

}

#pragma mark - UIApplication notification methods

- (void)applicationWillResign:(NSNotification *)notification
{
	[self.document archiveDocumentProperties]; // Save any ReaderDocument changes

	if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];
}


#pragma mark - deviceOrientation notification  methods
-(void)receivedRotate: (NSNotification *)notification{
    if (alertView.isShow) {
        return;
    }
   UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (theCurrentOrientation == deviceOrientation) {
        return;
    }
    if (deviceOrientation == UIDeviceOrientationPortrait || deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        
          [self rotationCurrentViewWithOrientation:deviceOrientation];
          theCurrentOrientation = deviceOrientation;
    }
  
    
}

#pragma mark -deviceOrientationMethod
-(void)rotationCurrentViewWithOrientation:(UIDeviceOrientation )deviceOrientation{
    
    // lyf修改 解决plus情况放大后旋转卡住情况
    ReaderContentView *contentView = contentViews[[NSNumber numberWithInteger:currentPage]];
    [contentView removeFromSuperview];
    [contentViews removeObjectForKey:[NSNumber numberWithInteger:currentPage]];
    [self layoutContentViews:theScrollView];
    ignoreDidScroll = YES;
//    ReaderContentView *contentView = contentViews[[NSNumber numberWithInteger:currentPage]];
//    [contentView zoomResetAnimated:YES];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:// 竖直方向
            
        {
            [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
                self.view.frame = CGRectMake(0, 0, kPHONE_WIDTH, kPHONE_HEIGHT);
                backButton.frame = CGRectMake(20, size.height - 60, 40, 40);
                mainPagebar.frame = CGRectMake(0, 0, kPHONE_WIDTH,TOOLBAR_HEIGHT);
                UILabel *pageLabel = [mainPagebar valueForKey:@"pageNumberLabel"];
                pageLabel.frame = CGRectMake((kPHONE_WIDTH - pageLabel.frame.size.width)/2, kPHONE_HEIGHT - 25 - pageLabel.frame.size.height, pageLabel.frame.size.width, pageLabel.frame.size.height);
                if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
                {
                    [self updateContentViews:theScrollView];
                    lastAppearSize = CGSizeZero;
                }
                [self.view layoutIfNeeded];
            
                
            } completion:^(BOOL finished) {
                
                ignoreDidScroll = NO;
                [self updateContentViews:theScrollView];
                
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight:// 横右
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
                self.view.frame = CGRectMake(0,0, kPHONE_WIDTH, kPHONE_HEIGHT);
                backButton.frame = CGRectMake(20,kPHONE_WIDTH - 60, 40, 40);
                mainPagebar.frame = CGRectMake(0, 0, kPHONE_HEIGHT, TOOLBAR_HEIGHT);
                UILabel *pageLabel = [mainPagebar valueForKey:@"pageNumberLabel"];
                pageLabel.frame = CGRectMake((kPHONE_HEIGHT - pageLabel.frame.size.width)/2, kPHONE_WIDTH - 25 - pageLabel.frame.size.height, pageLabel.frame.size.width, pageLabel.frame.size.height);
                if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
                {
                    [self updateContentViews:theScrollView];
                    lastAppearSize = CGSizeZero;
                }
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                ignoreDidScroll = NO;
                [self updateContentViews:theScrollView];

            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:// 横左
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
                self.view.frame = CGRectMake(0,0, kPHONE_WIDTH, kPHONE_HEIGHT);
                
                backButton.frame = CGRectMake(20,kPHONE_WIDTH - 60, 40, 40);
                mainPagebar.frame = CGRectMake(0, 0, kPHONE_HEIGHT, TOOLBAR_HEIGHT);
                UILabel *pageLabel = [mainPagebar valueForKey:@"pageNumberLabel"];
                pageLabel.frame = CGRectMake((kPHONE_HEIGHT - pageLabel.frame.size.width)/2, kPHONE_WIDTH - 25 - pageLabel.frame.size.height, pageLabel.frame.size.width, pageLabel.frame.size.height);
                
                if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
                {
                    [self updateContentViews:theScrollView]; lastAppearSize = CGSizeZero;
                }
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                ignoreDidScroll = NO;
                [self updateContentViews:theScrollView];

            }];
        }
             break;
        default:
        {
        }
            break;
    }
    
}

// 禁止vc旋转
- (BOOL)shouldAutorotate{
    
    return NO;
}


@end
