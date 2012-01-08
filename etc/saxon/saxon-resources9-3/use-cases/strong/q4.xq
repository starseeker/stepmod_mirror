import schema namespace ipo="http://www.example.com/IPO" at "ipo.xsd";
import schema namespace pst="http://www.example.com/postals" at "postals.xsd";
import schema namespace zips="http://www.example.com/zips" at "zips.xsd";

import module namespace zok="http://www.example.com/xq/zips" at "q2.xqlib";
import module namespace pok="http://www.example.com/xq/postals" at "q3.xqlib";

declare function local:address-ok($a as element(*, ipo:Address))
 as xs:boolean
{
  typeswitch ($a)
      case $zip as element(*, ipo:USAddress)
           return zok:zip-ok($zip)
      case $postal as element(*, ipo:UKAddress )
           return pok:postal-ok($postal) 
      default return false()
};

for $p in doc("ipo.xml")/schema-element(ipo:purchaseOrder)
where not( local:address-ok($p/shipTo) and local:address-ok($p/billTo))
return $p 

(: returns an empty sequence, by design :)