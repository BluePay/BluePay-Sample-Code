<cfoutput>
<html>
<head>
  <title>Please input your payment information.</title>
</head>
<body>
<form action="samplepay.cfm" method="POST">
<table>
<tr><td>Name on Card:</td><td><input type=text name=CARD_NAME></td></tr>
<tr><td>Card Nmber:</td><td><input type=text name=CARD_NUMBER></td></tr>
<tr><td>Card CVV2:</td><td><input type=text name=CARD_CVV2></td></tr>
<tr><td>Card Expire (MMYY):</td><td><input type=text name=CARD_EXPIRE></td></tr>
<tr><td>Street Address:</td><td><input type=text name=ADDRESS></td></tr>
<tr><td>City:</td><td><input type=text name=CITY></td></tr>
<tr><td>State:</td><td><input type=text name=STATE></td></tr>
<tr><td>Zip:</td><td><input type=text name=ZIP></td></tr>
<tr><td>Email:</td><td><input type=text name=EMAIL></td></tr>
<tr><td>Phone:</td><td><input type=text name=PHONE></td></tr>
<tr><td colspan=2><input type=submit name=SUBMIT value="Make Payment"></td></tr>
</table>
</html>
</cfoutput>
