program DarwinDynlibTestExecutable;

{$APPTYPE CONSOLE}
{$mode objfpc}{$H+}

uses
   DynLibs,
   {$IFDEF UNIX} cthreads, {$ENDIF}
   Classes,
   SysUtils,
   CustApp;

type

   { TMyApplication }

   TMyApplication = class(TCustomApplication)
   private
      procedure Test(AFilename, AFunctionName: string);
   protected
      procedure DoRun; override;
   public
      constructor Create(TheOwner: TComponent); override;
      destructor Destroy; override;
   end;

var
   Application: TMyApplication;

{$IF DEFINED(MSWindows)}
const
   SLibName = 'DarwinDynlibTestLibrary.dll';
   {$ELSEIF DEFINED(Darwin)}
   SLibName: string = 'libdarwindynlibtestlibrary.dylib';

  {$IFEND}

   { TMyApplication }

   procedure TMyApplication.Test(AFilename, AFunctionName: string);
   var
      h: TLibHandle;
      sFilename: string;
      p: Pointer;
   begin
      sFilename := ExtractFilePath(Application.ExeName) + AFilename;
      WriteLn('[i] ', sFilename);
      h := LoadLibrary(sFilename);
      if (h = NilHandle) then begin
         WriteLn('[-] LoadLibrary(); GetLastOSError = ', SysErrorMessage(GetLastOSError), '; GetLoadErrorStr = ', GetLoadErrorStr);
         Exit;
      end else begin
         WriteLn('[+] LoadLibrary() = ', IntToStr(h), '; GetLoadErrorStr = ', GetLoadErrorStr);
      end;
      p := GetProcedureAddress(h, AFunctionName);
      if not Assigned(p) then begin
         WriteLn('[-] GetProcAddress(', AFunctionName, '); GetLastOSError = ', SysErrorMessage(GetLastOSError), '; GetLoadErrorStr = ', GetLoadErrorStr);
      end else begin
         WriteLn('[+] GetProcAddress(', AFunctionName, ')');
      end;
      p := nil;
      p := GetProcedureAddress(h, '_' + AFunctionName);
      if not Assigned(p) then begin
         WriteLn('[-] GetProcAddress(_', AFunctionName, '); GetLastOSError = ', SysErrorMessage(GetLastOSError), '; GetLoadErrorStr = ', GetLoadErrorStr);
      end else begin
         WriteLn('[+] GetProcAddress(_', AFunctionName, ')');
      end;
   end;

   procedure TMyApplication.DoRun;
   begin
      WriteLn('[i] Test Version 2');
      Test(SLibName, 'FourtyTwo');
      Terminate;
   end;

   constructor TMyApplication.Create(TheOwner: TComponent);
   begin
      inherited Create(TheOwner);
      StopOnException := True;
   end;

   destructor TMyApplication.Destroy;
   begin
      inherited Destroy;
   end;

begin
   Application := TMyApplication.Create(nil);
   Application.Title := 'My Application';
   Application.Run;
   Application.Free;
end.
