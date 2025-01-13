<cfinvoke component='bluepay' method='process' returnVariable='foo'
          MERCHANT_ID = "YOUR MERCHANT ID GOES HERE"
          URL         = "https://secure.bluepay.com:443/interfaces/bp10emu"
          TPS_KEY     = 'YOUR SECRET KEY GOES HERE'
          CARD_NUM    = #Form.CARD_NUMBER#
          CARD_CVV2   = #Form.CARD_CVV2#
          CARD_EXPIRE = #Form.CARD_EXPIRE#
          CUST_NAME   = #Form.CARD_NAME#
          STREET1     = #Form.ADDRESS#
          CITY        = #Form.CITY#
          STATE       = #Form.STATE#
          ZIP         = #Form.ZIP#
          EMAIL       = #Form.EMAIL#
          PHONE       = #Form.PHONE#
          AMOUNT      = '10.00'
          TRANS_TYPE  = 'SALE'
          >

<!-- Returns a struct containing:
     STATUS    = 1 = Approved, 0 = Decline, E = Error
     RESULTSTR = Human-readable description of status (ie: "APPROVED")
     RRNO      = Bluepay's Transaction ID number for reference
     AVS       = The AVS Result code from the processor
     CVV2      = The CVV2 Result from the processor
     DEBUG     = The raw string returned from Bluepay's interface, in case things fall apart.
     -->

<cfoutput>
<HTML>
<HEAD>
 <TITLE>
</cfoutput>

<cfif foo.STATUS EQ "1">
  <cfoutput>PAYMENT APPROVED</cfoutput>
<cfelse>
  <cfif foo.STATUS EQ "0">
    <cfoutput>PAYMENT DECLINED</cfoutput>
  <cfelse>
    <cfoutput>ERROR - PLEASE TRY AGAIN</cfoutput>
  </cfif>
</cfif>

<cfoutput>
 </TITLE>
</HEAD>
<BODY>
<H1>#foo.RESULTSTR#</H1>
<br>
</cfoutput>

<cfif foo.STATUS EQ "E">
  <cfoutput>
    There was an error - please use your BACK button to try again.
  </cfoutput>
<cfelse>
  <cfoutput>
    Your transaction ID for future reference is: #foo.RRNO#
  </cfoutput>
</cfif>

<cfoutput>
</BODY></HTML>
</cfoutput>
