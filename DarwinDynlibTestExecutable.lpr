program DarwinDynlibTestExecutable;

{$APPTYPE CONSOLE}
{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {.$IFDEF UseCThreads}
   cthreads, {.$ENDIF} {$ENDIF}
   DynLibs,
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
   SLibName : string = 'libdarwindynlibtestlibrary.dylib';
  {$IFEND}

   { TMyApplication }

   procedure TMyApplication.Test(AFilename, AFunctionName: string);
   var
      h: THandle;
      sFilename: string;
      //f: TAntiBeaconGetImmunizerListLevelText;
      p: Pointer;
   begin
      sFilename := ExtractFilePath(Application.ExeName) + AFilename;
      WriteLn('[i] ', sFilename);
      h := LoadLibrary(sFilename);
      if (h = 0) then begin
         WriteLn('[-] LoadLibrary(); GetLastOSError = ', SysErrorMessage(GetLastOSError));
         Exit;
      end else begin
         WriteLn('[+] LoadLibrary()');
      end;
      p := GetProcedureAddress(h, AFunctionName);
      if not Assigned(p) then begin
         WriteLn('[-] GetProcAddress(',AFunctionName,'); GetLastOSError = ', SysErrorMessage(GetLastOSError));
         Exit;
      end else begin
         WriteLn('[+] GetProcAddress(',AFunctionName,')');
      end;
   end;

   procedure TMyApplication.DoRun;
   begin
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
