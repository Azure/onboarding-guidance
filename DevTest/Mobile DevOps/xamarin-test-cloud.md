# Fast Track for Azure Dev Test Solution - Mobile DevOps - Setup

This document is work in progress, please stay tuned! 

## Pre-Requisites
* You must have access and be able to deploy into a Microsoft Azure Subscription

## Steps

1. Clone or download the [Xamarin Test Cloud Samples Repository](https://github.com/xamarin/test-cloud-samples)
2. Open the CreditCardValidator.Droid
3. Add the following code Snippet into CreditCardValidator.UITests

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