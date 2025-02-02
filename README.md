# BluePay-Sample-Code

This sample code is meant for developers looking for a starting point to integrate their applications or website to the BluePay gateway.

Please carefully read the comments in the sample code files for more information on how to connect your sandbox or live gateway account. Before you can start processing transactions, you must enter in your BluePay gateway Account ID and Secret Key. Depending on the platform and language you choose to write in, you may need to install additional libraries in order to successfully implement this sample code.

Since this sample code only works with the BluePay gateway, you will need a gateway account to utilize the code. [Click here](https://developer.fiserv.com/product/CardPointe/docs/?path=docs/documentation/BluePayGatewayAPI.md&branch=main#request-a-sandbox-account) if you'd like to request a sandbox account


# Languages Supported

The list of programming languages that are included in this repository:
- C#
- C++
- Java
- Perl
- PHP
- Python
- Ruby
- VB

# Usage

Every language is structured essentially the same and contains the following:
- A library file that contains the methods necessary for processing transactions, pulling reports, querying the BluePay gateway, etc.
- A directory, labeled 'Transactions', containing samples showing how to process transactions.
- A directory, labeled 'Get Data', containing samples showing how to pull transactions from the BluePay gateway.
- A directory, labeled 'Rebills', containing samples showing how to set up, modify, and delete BluePay rebillings.

As a very basic starting point in order to run the samples, you'll need to input your Account ID and Secret Key. In most circumstances, this is all you will need to run the sample code.

# Disclaimer

The sample code is provided as-is; BluePay does not warrant or guarantee the individual success developers may have in implementing the sample code on their development platforms or in using their own web server configurations. It is entirely up to the developer to take this code and use it as they may. Resolving issues with the development environment is the responsibility of the developer performing the integration. If you are a merchant needing to implement an integration and are not a developer yourself, we highly recommend that you hire or get assistance from one.
