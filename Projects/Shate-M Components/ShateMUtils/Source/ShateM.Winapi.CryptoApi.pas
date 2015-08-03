unit ShateM.Winapi.CryptoApi;

interface

uses
  Winapi.Windows;

const
  ADVAPI32 = 'advapi32.dll';

const
  // Cryptographic Provider Types

  PROV_RSA_FULL           = 1;
  PROV_RSA_SIG            = 2;
  PROV_DSS                = 3;
  PROV_FORTEZZA           = 4;
  PROV_MS_EXCHANGE        = 5;
  PROV_SSL                = 6;
  PROV_STT_MER            = 7;
  PROV_STT_ACQ            = 8;
  PROV_STT_BRND           = 9;
  PROV_STT_ROOT           = 10;
  PROV_STT_ISS            = 11;
  PROV_RSA_SCHANNEL       = 12;
  PROV_DSS_DH             = 13;
  PROV_EC_ECDSA_SIG       = 14;
  PROV_EC_ECNRA_SIG       = 15;
  PROV_EC_ECDSA_FULL      = 16;
  PROV_EC_ECNRA_FULL      = 17;
  PROV_DH_SCHANNEL        = 18;
  PROV_SPYRUS_LYNKS       = 20;
  PROV_RNG                = 21;
  PROV_INTEL_SEC          = 22;
  PROV_REPLACE_OWF        = 23;
  PROV_RSA_AES            = 24;

  // dwFlags definitions for CryptAcquireContext

  CRYPT_VERIFYCONTEXT              = $F0000000;
  CRYPT_NEWKEYSET                  = $00000008;
  CRYPT_DELETEKEYSET               = $00000010;
  CRYPT_MACHINE_KEYSET             = $00000020;
  CRYPT_SILENT                     = $00000040;
  CRYPT_DEFAULT_CONTAINER_OPTIONAL = $00000080;

  // Algorithm classes

  ALG_CLASS_ANY                   = 0;
  ALG_CLASS_SIGNATURE             = 1 shl 13;
  ALG_CLASS_MSG_ENCRYPT           = 2 shl 13;
  ALG_CLASS_DATA_ENCRYPT          = 3 shl 13;
  ALG_CLASS_HASH                  = 4 shl 13;
  ALG_CLASS_KEY_EXCHANGE          = 5 shl 13;
  ALG_CLASS_ALL                   = 7 shl 13;

  // Algorithm types

  ALG_TYPE_ANY                    = 0;
  ALG_TYPE_DSS                    = 1 shl 9;
  ALG_TYPE_RSA                    = 2 shl 9;
  ALG_TYPE_BLOCK                  = 3 shl 9;
  ALG_TYPE_STREAM                 = 4 shl 9;
  ALG_TYPE_DH                     = 5 shl 9;
  ALG_TYPE_SECURECHANNEL          = 6 shl 9;

  // Hash sub ids

  ALG_SID_MD2                     = 1;
  ALG_SID_MD4                     = 2;
  ALG_SID_MD5                     = 3;
  ALG_SID_SHA                     = 4;
  ALG_SID_SHA1                    = 4;
  ALG_SID_MAC                     = 5;
  ALG_SID_RIPEMD                  = 6;
  ALG_SID_RIPEMD160               = 7;
  ALG_SID_SSL3SHAMD5              = 8;
  ALG_SID_HMAC                    = 9;
  ALG_SID_TLS1PRF                 = 10;
  ALG_SID_HASH_REPLACE_OWF        = 11;
  ALG_SID_SHA_256                 = 12;
  ALG_SID_SHA_384                 = 13;
  ALG_SID_SHA_512                 = 14;

  // Generic sub-ids

  ALG_SID_ANY                     = 0;

  // Some RSA sub-ids

  ALG_SID_RSA_ANY                 = 0;
  ALG_SID_RSA_PKCS                = 1;
  ALG_SID_RSA_MSATWORK            = 2;
  ALG_SID_RSA_ENTRUST             = 3;
  ALG_SID_RSA_PGP                 = 4;

  // Some DSS sub-ids

  ALG_SID_DSS_ANY                 = 0;
  ALG_SID_DSS_PKCS                = 1;
  ALG_SID_DSS_DMS                 = 2;
  ALG_SID_ECDSA                   = 3;

  // Diffie-Hellman sub-ids

  ALG_SID_DH_SANDF                = 1;
  ALG_SID_DH_EPHEM                = 2;
  ALG_SID_AGREED_KEY_ANY          = 3;
  ALG_SID_KEA                     = 4;
  ALG_SID_ECDH                    = 5;

  // misc ECC sub ids

  ALG_SID_ECMQV                   = 1;

  // Stream cipher sub-ids

  ALG_SID_RC4                     = 1;
  ALG_SID_SEAL                    = 2;

  // secure channel sub ids

  ALG_SID_SSL3_MASTER             = 1;
  ALG_SID_SCHANNEL_MASTER_HASH    = 2;
  ALG_SID_SCHANNEL_MAC_KEY        = 3;
  ALG_SID_PCT1_MASTER             = 4;
  ALG_SID_SSL2_MASTER             = 5;
  ALG_SID_TLS1_MASTER             = 6;
  ALG_SID_SCHANNEL_ENC_KEY        = 7;

  // DES sub_ids

  ALG_SID_DES                     = 1;
  ALG_SID_RC2                     = 2;
  ALG_SID_3DES                    = 3;
  ALG_SID_DESX                    = 4;
  ALG_SID_IDEA                    = 5;
  ALG_SID_CAST                    = 6;
  ALG_SID_SAFERSK64               = 7;
  ALG_SID_SAFERSK128              = 8;
  ALG_SID_3DES_112                = 9;
  ALG_SID_SKIPJACK                = 10;
  ALG_SID_TEK                     = 11;
  ALG_SID_CYLINK_MEK              = 12;
  ALG_SID_RC5                     = 13;
  ALG_SID_AES_128                 = 14;
  ALG_SID_AES_192                 = 15;
  ALG_SID_AES_256                 = 16;
  ALG_SID_AES                     = 17;

  // algorithm identifier definitions

  CALG_MD2                = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD2;
  CALG_MD4                = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD4;
  CALG_MD5                = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5;
  CALG_SHA                = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA;
  CALG_SHA1               = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA1;
  CALG_MAC                = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MAC;
  CALG_SSL3_SHAMD5        = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SSL3SHAMD5;
  CALG_HMAC               = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HMAC;
  CALG_TLS1PRF            = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_TLS1PRF;
  CALG_HASH_REPLACE_OWF   = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HASH_REPLACE_OWF;
  CALG_SHA_256            = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_256;
  CALG_SHA_384            = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_384;
  CALG_SHA_512            = ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA_512;

  CALG_RSA_SIGN           = ALG_CLASS_SIGNATURE or ALG_TYPE_RSA or ALG_SID_RSA_ANY;
  CALG_DSS_SIGN           = ALG_CLASS_SIGNATURE or ALG_TYPE_DSS or ALG_SID_DSS_ANY;
  CALG_ECDSA              = ALG_CLASS_SIGNATURE or ALG_TYPE_DSS or ALG_SID_ECDSA;
  CALG_NO_SIGN            = ALG_CLASS_SIGNATURE or ALG_TYPE_ANY or ALG_SID_ANY;

  CALG_RSA_KEYX           = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_RSA or ALG_SID_RSA_ANY;
  CALG_DH_SF              = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_SANDF;
  CALG_DH_EPHEM           = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_EPHEM;
  CALG_AGREEDKEY_ANY      = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_AGREED_KEY_ANY;
  CALG_KEA_KEYX           = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_KEA;
  CALG_ECDH               = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_ECDH;
  CALG_HUGHES_MD5         = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_ANY or ALG_SID_MD5;
  CALG_ECMQV              = ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_ANY or ALG_SID_ECMQV;

  CALG_DES                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_DES;
  CALG_3DES_112           = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_3DES_112;
  CALG_3DES               = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_3DES;
  CALG_DESX               = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_DESX;
  CALG_RC2                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_RC2;
  CALG_SKIPJACK           = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_SKIPJACK;
  CALG_TEK                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_TEK;
  CALG_CYLINK_MEK         = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_CYLINK_MEK;
  CALG_RC5                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_RC5;
  CALG_AES_128            = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_128;
  CALG_AES_192            = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_192;
  CALG_AES_256            = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES_256;
  CALG_AES                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_AES;
  CALG_RC4                = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_RC4;
  CALG_SEAL               = ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_SEAL;

  CALG_SSL3_MASTER          = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_SSL3_MASTER;
  CALG_SCHANNEL_MASTER_HASH = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_SCHANNEL_MASTER_HASH;
  CALG_SCHANNEL_MAC_KEY     = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_SCHANNEL_MAC_KEY;
  CALG_SCHANNEL_ENC_KEY     = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_SCHANNEL_ENC_KEY;
  CALG_PCT1_MASTER          = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_PCT1_MASTER;
  CALG_SSL2_MASTER          = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_SSL2_MASTER;
  CALG_TLS1_MASTER          = ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or ALG_SID_TLS1_MASTER;

  //Special ALG_ID's used in CRYPT_OID_INFO

  CALG_OID_INFO_CNG_ONLY    = $FFFFFFFF;
  CALG_OID_INFO_PARAMETERS  = $FFFFFFFE;

  // dwFlags definitions for CryptCreateHash

  CRYPT_SECRETDIGEST      = $00000001;

  // dwFlags definitions for CryptHashData

  CRYPT_OWF_REPL_LM_HASH  = $00000001;  // this is only for the OWF replacement CSP
  CRYPT_USERDATA          = 1;

  // dwParam definitions for CryptGetHashParam

  HP_ALGID                = $0001;  // Hash algorithm
  HP_HASHVAL              = $0002;  // Hash value
  HP_HASHSIZE             = $0004;  // Hash value size

  // algorithm identifier definitions

  AT_KEYEXCHANGE          = 1;
  AT_SIGNATURE            = 2;

  // dwFlag definitions for CryptGenKey
  CRYPT_EXPORTABLE                = $00000001;
  CRYPT_USER_PROTECTED            = $00000002;
  CRYPT_CREATE_SALT               = $00000004;
  CRYPT_UPDATE_KEY                = $00000008;
  CRYPT_NO_SALT                   = $00000010;
  CRYPT_PREGEN                    = $00000040;
  CRYPT_RECIPIENT                 = $00000010;
  CRYPT_INITIATOR                 = $00000040;
  CRYPT_ONLINE                    = $00000080;
  CRYPT_SF                        = $00000100;
  CRYPT_CREATE_IV                 = $00000200;
  CRYPT_KEK                       = $00000400;
  CRYPT_DATA_KEY                  = $00000800;
  CRYPT_VOLATILE                  = $00001000;
  CRYPT_SGCKEY                    = $00002000;
  CRYPT_ARCHIVABLE                = $00004000;
  CRYPT_FORCE_KEY_PROTECTION_HIGH = $00008000;

type
  // Типы

  PHCRYPTPROV = ^HCRYPTPROV;
  HCRYPTPROV  = type ULONG_PTR;

  ALG_ID      = type UINT;

  PHCRYPTKEY  = ^HCRYPTKEY;
  HCRYPTKEY   = type ULONG_PTR;

  PHCRYPTHASH = ^HCRYPTHASH;
  HCRYPTHASH  = type ULONG_PTR;

  // Блок объявления функций

  // Service Provider Functions

  function CryptAcquireContext(phProv: PHCRYPTPROV; pszContainer, pszProvider: LPCTSTR; dwProvType, dwFlags: DWORD): BOOL; stdcall;
  function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall;

  // Key Generation and Exchange Functions

  function CryptGenKey(hProv: HCRYPTPROV; Algid: ALG_ID; dwFlags: DWORD; phKey: PHCRYPTKEY): BOOL; stdcall;

  // Hash and Digital Signature Functions

  function CryptCreateHash(hProv: HCRYPTPROV; Algid: ALG_ID; hKey: HCRYPTKEY; dwFlags: DWORD; phHash: PHCRYPTHASH): BOOL; stdcall;
  function CryptDestroyHash(hHash: HCRYPTHASH): BOOL; stdcall;
  function CryptGetHashParam(hHash: HCRYPTHASH; dwParam: DWORD; pbData: PByte; pdwDataLen: PDWORD; dwFlags: DWORD): BOOL; stdcall;
  function CryptHashData(hHash: HCRYPTHASH; pbData: PByte; dwDataLen, dwFlags: DWORD): BOOL; stdcall;

implementation

  function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextW';
  function CryptCreateHash; external ADVAPI32 name 'CryptCreateHash';
  function CryptHashData; external ADVAPI32 name 'CryptHashData';
  function CryptGetHashParam; external ADVAPI32 name 'CryptGetHashParam';
  function CryptDestroyHash; external ADVAPI32 name 'CryptDestroyHash';
  function CryptReleaseContext; external ADVAPI32 name 'CryptReleaseContext';
  function CryptGenKey; external ADVAPI32 name 'CryptGenKey';

end.
