import schema namespace ipo="http://www.example.com/IPO" at "ipo.xsd";
import module namespace calc = "http://www.example.com/calc" at "q11.xqlib";

for $p in doc("ipo.xml")/schema-element(ipo:purchaseOrder)
where $p/shipTo/name="Helen Zoe"
   and $p/@orderDate = xs:date("1999-12-01")
return calc:total-price($p//item) 