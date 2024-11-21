/*
* BluePay C#.NET Sample code.
*
* This code sample runs a $0.00 Credit Card Auth transaction
* to create a transaction ID token.
*/

using System;
using BluePayLibrary;

namespace Transactions
{
    class CreateTokenCC
    {
        public static void Main()
        {
            string accountID = "Merchant's Account ID Here";
            string secretKey = "Merchant's Secret Key Here";
            string mode = "TEST";
            
            BluePay payment = new BluePay
            (
                accountID,
                secretKey,
                mode
            );

            payment.SetCustomerInformation
            (
                firstName: "Bob",
                lastName: "Tester",
                address1: "1234 Test St.",
                address2: "Apt #500",
                city: "Testville",
                state: "IL",
                zip: "54321",
                country: "USA",
                phone: "123-123-12345",
		//storedIndicator: "F",
		//storedType:"C",
		//storedId:"TESTID765456",
                email: "test@bluepay.com"
            );
            
            payment.SetCCInformation
            (
                ccNumber: "4111111111111111",
                ccExpiration: "1225",
                cvv2: "123"
            );

            // Auth Amount: $0.00
            payment.Auth(amount: "0.00");

            // Makes the API Request with BluePay
            payment.Process();

            // If transaction was successful reads the responses from BluePay
            if (payment.IsSuccessfulTransaction())
            {
                Console.WriteLine("Transaction ID/Token: " + payment.GetTransID());
                Console.WriteLine("Transaction Status: " + payment.GetStatus());
                Console.WriteLine("Transaction Message: " + payment.GetMessage());
                Console.WriteLine("AVS Response: " + payment.GetAVS());
                Console.WriteLine("CVV2 Response: " + payment.GetCVV2());
                Console.WriteLine("Masked Payment Account: " + payment.GetMaskedPaymentAccount());
                Console.WriteLine("Card Type: " + payment.GetCardType());
                Console.WriteLine("Authorization Code: " + payment.GetAuthCode());
                //Console.WriteLine("Stored ID: " + payment.GetStoredId());
            }
            else
            {
                Console.WriteLine("Error: " + payment.GetMessage());
            }

        }
    }
}