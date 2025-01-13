<!--
Bluepay ColdFusion Component rev 4
(c) 2025 Bluepay, Inc
All rights reserved.

"Note: The IsDefined function does not test the existence of array elements. Instead, put any code that
might try to access an undefined array element in a try block and use a catch block to handle exceptions
that arise if elements do not exist." -- Macromedia's Online CF Manual
-->
<cfcomponent displayname="Bluepay Client">

<cffunction name="process" access="public" output="false" returntype="struct">
  <cfargument name="MERCHANT_ID" type="string" required="Yes"
              displayname="Bluepay Merchant ID"
              hint="This is the 12-digit Gateway Account ID that starts with 100. It is not the Merchant ID."
              >
  <cfargument name="URL" type="string" required="No"
              default="https://secure.bluepay.com:443/interfaces/bp10emu"
              displayname="Bluepay URL"
              hint="This is the URL to POST your Bluepay transactions to."
              >
  <cfargument name="TPS_KEY" type="string" required="Yes"
              displayname="Tamper Proof Seal Key"
              hint="This is your 'secret key' for computing the Tamper Proof Seal"
              >
  <cfargument name="CARD_NUM" type="string" required="no"
              default=""
              displayname="Customer's Account Number"
              hint="The customer's credit card account number."
              >
  <cfargument name="CARD_CVV2" type="string" required="no"
              default=""
              displayname="Customer's CVV2"
              hint="The customer's CVV2 (three-digit code on back of card)"
              >
  <cfargument name="CARD_EXPIRE" type="string" required="no"
              default=""
              displayname="Credit card expire MMYY"
              hint="The Credit Card's expiration date in MMYY format"
              >
  <cfargument name="CUST_NAME"   type="string" required="no"
              default=""
              displayname="Customer's Name"
              hint="The customer's name (first and last, seperated by space)"
              >
  <cfargument name="STREET1" type="string" required="no"
              default=""
              displayname="Street Address Line 1"
              hint="The customer's (billing) street address"
              >
  <cfargument name="STREET2" type="string" required="no"
              default=""
              displayname="Street Address Line 2"
              hint="The customer's (billing) street address, second line (if any)"
              >
  <cfargument name="CITY" type="string" required="no"
              default=""
              displayname="Customer's City"
              hint="The customer's (billing) city name"
              >
  <cfargument name="STATE" type="string" required="no"
              default=""
              displayname="Customer's State"
              hint="The customer's (billing) state name"
              >
  <cfargument name="ZIP" type=string required="no"
              default=""
              displayname="Customer's Zip Code"
              hint="The customer's (billing) zip code"
              >
  <cfargument name="PHONE" type="string" required="no"
              default=""
              displayname="Customer's phone number"
              hint="The customer's (billing) phone number"
              >
  <cfargument name="EMAIL" type="string" required="no"
              default=""
              displayname="Customer's email address"
              hint="The customer's email address (optional)"
              >
  <cfargument name="COMMENT" type="string" required="no"
              default=""
              displayname="Merchant comments"
              hint="A text field for additional comments"
              >
  <cfargument name="ORDER_ID" type="string" required="no"
              default=""
              displayname="Merchant order ID"
              hint="Purchase order, etc"
              >
  <cfargument name="AMOUNT" type="string" required="no"
              default=""
              displayname="Amount to charge"
              hint="The full amount, including tax/shipping"
              >
  <cfargument name="TRANS_TYPE" type="string" required="yes"
              displayname="Transaction type"
              hint="Transaction Type - AUTH or SALE or REFUND or CAPTURE or REBCANCEL"
              >
  <cfargument name="RRNO" type="string" required="no"
              default=""
              displayname="Retrieval Reference Number"
              hint="This is the RRNO of a previous transaction for CAPTURE or REFUND or REBCANCEL"
              >
  <cfargument name="REBILLING" type="string" required="no"
              default="0"
              displayname="Rebilling flag"
              hint="Add rebilling to this AUTH or SALE - 1 for yes, 0 for no"
              >
  <cfargument name="REB_FIRST_DATE" type="string" required="no"
              default=""
              displayname="Rebilling First Date"
              hint="Date of first rebill transaction"
              >
  <cfargument name="REB_EXPR" type="string" required="no"
              default=""
              displayname="Rebilling Expression"
              hint="How often to rebill (ex: '1 MONTH' to rebill monthly"
              >
  <cfargument name="REB_CYCLES" type="string" required="no"
              default=""
              displayname="Rebilling Cycles"
              hint="Number of times to rebill (leave blank to rebill until cancelled manually)"
              >
  <cfargument name="REB_AMOUNT" type="string" required="no"
              default=""
              displayname="Rebilling Amount"
              hint="Optional - set a different amount for the rebilling transactions"
              >
  <cfargument name="MODE" type="string" required="no"
              default="TEST"
              displayname="Live or Test Mode"
              hint="Set to LIVE for a real transaction, TEST for test."
              >
  <cfargument name="TPS_HASH_TYPE" type="string" required="No"
              Default=”” 
              displayname="Tamper Proof Seal Hash Type"
              hint="This is the hash type used to calculate the tamper proof seal."
              >
  <cfargument name="AUTOCAP" type="string" required="no"
              default="0"
              displayname="Automatic Capture"
              hint="Set to 1 for AUTOCAP, 0 for normal"
              >
  <cfargument name="AVS_ALLOWED" type="string" required="no"
              default=""
              displayname="AVS to allow"
              hint="A string containing the allowable AVS results"
              >
  <cfargument name="CVV2_ALLOWED" type="string" required="no"
              default=""
              displayname="CVV2 to allow"
              hint="A string containing the allowable CVV2 results"
              >

  <cfset tps = hash('#TPS_KEY#' & '#MERCHANT_ID#' & '#TRANS_TYPE#' & '#AMOUNT#' & '#REBILLING#' & '#REB_FIRST_DATE#' &
                   '#REB_EXPR#' & '#REB_CYCLES#' & '#REB_AMOUNT#' & '#RRNO#' & '#AVS_ALLOWED#' & '#AUTOCAP#' & '#MODE#','SHA-256','UTF-8')>

  <cfscript>
    RESULT = structNew();
    RESULT.STATUS = 'E';
    RESULT.RRNO = '';
    RESULT.AVS = '';
    RESULT.CVV2 = '';
    RESULT.AUTH_CODE = '';
    RESULT.RESULTSTR = 'Unspecified error';
    RESULT.DEBUG = 'This is the default error.  This can happen when the certificate has not been added to your CA file.';
  </cfscript>
    <cfhttp method="POST" url="#URL#"
            redirect="No" >
      <cfhttpparam type="Formfield" encoded="no" name="MISSING_URL"       value="MISSING">
      <cfhttpparam type="Formfield" encoded="no" name="APPROVED_URL"      value="APPROVED">
      <cfhttpparam type="Formfield" encoded="no" name="DECLINED_URL"      value="DECLINED">
      <cfhttpparam type="Formfield" encoded="no" name="MERCHANT"          value="#urlEncodedFormat(MERCHANT_ID)#">
      <cfhttpparam type="Formfield" encoded="no" name="TRANSACTION_TYPE"  value="#urlEncodedFormat(TRANS_TYPE)#">
      <cfhttpparam type="Formfield" encoded="no" name="CC_NUM"            value="#urlEncodedFormat(CARD_NUM)#">
      <cfhttpparam type="Formfield" encoded="no" name="CVCCVV2"           value="#urlEncodedFormat(CARD_CVV2)#">
      <cfhttpparam type="Formfield" encoded="no" name="CC_EXPIRES"        value="#urlEncodedFormat(CARD_EXPIRE)#">
      <cfhttpparam type="Formfield" encoded="no" name="AMOUNT"            value="#urlEncodedFormat(AMOUNT)#">
      <cfhttpparam type="Formfield" encoded="no" name="ORDER_ID"          value="#urlEncodedFormat(ORDER_ID)#">
      <cfhttpparam type="Formfield" encoded="no" name="NAME"              value="#urlEncodedFormat(CUST_NAME)#">
      <cfhttpparam type="Formfield" encoded="no" name="ADDR1"             value="#urlEncodedFormat(STREET1)#">
      <cfhttpparam type="Formfield" encoded="no" name="ADDR2"             value="#urlEncodedFormat(STREET2)#">
      <cfhttpparam type="Formfield" encoded="no" name="CITY"              value="#urlEncodedFormat(CITY)#">
      <cfhttpparam type="Formfield" encoded="no" name="STATE"             value="#urlEncodedFormat(STATE)#">
      <cfhttpparam type="Formfield" encoded="no" name="ZIPCODE"           value="#urlEncodedFormat(ZIP)#">
      <cfhttpparam type="Formfield" encoded="no" name="COMMENT"           value="#urlEncodedFormat(COMMENT)#">
      <cfhttpparam type="Formfield" encoded="no" name="PHONE"             value="#urlEncodedFormat(PHONE)#">
      <cfhttpparam type="Formfield" encoded="no" name="EMAIL"             value="#urlEncodedFormat(EMAIL)#">
      <cfhttpparam type="Formfield" encoded="no" name="TAMPER_PROOF_SEAL" value="#urlEncodedFormat(tps)#">
      <cfhttpparam type="Formfield" encoded="no" name="TPS_HASH_TYPE"     value="SHA256">
      <cfhttpparam type="FormField" encoded="no" name="MODE"              value="#urlEncodedFormat(MODE)#">
      <cfhttpparam type="FormField" encoded="no" name="REBILLING"         value="#urlEncodedFormat(REBILLING)#">
      <cfhttpparam type="FormField" encoded="no" name="REB_FIRST_DATE"    value="#urlEncodedFormat(REB_FIRST_DATE)#">
      <cfhttpparam type="FormField" encoded="no" name="REB_EXPR"          value="#urlEncodedFormat(REB_EXPR)#">
      <cfhttpparam type="FormField" encoded="no" name="REB_CYCLES"        value="#urlEncodedFormat(REB_CYCLES)#">
      <cfhttpparam type="FormField" encoded="no" name="REB_AMOUNT"        value="#urlEncodedFormat(REB_AMOUNT)#">
      <cfhttpparam type="FormField" encoded="no" name="RRNO"              value="#urlEncodedFormat(RRNO)#">
      <cfhttpparam type="FormField" encoded="no" name="AUTOCAP"           value="#urlEncodedFormat(AUTOCAP)#">
      <cfhttpparam type="FormField" encoded="no" name="AVS_ALLOWED"       value="#urlEncodedFormat(AVS_ALLOWED)#">
      <cfhttpparam type="FormField" encoded="no" name="CVV2_ALLOWED"      value="#urlEncodedFormat(CVV2_ALLOWED)#">
    </cfhttp>
  <cfif not find("302","#cfhttp.statusCode#")>
    <cfset RESULT.RESULTSTR="#cfhttp.statuscode#">
    <cfreturn #RESULT#>
  </cfif>
  <cftry>
    <cfset RESULT.DEBUG="#cfhttp.fileContent#">
    <cfset resp = "#cfhttp.responseHeader["Location"]#">
    <cfset regexres = REFindNoCase("Result=([^&]*)",resp,1,1)>
    <cfset RESULT.RESULTSTR="#Mid(resp,regexres.pos[2],regexres.len[2])#">
    <!-- Extreme paranoia - the only reason I set it to filecontent above and then to Location
         here is so if somehow the location is missing, we might still get some output to work
         with.  Better still would be to dump all the headers and the body - TODO -->
    <cfset RESULT.DEBUG="#cfhttp.responseHeader["Location"]#">


    <cfif RESULT.RESULTSTR eq 'APPROVED'>
      <cfset RESULT.STATUS = '1'>
      <cfset regexres = REFindNoCase("RRNO=([^&]*)",resp,1,1)>
      <cfset RESULT.RRNO = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfset regexres = REFindNoCase("AVS=([^&]*)",resp,1,1)>
      <cfset RESULT.AVS = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfset regesres = REFindNoCase("CVV2=([^&]*)",resp,1,1)>
      <cfset RESULT.CVV2 = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfset regesres = REFindNoCase("AUTH_CODE=([^&]*)",resp,1,1)>
      <cfset RESULT.AUTH_CODE = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfreturn #RESULT#>
    </cfif>



    <cfif RESULT.RESULTSTR eq 'DECLINED'>
      <cfset RESULT.STATUS = '0'>
      <cfset regexres = REFindNoCase("RRNO=([^&]*)",resp,1,1)>
      <cfset RESULT.RRNO = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfset regexres = REFindNoCase("AVS=([^&]*)",resp,1,1)>
      <cfset RESULT.AVS = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfset regesres = REFindNoCase("CVV2=([^&]*)",resp,1,1)>
      <cfset RESULT.CVV2 = "#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfreturn #RESULT#>
    </cfif>



    <cfif RESULT.RESULTSTR eq 'ERROR'>
      <cfset RESULT.STATUS = 'E'>
      <cfset regexres = REFindNoCase("MESSAGE=([^&]*)",resp,1,1)>
      <cfset RESULT.RESULTSTR="#Mid(resp,regexres.pos[2],regexres.len[2])#">
      <cfreturn #RESULT#>
    </cfif>



    <cfif RESULT.RESULTSTR eq 'MISSING'>
      <cfset RESULT.STATUS = 'E'>
      <cfset regexres = REFindNoCase("MISSING=([^&]*)",resp,1,1)>
      <cfset RESULT.RESULTSTR="#Mid(resp,regexres.pos[2],regexres.len[2])#" & " REQUIRED">
      <cfreturn #RESULT#>
    </cfif>

  <cfcatch>
    <!-- If anything goes wrong, we can just return the default (error) for now. -->
  </cfcatch>
  </cftry>


  <cfreturn #RESULT#>
</cffunction>

</cfcomponent>
