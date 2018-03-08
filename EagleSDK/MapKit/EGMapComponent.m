    //
    //  EGMapComponent.m
    //  EGMapKit
    //
    //  Created by 顾新生 on 2018/1/9.
    //
#define kEGMapComponent_Default_Region_Distance 2000
#import "EGMapComponent.h"
#import "EGMLocationConverter.h"
#import "EGMAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "EGMapZoomBar.h"

#import <ReactiveObjC/ReactiveObjC.h>
@interface EGMapComponent()<MKMapViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)MKMapView *mapView;
@property(nonatomic,strong)EGMapZoomBar *zoomBar;
@property(nonatomic,strong)EGMapZoomBar *zoomButtons;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,assign)BOOL isSearching;
@end
@implementation EGMapComponent
NSString * const EGMapComponent_AddAnnotation_Channel=@"EGMapComponent_AddAnnotation_Channel";
-(void)componentInit{
    [super componentInit];
    self.scrollEnabled=NO;
    self.isSearching=NO;
    self.backgroundColor=[UIColor blueColor];
    [self initMap];
    
}
-(void)initMap{
    @eg_weakify(self)
    [self addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
        //long press add a pin
    UILongPressGestureRecognizer *lPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(addAPin:)];
    lPress.minimumPressDuration=1.5;
    [self.mapView addGestureRecognizer:lPress];
    
        //search bar
    self.searchBar=[[UISearchBar alloc]init];
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@44);
    }];
    self.searchBar.delegate=self;
    
    [[EGLocationManager manager]setBackgroundLocationUpdate:YES];
    
    [[EGLocationManager manager]requestLocationWithDesiredAccuracy:EGMLocationAccuracyCity timeout:kEGMUpdateTimeStaleThresholdCity delayUntilAuthorized:NO block:^(CLLocation *currentLocation, EGMLocationAccuracy achievedAccuracy, EGMLocationStatus status) {
        
        @eg_strongify(self)
        CLLocationCoordinate2D coordinate=currentLocation.coordinate;
        if(![EGMLocationConverter isLocationOutOfChina:coordinate]){
            coordinate=[EGMLocationConverter convertWGSToGCJ:currentLocation.coordinate];
        }
        [self.mapView setCenterCoordinate:coordinate];
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(coordinate, kEGMapComponent_Default_Region_Distance, kEGMapComponent_Default_Region_Distance);
        
        [self.mapView setRegion:region animated:YES];
        
        EGMAnnotation *a=[[EGMAnnotation alloc]initWithCoordinate:coordinate title:@"hello" subtitle:@"this is a sub"];
        [self.mapView addAnnotation:a];
    }];
    
    [self subscribe:EGMapComponent_AddAnnotation_Channel withBlock:^(id msg) {
            //        EGMAnnotation *annotation=(EGMAnnotation *)msg;
            //        [self.mapView addAnnotation:annotation];
        @eg_strongify(self)
        self.zoomLevel++;
    }];
    
    self.zoomBar=[[EGMapZoomBar alloc]initWithAction:^(int level) {
        [self.mapView setCenterCoordinate:self.mapView.region.center zoomLevel:level animated:YES];
        
    }];
    [self addSubview:self.zoomBar];
    [self.zoomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-40));
        make.centerY.equalTo(@0);
        make.height.equalTo(@200);
        make.width.equalTo(@25);
    }];
    
    self.zoomButtons=[[EGMapZoomBar alloc]initWithType:EGMapZoomBarTypeButtons action:^(int level) {
        @eg_strongify(self)
        [self.mapView setCenterCoordinate:self.mapView.region.center zoomLevel:level animated:YES];
        
    }];
    [self addSubview:self.zoomButtons];
    [self.zoomButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-40));
        make.bottom.offset(-50);
        make.height.equalTo(@60);
        make.width.equalTo(@25);
    }];
}


-(void)injectJSONDataSource:(id)jsonDataSource{
    NSDictionary *dataSource=(NSDictionary *)jsonDataSource;
}

-(void)removeFromSuperview{
    [EGLocationManager releaseManager];
    [super removeFromSuperview];
}

-(void)addAPin:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point=[gesture locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    EGMAnnotation *annotation=[[EGMAnnotation alloc]initWithCoordinate:location title:@"Add" subtitle:@"this is add"];
    annotation.animatedDrop=YES;
    [self.mapView addAnnotation:annotation];
}

#pragma mark ---------------Search---------------
-(void)requestSearch:(NSString *)keyword withResultHandler:(EGMSearchResultHandler)resultHandler{
    MKLocalSearchRequest *request=[[MKLocalSearchRequest alloc]init];
    request.naturalLanguageQuery=keyword;
    request.region=MKCoordinateRegionMake(self.mapView.centerCoordinate, self.mapView.region.span);
    MKLocalSearch *search=[[MKLocalSearch alloc]initWithRequest:request];
        //    MKLocalSearchResponse *response = [[EGMSearchCache defaultCache]getCacheResponseForRequest:request];
        //    if (response && resultHandler) {
        //        resultHandler(response,nil);
        //    } else {
    @eg_weakify(self)
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        @eg_strongify(self)
            //            [[EGMSearchCache defaultCache]setCacheResponse:response forRequest:request];
        if (resultHandler) {
            resultHandler(response,error);
        }
        NSArray *results=response.mapItems;
        [self.mapView removeAnnotations:self.mapView.annotations];
        for (MKMapItem *item in results) {
            MKPlacemark *mark=item.placemark;
            NSMutableArray *subTitles=[NSMutableArray array];
            if (mark.thoroughfare) {
                [subTitles addObject:mark.thoroughfare];
            }
            if (mark.subLocality) {
                [subTitles addObject:mark.thoroughfare];
            }
            if (mark.locality) {
                [subTitles addObject:mark.locality];
            }
            if (mark.administrativeArea) {
                [subTitles addObject:mark.administrativeArea];
            }
            NSString *subTitle=[subTitles componentsJoinedByString:@","];
            EGMAnnotation *annotation=[[EGMAnnotation alloc]initWithCoordinate:mark.coordinate title:mark.name subtitle:subTitle];
            [self.mapView addAnnotation:annotation];
//            MKCircle *circle=[MKCircle circleWithCenterCoordinate:mark.coordinate radius:20];
//            [self.mapView addOverlay:circle];
        }
    }];
        //    }
    
}

#pragma mark ---------------MKMapViewDelegate---------------
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *a=(MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"a"];
    if (a==nil) {
        a=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"a"];
        a.image=[UIImage imageNamed:@"hoteldetail_address"];
        a.canShowCallout=YES;
        if ([annotation isKindOfClass:[EGMAnnotation class]]) {
//            a.animatesDrop=((EGMAnnotation *)annotation).animatedDrop;
        }
        a.annotation=annotation;
        a.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"photo"]];
    }
    return a;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    EGMAnnotation *a=view.annotation;
    CLLocationCoordinate2D center=a.coordinate;
    CLLocation *location=[[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude];
//    [[EGLocationManager manager]geocodeLocation:location forAnnotation:a];
    [[EGLocationManager manager]geocodeAddress:@"No. 641 Jiefang South Road"];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%d",self.zoomLevel);
    self.zoomBar.level=self.zoomLevel;
    self.zoomButtons.level=self.zoomLevel;
    if (self.isSearching) {
        [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:self.searchBar];
    }
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer=[[MKCircleRenderer alloc]initWithOverlay:overlay];
        renderer.strokeColor=[UIColor blueColor];
        return renderer;
    }
    return [[MKOverlayRenderer alloc]initWithOverlay:overlay];
}

#pragma mark ---------------search bar---------------
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    
    [searchBar resignFirstResponder];
    NSString *keyword=searchBar.text;
    if (keyword==nil || keyword.length==0) {
        self.isSearching=NO;
        return;
    }
    self.isSearching=YES;
    [self requestSearch:keyword withResultHandler:^(MKLocalSearchResponse *results, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
#pragma mark ---------------setter & getter---------------

-(int)zoomLevel{
    return [self.mapView getZoomLevel];
}

-(void)setZoomLevel:(int)zoomLevel{
    [self.mapView setCenterCoordinate:self.mapView.region.center zoomLevel:zoomLevel animated:YES];
    
}


-(void)setShowUserLocation:(BOOL)showUserLocation{
    [self.mapView setShowsUserLocation:showUserLocation];
    if (showUserLocation) {
        [[EGLocationManager manager]requestLocationWithDesiredAccuracy:EGMLocationAccuracyRoom timeout:kEGMUpdateTimeStaleThresholdRoom block:^(CLLocation *currentLocation, EGMLocationAccuracy achievedAccuracy, EGMLocationStatus status) {
            [self.mapView setCenterCoordinate:currentLocation.coordinate];
            
        }];
    }
}

#pragma mark ---------------lazy var---------------
-(MKMapView *)mapView{
    if (_mapView==nil) {
        _mapView=[[MKMapView alloc]init];
        _mapView.delegate=self;
        _mapView.showsUserLocation=NO;
    }
    return _mapView;
}
@end
