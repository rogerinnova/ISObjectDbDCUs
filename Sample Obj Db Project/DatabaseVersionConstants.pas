unit DatabaseVersionConstants;
interface
Uses
IsPermObjFileStm;

implementation
Const
{
A once only call to
SetCurrentVersion (ACurrentVersion: Word; ALowestVersion: Word) must be
made before attempting to construct any descendants of TISPersistFileObject.

The integer value passed determines the version number of all objects stored in
files and databases and is used to determine the object structure stored when
loading the data back into an object instance.

http://www.innovasolutions.com.au/delphistuf/ObjectDbInfo/Object%20Database.html
Global Persistence Db Functions

This value must be increased whenever the load/store code of any object is changed.
At Innova Solutions we use the same value based on three digit year specifier and
version within the year across all our projects so that we can reuse code
across all applications.

Eg
CVerJuly19_2007 = 20718; //Added BB Notes Memos
CVerNov19_2007 = 20721; //Added FLastNameDataHeaders to TISConfigBaseObj
This gives us 100 releases per year.
{ 1980 00 Millinium Year Year Version for year}

 cSample5Dec2016 = 21601; //First Db Version for 2016

Initialization
  //Need to Register all objects to be stored before Db Access
  SetCurrentVersion(cSample5Dec2016,5);
end.
