# Fast Track for Azure Dev Test Solution - Mobile DevOps - Setup

This document is work in progress, please stay tuned! 

## Pre-Requisites
* You must have access and be able to deploy into a Microsoft Azure Subscription
* You must have access to a Visual Studio Client (2013, 2015, 2017) and have Xamarin tools installed.
    * [Visual Studio 2013/2015](https://developer.xamarin.com/guides/android/getting_started/installation/windows/#vs2015)
    * [Visual Studio 2017](https://developer.xamarin.com/guides/android/getting_started/installation/windows/#vs2017)
* You must have access to Xamarin Test Cloud. You can [sign up for a 30 day free trial](https://testcloud.xamarin.com/). You can sign up with a valid business e-mail address.

## Steps

1. Download the [CreditCardValidatior.Droid.Zip file](https://github.com/xamarin/test-cloud-samples/raw/master/Quickstarts/downloads/CreditCardValidator.Droid.zip)
2. Open the CreditCardValidator.Droid.sln in Visual Studio.

     ![Screenshot](/Images/xtc-1.png)

3. Navigate to your CreditCardValidator>Droid.UITests project and open the Tests.cs file.

4. Add the following code Snippet into the Tests class:

```
[Test]
public void CreditCardNumber_TooShort_DisplayErrorMessage()
    {
    //First, wait for the default screen and set context on the input box.
    //Take a screenshot
    app.WaitForElement(c => c.Marked("action_bar_title").Text("Enter Credit Card Number"));
    app.Screenshot("Default View");

    //Then, enter a string of digits and take a screenshot
    app.EnterText(c => c.Marked("creditCardNumberText"), new string('9', 15));
    app.Screenshot("Text Entered");
    app.WaitForElement(c => c.Marked("action_bar_title").Text("Enter Credit Card Number"));

    //Finally, progress with validation and verify the message.
    app.Tap(c => c.Marked("validateButton"));
    app.WaitForElement(c => c.Marked("errorMessagesText").Text("Credit card number is too short."));
    app.Screenshot("Complete");
}
```
The result should look similar to the below screenshot:

![Screenshot](/Images/xtc-4.png)

5. Navigate to [Xamarin Test Cloud](https://testcloud.xamarin.com/) in your web browser.

6. Select the New Test Run button in the top menu.

![Screenshot](/Images/xtc-8.png)

7. As we are developing an Android app in Xamarin, click on "I'm testing an Android app".

![Screenshot](/Images/xtc-9.png)

8. You can test your devices on a number of devices in Xamarin Test Cloud. On the next screen, you can select a set of the devices to be used within a test run.

![Screenshot](/Images/xtc-10.png)

9. You will then need to specify meta-data about the run (e.g. The Series for the test, as well as the system language).

![Screenshot](/Images/xtc-11.png)

10. You will find a set of tabs showing the testing framework options. We have been using the Xamarin UITest framework, so ensure that you have selected the UITest tab. Also select either OS X or windows, depending on the OS that you are using.

![Screenshot](/Images/xtc-12.png)

11. Open up a PowerShell command prompt. Change the working directory to {your solution folder}/packages/Xamarin.UITest.version/tools.

12. Execute the test-cloud.exe using a command similar to the below. We have included the relative links to the apk and assembly directory for ease.

```
.\test-cloud.exe submit ".\test-cloud.exe submit "..\..\..\CreditCardValidator.Droid\bin\Release\com.xamarin.example.creditcardvalidator.apk" {Enter your Hash} --devices {Enter your Device Hash} --series "master" --locale "{Enter your locale}" --user {Enter your user} --assembly-dir "..\..\..\CreditCardValidator.Droid.UITests\bin\Release\"
```

Once the script has executed successfully, you will find an output similar to the below.

![Screenshot](/Images/xtc-13.png)

13. Navigate to the link that has been outputted from the PowerShell command prompt. Alternatively, you can navigate to the appropriate view using Xamarin Test Cloud in your web browser.

14. You should see that your test run has completed successfully, without any failures. Click on the *Credit Card Number Too Short Display* test in the left hand menu.

![Screenshot](/Images/xtc-14.png)

15. Recall back to the UITest that you copied in Step 4. It contained a number of app.Screenshot("") steps. As you can see in the screenshot below, this enables you to view the output of your application at multiple stages throughout your test.

16. Click on the Google Pixel image.

![Screenshot](/Images/xtc-15.png)

16. You could dig deeper into a particular device, if there was a failure. Now that we are on the Google Pixel page, we can select the *Device Log* option at the top of the page.


![Screenshot](/Images/xtc-16.png)

17. This device log section allows you to view the output from the physical device on which your application test ran and is helpful if you have encountered a test failure.

![Screenshot](/Images/xtc-17.png)

Congratulations, you have successfully executed a UITest for an Android project on Xamarin Test Cloud using a Google Pixel and Google Pixel XL.

If you later decided that you want to extend your testing across a larger pool of devices, then you can click on *New Test Run* in the top menu bar and generate a new Test Run. You would then select the CreditCardValidator application using a new pool of devices. This would then generate a different hash for your new pool of devices.

## Steps to test the app on a local device

From step 6 in the above section, it is possible to deploy your app onto a local device. Alternatively, you can also deploy onto an emulator, though you may encounter issues depending upon the configuration of your development.

1. Navigate to the CreditCardValidator.Droid.UITests project and select Manage NuGet Packages.

![Screenshot](/Images/xtc-2.png)

2. Switch to the Browse tab and search for the **NUnitTestAdapter** package. Click install. This will allow you to see and run your tests from Visual Studio.

![Screenshot](/Images/xtc-3.png)

3. Navigate to the Build menu and select Build Solution.

![Screenshot](/Images/xtc-5.png)

4. Deploy the CreditCardValidator.Droid app to the Android emulator.

![Screenshot](/Images/xtc-6.png)

5. Navigate to the Test menu and select Run > All Tests.

![Screenshot](/Images/xtc-7.png)

## Next Steps

You have successfully setup a UI Test for your Xamarin Android application. Now progress to the next module on [configuring HockeyApp in your app](hockey-app.md).

## References
* [Xamarin.Android Quickstart for Xamarin.UITest](https://developer.xamarin.com/guides/testcloud/uitest/quickstarts/android/)