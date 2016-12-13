# Simple Example Project for Innova Solutions Object Database

The example project contained here as "InnovaDbSampleBerlin.dpr" or "InnovaDbSample.dpr" contains a database objects unit "SampleObjects.pas" and two Forms the main form "FrmInnovaDbExample.pas" and a Edit Dialog "DlgObjectEdit.pas" for the Object "TSampleDbObject". The object structure shows encapsulated objects "TSampleData" a DataBase Object "TInnovaSampleDb" with a single index "SampleIndex" and a singleton Configuration Function and Object "TExampleConfigSingleton".

The main form will create a local Db, access the last db and/or a Remote Db on our site.

Once a list member is selected choosing New or Edit shows the edit dialog.

The UI leaves a lot to be desired but it demonstates proof of concept. It also suggests to me that Cross Platform applications clearly require specific UIs for different platforms but at least I now can easily store and share my business data and logic.   

To Get suporting DCUs
https://github.com/rogerinnova/ISObjectDbDCUs

For More Db Details
http://www.innovasolutions.com.au/delphistuf/ObjectDbInfo/Object%20Database.html

More Options are available from
http://delphinotes.innovasolutions.com.au/posts/innova-solutions-object-database-delphi-dcus/
and
http://delphinotes.innovasolutions.com.au/posts/innova-solutions-object-db-now-supports-mobile/  
