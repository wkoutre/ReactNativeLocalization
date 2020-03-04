//
// The MIT License (MIT)
//
// Copyright (c) 2015 Stefano Falda (stefano.falda@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "ReactLocalization.h"

@interface ReactLocalization ()
-(NSString*) getCurrentLanguage;
-(NSString*) getCurrentRegion;
-(NSString*) getUserLocale;
@end

@implementation ReactLocalization
  RCT_EXPORT_MODULE();
/*
 * Private implementation - return the language and the region like 'en-US' if iOS >= 10 otherwise just the language
 */
-(NSString*) getCurrentLanguage{

    // Fallback
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

-(NSString*) getCurrentRegion{
    NSString *userRegion = [self getUserRegion];

    NSLog(@"User region from getCurrentRegion: %@", userRegion);

    if (userRegion) {
        return userRegion;
    }

    // Fallback
     return [[NSLocale preferredLanguages] objectAtIndex:0];
}

-(NSString*) getUserLocale {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray* locales = [prefs objectForKey:@"AppleLanguages"];
    if (locales == nil ) { return nil; }
    if ([locales count] == 0) { return nil; }

    NSString* userLocale = locales[0];
    return userLocale;
}

-(NSString*) getUserRegion {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userRegion = [prefs stringForKey:@"UserRegion"];

    NSLog(@"User Region: %@", userRegion);

    if (userRegion == nil ) { return nil; }

    return userRegion;
}



/*
 * Method called from javascript; return a Promise which resolves a string
 */
RCT_EXPORT_METHOD(getLanguage:(RCTPromiseResolveBlock)resolve
                  resultRejecter:(RCTPromiseRejectBlock)reject){
    NSString* language =  [self getCurrentLanguage];

    NSLog(@"getLanguage: %@", language);

    resolve(language);
}

/*
 * Method called from javascript; return a Promise which resolves in case of successfully setting the language constant
 */
RCT_EXPORT_METHOD(setAppLanguage:(NSString *)languageCode
resultResolved:(RCTPromiseResolveBlock)resolve
                  resultRejecter:(RCTPromiseRejectBlock)reject){
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:languageCode, nil] forKey:@"AppleLanguages"];

    NSLog(@"New Language Code: %@", languageCode);

    resolve(languageCode);
}

/*
 * Method called from javascript; return a Promise which resolves in case of successfully setting the region constant
 */
RCT_EXPORT_METHOD(setAppRegion:(NSString *)region
resultResolved:(RCTPromiseResolveBlock)resolve
                  resultRejecter:(RCTPromiseRejectBlock)reject){
    NSLog(@"setAppRegion, 'region' Param: %@", region);

    [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"UserRegion"];

    NSString* newRegion = [self getUserRegion];

    NSLog(@"setAppRegion, 'newRegion': %@", newRegion);


    resolve(region);
}

/*
 * Method called from javascript; return a Promise which resolves in case of successfully setting the region constant
 */
RCT_EXPORT_METHOD(getAppRegion:(RCTPromiseResolveBlock)resolve
                  resultRejecter:(RCTPromiseRejectBlock)reject){

    NSString* region = [self getUserRegion];

    NSLog(@"getAppRegion, 'region': %@", region);

    resolve(region);
}


/*
 * Expose the language and region directly to javascript avoiding the callback
 */
- (NSDictionary *)constantsToExport
{
    return @{
        @"language": [self getCurrentLanguage],
        @"region": [self getCurrentRegion]
    };

}

+(BOOL)requiresMainQueueSetup
{
    return YES;
}
@end
