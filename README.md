# Innova Solutions Object Database - Delphi DCUs
Delphi as a product provides easy integration with various relational databases for storing your data but there are other alternatives.

In the early years when the now infamous BDE had to be distributed with all such database applications Innova Solutions chose not to use a standard database for one application which required a simple installation. Instead the application database was persisted as objects in a single file. This led to development of an "Object" database implementation.

In this Object database each object is persisted as a stream or Blob in the file. The database engine takes care of allocating the space and maintaining indexing, etc. but the individual object code is responsible for its stream representation and its own recovery of data from the stream. All objects must inherit from the base object which imposes some restrictions on the code and provides functions to assist in the stream persistence.

Innova Solutions now offers a set of DCUs to Delphi developers which implement the Db logic within the application. A Server executable is available from Innova Solutions which support Client Server for any client applications compiled with the remote option. Client/Server is supported over TCP/IP and incorporates basic encryption.

More Details
http://www.innovasolutions.com.au/delphistuf/ObjectDbInfo/Object%20Database.html

This Repository provides DCUs for various Delphi Versions a installer version of all dcus remains available from
http://docs.innovasolutions.com.au/docs/ObjectDbDCU/Object Framework DCU Setup.exe
