# Fast Track for Azure Dev Test Solution - Mobile DevOps - Setup

This document is work in progress, please stay tuned! 

## Pre-Requisites
* You must have access and be able to deploy into a Microsoft Azure Subscription
* You must have access to a Visual Studio Client (2013, 2015, 2017) and have Xamarin tools installed.
    * [Visual Studio 2013/2015](https://developer.xamarin.com/guides/android/getting_started/installation/windows/#vs2015)
    * [Visual Studio 2017](https://developer.xamarin.com/guides/android/getting_started/installation/windows/#vs2017)

## Steps

1. Download the [CreditCardValidatior.Droid.Zip file](https://github.com/xamarin/test-cloud-samples/raw/master/Quickstarts/downloads/CreditCardValidator.Droid.zip)
2. Open the CreditCardValidator.Droid.sln in Visual Studio.

     ![Screenshot](/Images/xtc-1.png)

3. Navigate to the CreditCardValidator.Droid.UITests project and select Manage NuGet Packages.

![Screenshot](/Images/xtc-2.png)

4. Switch to the Browse tab and search for the **NUnitTestAdapter** package. Click install. This will allow you to see and run your tests from Visual Studio.

![Screenshot](/Images/xtc-3.png)

5. Navigate to your CreditCardValidator>Droid.UITests project and open the Tests.cs file.
6. Add the following code Snippet into the Tests class:

```
[Test]
public void CreditCardNumber_TooShort_DisplayErrorMessage()
{
    app.WaitForElement(c => c.Marked("action_bar_title").Text("Enter Credit Card Number"));
    app.EnterText(c => c.Marked("creditCardNumberText"), new string('9', 15));
    app.Tap(c => c.Marked("validateButton"));

    app.WaitForElement(c => c.Marked("errorMessagesText").Text("Credit card number is too short."));
}
```
The result should look similar to the below screenshot:

![Screenshot](/Images/xtc-4.png)

7. Navigate to the Build menu and select Build Solution.

![Screenshot](/Images/xtc-5.png)

8. Deploy the CreditCardValidator.Droid app to the Android emulator.

![Screenshot](/Images/xtc-6.png)

8. Navigate to the Test menu and select Run > All Tests.

![Screenshot](/Images/xtc-7.png)

9. Further screenshots to be captured on 

## Next Steps

You have successfully setup a UI Test for your Xamarin Android application. Now progress to the next module on [configuring HockeyApp in your app](hockey-app.md).

## References
* [Xamarin.Android Quickstart for Xamarin.UITest](https://developer.xamarin.com/guides/testcloud/uitest/quickstarts/android/)