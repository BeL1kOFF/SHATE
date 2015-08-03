unit SPCatalogAPI_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 02.06.2015 20:04:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\CodeGear\Projects\ServiceFill\SPCatalog\SPCatalogAPI.tlb (1)
// LIBID: {81983F4B-7AEC-459F-AA85-B6CF125980E9}
// LCID: 0
// Helpfile: 
// HelpString: SHATE-M+ CatalogAPI Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SPCatalogAPIMajorVersion = 1;
  SPCatalogAPIMinorVersion = 0;

  LIBID_SPCatalogAPI: TGUID = '{81983F4B-7AEC-459F-AA85-B6CF125980E9}';

  IID_IServProgCatalog: TGUID = '{70C71E7F-211A-4BA1-9535-24C15AB8D3C4}';
  CLASS_ServProgCatalog: TGUID = '{25D786F0-F11A-4743-B0FB-472CAE5043BC}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IServProgCatalog = interface;
  IServProgCatalogDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ServProgCatalog = IServProgCatalog;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// Interface: IServProgCatalog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70C71E7F-211A-4BA1-9535-24C15AB8D3C4}
// *********************************************************************//
  IServProgCatalog = interface(IDispatch)
    ['{70C71E7F-211A-4BA1-9535-24C15AB8D3C4}']
    function GetCrosses(var aCode: WideString; var aBrand: WideString): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf:  IServProgCatalogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70C71E7F-211A-4BA1-9535-24C15AB8D3C4}
// *********************************************************************//
  IServProgCatalogDisp = dispinterface
    ['{70C71E7F-211A-4BA1-9535-24C15AB8D3C4}']
    function GetCrosses(var aCode: WideString; var aBrand: WideString): WideString; dispid 201;
  end;

// *********************************************************************//
// The Class CoServProgCatalog provides a Create and CreateRemote method to          
// create instances of the default interface IServProgCatalog exposed by              
// the CoClass ServProgCatalog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoServProgCatalog = class
    class function Create: IServProgCatalog;
    class function CreateRemote(const MachineName: string): IServProgCatalog;
  end;

implementation

uses ComObj;

class function CoServProgCatalog.Create: IServProgCatalog;
begin
  Result := CreateComObject(CLASS_ServProgCatalog) as IServProgCatalog;
end;

class function CoServProgCatalog.CreateRemote(const MachineName: string): IServProgCatalog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ServProgCatalog) as IServProgCatalog;
end;

end.
