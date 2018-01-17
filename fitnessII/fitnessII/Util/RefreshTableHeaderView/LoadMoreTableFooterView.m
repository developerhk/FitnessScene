//
//  LoadMoreTableFooterView.m
//  MyApp
//
//  Created by jingyu lu on 9/18/12.
//
//

#import "LoadMoreTableFooterView.h"

// 上提到多少像素可以执行 load more
#define load_more_height 44

@implementation LoadMoreTableFooterView
@synthesize delegate;

- (void)dealloc {
	self.delegate = nil;
	[_indicator release];
	[_loadingButton release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	
	_loadingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	[_loadingButton setFrame:CGRectMake(0, 0, 320, 44)];
	[_loadingButton setTitle:@"More..." forState:UIControlStateNormal];
	[_loadingButton setTitle:@"Loading..." forState:UIControlStateDisabled];
	[_loadingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	[_loadingButton addTarget:self action:@selector(actionLoadMore) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_loadingButton];
	
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_indicator.center = CGPointMake(300, 22);
	_indicator.hidesWhenStopped = YES;
	[self addSubview:_indicator];
}

- (void)setState:(LoadMoreState)state {
	_state = state;
	switch (state) {
		case kLoadMoreStateNormal: {
			_isLoading = NO;
			[_indicator stopAnimating];
			[_loadingButton setEnabled:YES];
		}
			break;
		case kLoadMoreStateLoading: {
			_isLoading = YES;
			[_indicator startAnimating];
			[_loadingButton setEnabled:NO];
		}
			break;
		default:
			break;
	}
}

- (void)doneLoadMore {
	[self setState:kLoadMoreStateNormal];
}

- (void)actionLoadMore {
	if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoading:)]) {
		// 发起加载数据
		[self.delegate loadMoreTableFooterDidTriggerLoading:self];
	}
	[self setState:kLoadMoreStateLoading];
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if (self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		// 获取当前状态是否正在加载数据
		_loading = [self.delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
	
	if ((scrollView.contentOffset.y >= fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height) + load_more_height) && !_loading) {
		
		// 如果没有在加载数据，且scrollView的纵向位移达到设定的60
		[self actionLoadMore];
	}
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[self setState:kLoadMoreStateNormal];
}

@end
