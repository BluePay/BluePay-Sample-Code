###
# Bluepay ColdFusion Sample Code


###
# Contents

SecurityLib.cfm
	This is a third-party library, please see its comments for its licensing. 
  It is only included to provide an MD5 checksum algorithm -- any MD5 algorithm will do.  Feel free to replace it with your own code.

sampleform.cfm
  A simple sample payment form.
  Submits payments to samplypay.cfm

samplepay.cfm
  A simple script that uses the bluepay.cfc component to take payment information POSTed from the sampleform.cfm, submit it to Bluepay, and parse the results.  

bluepay.cfc
  This is a ColdFusion component that takes certain parameters and then processes a payment, returning the results in a STRUCT:
.STATUS = '1' for approval, '0' for decline, 'E' for error
.RRNO   = the Transaction ID (Reference No)
.AVS    = The AVS return character
.CVV2   = The CVV2 return character
.AUTH_CODE = The processing network's authorization code, if any.
.RESULTSTR = A human-readable description of the STATUS.  

The input parameters are all documented within the cfc, and samplepay gives an illustration of its use.
