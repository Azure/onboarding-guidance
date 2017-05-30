# Fast Track for Azure Dev Test Solution - Mobile DevOps - HockeyApp Setup

This folder is work in progress, please stay tuned! 

## Pre-Requisites
* You must have completed the [Xamarin Test Cloud](setup.md) section first.
* If you do not yet have a HockeyApp account, first [sign up for an account](https://rink.hockeyapp.net/registrations/new). Once you have submitted the form, you will need to verify your e-mail address.

## Create a new HockeyApp Application
1. Browse to your [HockeyApp Dashboard](https://rink.hockeyapp.net/manage/dashboard).
2. Click on the New App button (Note: You will need to have verified your e-mail address first.)
3. Select "Create the app manually instead".
4. Enter the details, as shown in the image below.

     ![Screenshot](/Images/hockeyapp-1.png)

5. Click Create.
6. You will now be taken to a page specifically to manage your newly created application. Copy the App ID, as we will need it later.

     ![Screenshot](/Images/hockeyapp-2.png)

## Add Crash Analytics to your Application

1. Open your existing CreditCardValidator.Droid project in Visual Studio, and Navigate to Project -> Manage Nuget Packages.
2. Search for HockeySDK.Xamarin and add it to your project.
3. Open your MainActivity.cs file.
4. Add the following line at the top of your MainActivity.cs file:

```
using HockeyApp.Android;
```

5. Add the following lines within your MainActivity class:

```
protected override void OnResume ()
{
    base.OnResume();
    CrashManager.Register(this, "{YourAppID}");
}
```

**Note: Replace {YourAppID} with your App ID from the HockeyApp Portal**

6. Open your CreditCardValidationSuccess.cs file.
7. In the last line of your OnCreate class, add the following line:

```
throw new System.Exception("Example of HockeyApps Crash Analytics");
```
8. Rebuild your CreditCardValidator.Droid solution, and deploy it to your Emulator.
9. Enter a valid Credit Card Number (16 digits long), and allow the app to crash.


     ![Screenshot](/Images/hockeyapp-3.png)

10. Reopen the app by selecting the "Enter Credit Card Number" app from the app screen. Select "Send report" when the app completes loading.

     ![Screenshot](/Images/hockeyapp-4.png)

11. Navigate to your application in your [HockeyApp Dashboard](https://rink.hockeyapp.net/manage/dashboard).

     ![Screenshot](/Images/hockeyapp-5.png)

12. Select "Crashes" in the top navigation menu. You will see that information is beginning to appear from your application about your crashes.
13. Open your CreditCardValidationSuccess.cs file and comment out the line with the exception, as we are now progressing to another section.

## User Metrics
1. Open your MainActivity.cs file
2. Add the following line at the top of your MainActivity.cs file:

```
using HockeyApp.Android.Metrics;
```
3. In your OnCreate method add:
```
MetricsManager.Register(Application, "{YourAppID}");
```
**Note: Replace {YourAppID} with your App ID from the HockeyApp Portal**

4. Rebuild your CreditCardValidator.Droid solution, and deploy it to your Emulator.
5. Open the application and perform some basic user testing.
6. Navigate to your application in your [HockeyApp Dashboard](https://rink.hockeyapp.net/manage/dashboard). Scroll down to the User Metrics section. You should begin seeing data flow about your User Engagement, and number of sessions from those users.

     ![Screenshot](/Images/hockeyapp-6.png)

## Add custom events
1. First, ensure that you have correctly setup your User Metrics configuration as outlined above.
2. Open CreditCardValidation success.cs.
3. At the top of the file, add the following lines:
```
using HockeyApp;
using System.Collections.Generic;
```
4. Replace your OnCreate method with the following:

```
protected override void OnCreate(Bundle bundle)
{
    var watch = System.Diagnostics.Stopwatch.StartNew();

    base.OnCreate(bundle);

    SetContentView(Resource.Layout.CreditCardValidationSuccess);

    watch.Stop();
    double elapsedMs = watch.ElapsedMilliseconds;

    HockeyApp.MetricsManager.TrackEvent(
    "Credit Card Validation",
    new Dictionary<string, string> { { "property", "value" } },
    new Dictionary<string, double> { { "duration", elapsedMs } }
    );

    //throw new System.Exception("Example of HockeyApps Crash Analytics");
}
```

5. Navigate to your application in your [HockeyApp Dashboard](https://rink.hockeyapp.net/manage/dashboard) and select the Events tab.

     ![Screenshot](/Images/hockeyapp-7.png)

## Add update distribution

1. Open your MainActivity.cs file.
2. Add the following line at the end of your OnCreate method:

```
CheckForUpdates();
```

3. Within your MainActivity class, add the following code:

```
private void CheckForUpdates() {
// Remove this for builds going to the Public Store. This step is not needed in iOS as the module automatically disables itself by default
UpdateManager.Register(this, "{YourAppID}");
}

private void UnregisterManagers() {
UpdateManager.Unregister();
}

protected override void OnPause() {
base.OnPause();
UnregisterManagers();
}

protected override void OnDestroy() {
base.OnDestroy();
UnregisterManagers();
}
```

**Note: Replace {YourAppID} with your App ID from the HockeyApp Portal**

4. **To be completed...**

## Add in-app feedback

1. Open CreditCardValidator.Droid/Resources/layout/Main.xaml. Add the following code within the LinearLayout block.

```
<Button
    android:text="@string/send_feedback"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:id="@+id/sendFeedback "
    android:background="#ff0000"
    android:textColor="@android:color/white"
    android:textSize="28sp"
    android:layout_marginLeft="30dp"
    android:layout_marginRight="30dp"
    android:layout_marginTop="40dp" />
```

2. Open CreditCardValidator.Droid/Resources/values/Strings.axml. Add the following snippet within the resources block.

```
  <string name="send_feedback">Send Feedback</string>
```

3. Open the MainActivity.cs file.

4. Add the following snippet in the MainActivity class, near the other object instantiations.

```
Button _feedbackButton;
```

5. Add the following lines at the end of your OnCreate method:

```
FeedbackManager.Register(this, "{YourAppId}");

            _feedbackButton = FindViewById<Button>(Resource.Id.sendFeedback);
            _feedbackButton.Click += delegate {
                FeedbackManager.ShowFeedbackActivity(ApplicationContext);
            };
```

**Note: Replace {YourAppID} with your App ID from the HockeyApp Portal**

4. Rebuild your CreditCardValidator.Droid solution, and deploy it to your Emulator.
5. Open the application, and click on the Send Feedback button.

     ![Screenshot](/Images/hockeyapp-8.png)

6. Submit an example set of user feedback.

     ![Screenshot](/Images/hockeyapp-9.png)

7. Navigate to your application in your [HockeyApp Dashboard](https://rink.hockeyapp.net/manage/dashboard) and select the Feedback Tab. 

     ![Screenshot](/Images/hockeyapp-10.png)

8. You will see the feedback that you submitted through the app. Click on it, to find the details.

     ![Screenshot](/Images/hockeyapp-11.png)

9. Provide a response, and submit a comment. Once complete, refresh the application. You will see the response from Development team. 

     ![Screenshot](/Images/hockeyapp-12.png)

## Useful References
* [How to integrate HockeyApp with Xamarin](https://support.hockeyapp.net/kb/client-integration-cross-platform/how-to-integrate-hockeyapp-with-xamarin)
* [HockeyApp for Android (SDK)](https://support.hockeyapp.net/kb/client-integration-android/hockeyapp-for-android-sdk)
* [HockeyApp for iOS](https://support.hockeyapp.net/kb/client-integration-ios-mac-os-x-tvos/hockeyapp-for-ios)