library DarwinDynlibTestLibrary;

{$mode objfpc}{$H+}

uses
  Classes
  { you can add units after this };

function FourtyTwo(): longword; cdecl;
begin
   Result := 42;
end;

exports
   FourtyTwo;

begin
end.

