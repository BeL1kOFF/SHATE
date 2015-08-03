{ TODO 1 : В модуле описаны только необходимые на данный момент функции и некоторые константы }

unit ShateM.Winapi.WinHttp;

interface

uses
  Winapi.Windows;

const
  WINHTTP = 'winhttp.dll';

  // WinHttpOpen dwAccessType значения (также для WINHTTP_PROXY_INFO.dwAccessType)

  WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0;
  WINHTTP_ACCESS_TYPE_NO_PROXY      = 1;
  WINHTTP_ACCESS_TYPE_NAMED_PROXY   = 3;

  // WinHttpOpen prettifiers for optional parameters

  WINHTTP_NO_PROXY_NAME         = nil;
  WINHTTP_NO_PROXY_BYPASS       = nil;

  // WinHttpConnect nServerPort значения

  INTERNET_DEFAULT_PORT           = 0;           // Use the protocol-specific default
  INTERNET_DEFAULT_HTTP_PORT      = 80;          // HTTP
  INTERNET_DEFAULT_HTTPS_PORT     = 443;         // HTTPS

  // WinHttpOpenRequest prettifers for optional parameters

  WINHTTP_NO_REFERER            = nil;
  WINHTTP_DEFAULT_ACCEPT_TYPES  = nil;

  // Флаги для WinHttpOpenRequest

  WINHTTP_FLAG_ESCAPE_PERCENT       = $00000004;
  WINHTTP_FLAG_NULL_CODEPAGE        = $00000008;
  WINHTTP_FLAG_ESCAPE_DISABLE       = $00000040;
  WINHTTP_FLAG_ESCAPE_DISABLE_QUERY = $00000080;
  WINHTTP_FLAG_REFRESH              = $00000100;
  WINHTTP_FLAG_SECURE               = $00800000;
  WINHTTP_FLAG_BYPASS_PROXY_CACHE   = WINHTTP_FLAG_REFRESH;

  // WinHttpSendRequest prettifiers for optional parameters

  WINHTTP_NO_ADDITIONAL_HEADERS = nil;
  WINHTTP_NO_REQUEST_DATA       = nil;

  // WINHTTP_STATUS_CALLBACK dwInternetStatus значения

  WINHTTP_CALLBACK_STATUS_RESOLVING_NAME          = $00000001;
  WINHTTP_CALLBACK_STATUS_NAME_RESOLVED           = $00000002;
  WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER    = $00000004;
  WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER     = $00000008;
  WINHTTP_CALLBACK_STATUS_SENDING_REQUEST         = $00000010;
  WINHTTP_CALLBACK_STATUS_REQUEST_SENT            = $00000020;
  WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE      = $00000040;
  WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED       = $00000080;
  WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION      = $00000100;
  WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED       = $00000200;
  WINHTTP_CALLBACK_STATUS_HANDLE_CREATED          = $00000400;
  WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING          = $00000800;
  WINHTTP_CALLBACK_STATUS_DETECTING_PROXY         = $00001000; //not implemented
  WINHTTP_CALLBACK_STATUS_REDIRECT                = $00004000;
  WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE   = $00008000;
  WINHTTP_CALLBACK_STATUS_SECURE_FAILURE          = $00010000;
  WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE       = $00020000;
  WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE          = $00040000;
  WINHTTP_CALLBACK_STATUS_READ_COMPLETE           = $00080000;
  WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE          = $00100000;
  WINHTTP_CALLBACK_STATUS_REQUEST_ERROR           = $00200000;
  WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE    = $00400000;
  WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE = $01000000;
  WINHTTP_CALLBACK_STATUS_CLOSE_COMPLETE          = $02000000;
  WINHTTP_CALLBACK_STATUS_SHUTDOWN_COMPLETE       = $04000000;

  // WINHTTP_STATUS_CALLBACK lpvStatusInformation значения для WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
  // Secure connection error status flags

  WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED         = $00000001;
  WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT            = $00000002;
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED            = $00000004;
  WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA              = $00000008;
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID         = $00000010;
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID       = $00000020;
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE        = $00000040;
  WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR  = $80000000;

  // WinHttpSetStatusCallback dwNotificationFlags значения

  WINHTTP_CALLBACK_FLAG_RESOLVE_NAME              = WINHTTP_CALLBACK_STATUS_RESOLVING_NAME       or WINHTTP_CALLBACK_STATUS_NAME_RESOLVED;
  WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER         = WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER or WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER;
  WINHTTP_CALLBACK_FLAG_SEND_REQUEST              = WINHTTP_CALLBACK_STATUS_SENDING_REQUEST      or WINHTTP_CALLBACK_STATUS_REQUEST_SENT;
  WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE          = WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE   or WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED;
  WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION          = WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION   or WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED;
  WINHTTP_CALLBACK_FLAG_HANDLES                   = WINHTTP_CALLBACK_STATUS_HANDLE_CREATED       or WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING;
  WINHTTP_CALLBACK_FLAG_DETECTING_PROXY           = WINHTTP_CALLBACK_STATUS_DETECTING_PROXY;
  WINHTTP_CALLBACK_FLAG_REDIRECT                  = WINHTTP_CALLBACK_STATUS_REDIRECT;
  WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE     = WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE;
  WINHTTP_CALLBACK_FLAG_SECURE_FAILURE            = WINHTTP_CALLBACK_STATUS_SECURE_FAILURE;
  WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE      = WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE;
  WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE         = WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE;
  WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE            = WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE;
  WINHTTP_CALLBACK_FLAG_READ_COMPLETE             = WINHTTP_CALLBACK_STATUS_READ_COMPLETE;
  WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE            = WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE;
  WINHTTP_CALLBACK_FLAG_REQUEST_ERROR             = WINHTTP_CALLBACK_STATUS_REQUEST_ERROR;
  WINHTTP_CALLBACK_FLAG_GETPROXYFORURL_COMPLETE   = WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE;

  WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS           = WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE or
                                                    WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE or
                                                    WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE or
                                                    WINHTTP_CALLBACK_STATUS_READ_COMPLETE or
                                                    WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE or
                                                    WINHTTP_CALLBACK_STATUS_REQUEST_ERROR or
                                                    WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE;
  WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS         = $FFFFFFFF;

  // if the following value is returned by WinHttpSetStatusCallback, then
  // probably an invalid (non-code) address was supplied for the callback

  WINHTTP_INVALID_STATUS_CALLBACK = -1;

  // options manifests for WinHttp{Query|Set}Option

  WINHTTP_OPTION_SECURITY_FLAGS = 31;

  // Комбинации флагов для WINHTTP_OPTION_SECURITY_FLAGS

  SECURITY_FLAG_IGNORE_UNKNOWN_CA         = $00000100;
  SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE   = $00000200;
  SECURITY_FLAG_IGNORE_CERT_CN_INVALID    = $00001000; // bad common name in X509 Cert.
  SECURITY_FLAG_IGNORE_CERT_DATE_INVALID  = $00002000; // expired X509 Cert.
  SECURITY_FLAG_SECURE                    = $00000001; // только для WinHttpQueryOption
  SECURITY_FLAG_STRENGTH_WEAK             = $10000000; // только для WinHttpQueryOption
  SECURITY_FLAG_STRENGTH_MEDIUM           = $40000000; // только для WinHttpQueryOption
  SECURITY_FLAG_STRENGTH_STRONG           = $20000000; // только для WinHttpQueryOption

type

  // Типы

  HINTERNET     = type LPVOID;
  INTERNET_PORT = type Word;

  // Callback структуры для WinHttpSetStatusCallback

  LPWINHTTP_STATUS_CALLBACK = ^WINHTTP_STATUS_CALLBACK;
  WINHTTP_STATUS_CALLBACK = procedure (hInternet: HINTERNET; dwContext: DWORD_PTR; dwInternetStatus: DWORD;
    lpvStatusInformation: LPVOID; dwStatusInformationLength: DWORD); stdcall;

  // Блок объявления функций

  function WinHttpCloseHandle(hInternet: HINTERNET): BOOL; stdcall;

  function WinHttpConnect(hSession: HINTERNET; pswzServerName: LPCWSTR; nServerPort: INTERNET_PORT;
    dwReserved: DWORD): HINTERNET; stdcall;

  function WinHttpOpen(pwszUserAgent: LPCWSTR; dwAccessType: DWORD; pwszProxyName, pwszProxyBypass: LPCWSTR;
    dwFlags: DWORD): HINTERNET; stdcall;

  function WinHttpOpenRequest(hConnect: HINTERNET; pwszVerb, pwszObjectName, pwszVersion, pwszReferrer: LPCWSTR;
    ppwszAcceptTypes: PLPWSTR; dwFlags: DWORD): HINTERNET; stdcall;

  function WinHttpQueryDataAvailable(hRequest: HINTERNET; lpdwNumberOfBytesAvailable: LPDWORD): BOOL; stdcall;

  function WinHttpReadData(hRequest: HINTERNET; lpBuffer: LPVOID; dwNumberOfBytesToRead: DWORD;
    lpdwNumberOfBytesRead: LPDWORD): BOOL; stdcall;

  function WinHttpReceiveResponse(hRequest: HINTERNET; lpReserved: LPVOID): BOOL; stdcall;

  function WinHttpSendRequest(hRequest: HINTERNET; pwszHeaders: LPCWSTR; dwHeadersLength: DWORD; lpOptional: LPVOID;
    dwOptionalLength, dwTotalLength, dwContext: DWORD): BOOL; stdcall;

  function WinHttpSetOption(hInternet: HINTERNET; dwOption: DWORD; lpBuffer: LPVOID;
    dwBufferLength: DWORD): BOOL; stdcall;

  function WinHttpSetStatusCallback(hInternet: HINTERNET; lpfnInternetCallback: LPWINHTTP_STATUS_CALLBACK;
    dwNotificationFlags: DWORD; dwReserved: DWORD_PTR): LPWINHTTP_STATUS_CALLBACK; stdcall;

implementation

  function WinHttpCloseHandle; external WINHTTP name 'WinHttpCloseHandle';
  function WinHttpConnect; external WINHTTP name 'WinHttpConnect';
  function WinHttpOpen; external WINHTTP name 'WinHttpOpen';
  function WinHttpOpenRequest; external WINHTTP name 'WinHttpOpenRequest';
  function WinHttpQueryDataAvailable; external WINHTTP name 'WinHttpQueryDataAvailable';
  function WinHttpReadData; external WINHTTP name 'WinHttpReadData';
  function WinHttpReceiveResponse; external WINHTTP name 'WinHttpReceiveResponse';
  function WinHttpSendRequest; external WINHTTP name 'WinHttpSendRequest';
  function WinHttpSetOption; external WINHTTP name 'WinHttpSetOption';
  function WinHttpSetStatusCallback; external WINHTTP name 'WinHttpSetStatusCallback';

end.
