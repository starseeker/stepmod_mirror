$Id:  $
The issues raised against the APs and modules listed in this ballot can be
summarised by:



ballot_issues_form_query.xml
	This will display an ISO form of the ballot issues
	The list of issues displayed are filtered according to the
	parameters defined in ballot_issues_form_query.xml
	


ballot_issues_summary.xml
	This will display a table of all the ballot comments and issues
	raised against all the modules and ap listed in ballot_index.	
	The issues displayed can be filtered according to the parameters
	given in ballot_issues_summary.xml  


Filter Parameters
     This will run a query according to the arguments. 

     All the issues against the parts in ballot_index.xml are collected and
     then filtered according to a logical AND of the following parameters:
     filter_member_body (AD | AE | AF | AG | AI | AL | AM | AN | AO | AQ | 
                     AR | AS | AT | AU | AW | AZ | BA | BB | BD | BE | 
                     BF | BG | BH | BI | BJ | BM | BN | BO | BR | BS | 
                     BT | BV | BW | BY | BZ | CA | CC | CD | CF | CG | 
                     CH | CI | CK | CL | CM | CN | CO | CR | CU | CV | 
                     CX | CY | CZ | DE | DJ | DK | DM | DO | DZ | EC | 
                     EE | EG | EH | ER | ES | ET | FI | FJ | FK | FM | 
                     FO | FR | GA | GB | GD | GE | GF | GH | GI | GL | 
                     GM | GN | GP | GQ | GR | GS | GT | GU | GW | GY | 
                     HK | HM | HN | HR | HT | HU | ID | IE | IL | IN | 
                     IO | IQ | IR | IS | IT | JM | JO | JP | KE | KG | 
                     KH | KI | KM | KN | KP | KR | KW | KY | KZ | LA | 
                     LB | LC | LI | LK | LR | LS | LT | LU | LV | LY | 
                     MA | MC | MD | MG | MH | MK | ML | MM | MN | MO | 
                     MP | MQ | MR | MS | MT | MU | MV | MW | MX | MY | 
                     MZ | NA | NC | NE | NF | NG | NI | NL | NO | NP | 
                     NR | NU | NZ | OM | PA | PE | PF | PG | PH | PK | 
                     PL | PM | PN | PR | PS | PT | PW | PY | QA | RE | 
                     RO | RU | RW | SA | SB | SC | SD | SE | SG | SH | 
                     SI | SJ | SK | SL | SM | SN | SO | SR | ST | SV | 
                     SY | SZ | TC | TD | TF | TG | TH | TJ | TK | TL | 
                     TM | TN | TO | TR | TT | TV | TW | TZ | UA | UG | 
                     UK |UM | US | UY | UZ | VA | VC | VE | VG | VI | 
                     VN |VU | WF | WS | YE | YT | YU | ZA | ZM | ZW)
     filter_status="(open | closed" " 
     filter_ballot_comment="(yes | no)"
     filter_seds="(yes | no)"
     filter_resolution="(accept | reject)"
     
     The issue is identified by:
     id_mode="(ballot | issue)" 
     ballot is the id for ballot comemnt a

