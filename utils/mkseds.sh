<!--
 $Id: checkModule.wsf,v 1.1 2003/02/18 08:10:43 robbod Exp $ 
  Author: Rob Bodington, Eurostep Limited
  Owner:  Developed by Eurostep and supplied to NIST under contract.
  Purpose: A script to generate a SEDS report from an issue
-->


C:/apps/java/j2sdk1.4.2_04/jre/bin/java -jar C:/apps/saxon6_5_2/saxon.jar  -o ../data/modules/ap239_product_life_cycle_support/dvlp/seds.txt  ../data/modules/ap239_product_life_cycle_support/dvlp/issues.xml ./mkseds.xsl output_type="TEXT" issue_id="NO-1" seds_author_name="Rob Bodington" seds_author_email="rob.bodington@eurostep.com" seds_date="2004/09/20" seds_by="UK"



