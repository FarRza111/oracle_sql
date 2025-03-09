/* ------------------------- JSON Məlumatlarının Saxlanması və Sorğulanması ------------------------- */
/* Bu hissədə j_purchaseorder adlı yeni bir cədvəl yaradılır. 
   Bu cədvəldə JSON formatında məlumatlar saxlanılır. 
   - id: Unikal identifikator (RAW(16)).
   - date_loaded: Məlumatın yükləndiyi tarix (TIMESTAMP WITH TIME ZONE).
   - po_document: JSON məlumatları (CLOB tipində). 
   - CONSTRAINT ensure_json: po_document sütununun JSON formatında olmasını təmin edir. */

CREATE TABLE j_purchaseorder
  (id RAW (16) NOT NULL,
   date_loaded TIMESTAMP(6) WITH TIME ZONE,
   po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON));

/* Cədvələ JSON formatında məlumat əlavə edilir. 
   - SYS_GUID(): Unikal identifikator yaradır.
   - SYSTIMESTAMP: Hazırkı tarix və vaxtı əlavə edir.
   - JSON məlumatları: Satınalma sifarişi ilə bağlı məlumatlar. */

INSERT INTO j_purchaseorder
  VALUES (
    SYS_GUID(),
    SYSTIMESTAMP,
    '{"PONumber"              : 1600,
      "Reference"             : "ABULL-20140421",
       "Requestor"            : "Alexis Bull",
       "User"                 : "ABULL",
       "CostCenter"           : "A50",
       "ShippingInstructions" : {"name"   : "Alexis Bull",
                                 "Address": {"street"   : "200 Sporting Green",
                                              "city"    : "South San Francisco",
                                              "state"   : "CA",
                                              "zipCode" : 99236,
                                              "country" : "United States of America"},
                                 "Phone" : [{"type" : "Office", "number" : "909-555-7307"},
                                            {"type" : "Mobile", "number" : "415-555-1234"}]},
       "Special Instructions" : null,
       "AllowPartialShipment" : true,
       "LineItems" : [{"ItemNumber" : 1,
                       "Part" : {"Description" : "One Magic Christmas",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 13131092899},
                       "Quantity" : 9.0},
                      {"ItemNumber" : 2,
                       "Part" : {"Description" : "Lethal Weapon",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 85391628927},
                       "Quantity" : 5.0}]}');

/* ------------------------- JSON_TABLE ilə Məlumatların Ayrılması ------------------------- */
/* Bu sorğu ilə JSON məlumatlarından "ShippingInstructions" bölməsindəki "Phone" məlumatları ayrılır. 
   - JSON_TABLE: JSON məlumatlarını cədvəl formatına çevirir.
   - COLUMNS: Ayrılacaq sütunları təyin edir. */
SELECT jt.phones
FROM j_purchaseorder,
JSON_TABLE(po_document, '$.ShippingInstructions'
COLUMNS
  (phones VARCHAR2(100) FORMAT JSON PATH '$.Phone')) AS jt;

/* Nəticə:
PHONES
--------------------------------------------------
[{"type":"Office","number":"909-555-7307"},{"type":"Mobile","number":"415-555-1234"}]
*/

/* Bu sorğu ilə "ShippingInstructions.Phone" bölməsindəki hər bir telefon nömrəsi ayrılır. 
   - row_number: Hər bir sətrin sıra nömrəsini göstərir.
   - phone_type: Telefon növü (məsələn, "Office", "Mobile").
   - phone_num: Telefon nömrəsi. */

SELECT jt.*
FROM j_purchaseorder,
JSON_TABLE(po_document, '$.ShippingInstructions.Phone[*]'
COLUMNS (row_number FOR ORDINALITY,
         phone_type VARCHAR2(10) PATH '$.type',
         phone_num VARCHAR2(20) PATH '$.number'))
AS jt;

/* Nəticə:
ROW_NUMBER PHONE_TYPE PHONE_NUM
---------- ---------- --------------------
         1 Office     909-555-7307
         2 Mobile     415-555-1234
*/