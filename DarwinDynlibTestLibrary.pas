library DarwinDynlibTestLibrary;

{$mode objfpc}{$H+}

uses
  {$IFDEF Darwin}
  Dynlibs,
  {$ENDIF Darwin}
   Classes;

   function FourtyTwo(): longword; cdecl;
   begin
      Result := 42;
   end;

exports
   FourtyTwo;

end.


