// EI_PricesDlg.h : header file
//

#pragma once
#include "afxwin.h"



// CEI_PricesDlg dialog
class CEI_PricesDlg : public CDialog
{
// Construction
public:
	CEI_PricesDlg(CWnd* pParent = NULL);	// standard constructor
	
	long lID_Client;
	CString sName;
	CString sFrom;
	CString sERROR_MAIL;
	long lEXPORT_TYPE;
	long lEXPORT_FILE_TYPE;
	CString sSubject;
	CString sPRICE_FILE;
	CString sCodeProgramm;
	CString sAttach;
	CString sArchiv;

	int iTypeOrder;
	int iCurrency;
	int iDelivery;
	int iImportTypeFile;
	int iNavTypeFile;

	int iFirstString;
	int iColBrand;
	int iColNumber;
	int iColQuant;
	int iColPrice;
	int iColBasePrice;
	CString sOrderTO;
	CString sFromExport;
	CString sDog;
	CString sDelCode;
	
// Dialog Data
	enum { IDD = IDD_EI_PRICES_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;
	CDatabase* dBase;
	int iStyle;
	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()

	virtual void OnOK();
public:
	CComboBox m_ComboClients;
	void CloseDatabase(void);
	afx_msg void OnClose();
	BOOL OpenDataBase(CString * sError);
	void LoadComboClient(void);
	afx_msg void OnCbnSelchangeComboClients();
	CEdit m_EdName;
	CEdit m_EdFrom;
	CEdit m_EdSubject;
	CEdit m_EdErrorMail;
	CComboBox m_ComboFormats;
	void LoadFormats(void);
	CComboBox m_ComboTypeExport;
	CEdit m_EdCodeProgramm;
	
	CComboBox m_ComboTypeOrder;
	CComboBox m_ComboCyrrency;
	CComboBox m_ComboDelivery;
	CEdit m_EdDate;
	CComboBox m_ComboTypeFileImport;
	CEdit m_EdFirstString;
	CEdit m_EdColBrand;
	CEdit m_edColNumber;
	CEdit m_EdColQuant;
	CEdit m_edOrderTo;
	afx_msg void OnBnClickedButtonLoadFile();
	BOOL Import_XLS(CString sFileName, long lRandom, CStdioFile *File, bool aShowMail);
	BOOL Import_XLS_Vendors(CString sFileName, CString sFileOUT);
	BOOL GetOurBrand(CString * sBrand);
	BOOL GetOurCode(CString* sBrand, CString* sCode);
	BOOL SaveDate(void);
	
	afx_msg void OnStnDblclickStaticMailsClint();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	CEdit m_EdMails;
	afx_msg void OnBnClickedButtonNewClient();
	afx_msg void OnBnClickedButtonBrands();
	afx_msg void OnBnClickedButtonAnalogs();
	afx_msg void OnBnClickedButtonReplace();
	CString GetFormatedBrand_Code(CString sCode);
	afx_msg void OnBnClickedButtonAddAnalogs();
	CButton m_ButtonLoad;
	CEdit m_EdFromExport;
	CEdit m_EdDog;
	CEdit m_EdDelCode;
	void LoadClientData(long lData);
	CButton m_btShowBreand;
	CButton m_btAnalogs_Export;
	CButton m_btAnalogsReplace;
	CButton m_btAnalogsAdd;
	CStatic m_PanelReplace;
	CEdit m_EdFileImport;
	CEdit m_EdAttachFile;
	CButton m_btZip;
	CComboBox m_ComboNavTypeFile;
	void CreateServiseProgFile(CString sFile, int iType, bool isMail, bool aShowMail);
	void CreateServiseVendorFile(CString sFile, int iType);
	void ExecuteRun(bool isMail, bool aShowMail);
	int GetItemPrice(char* aItemNo2, char* aTMName, char* aServiceProgUsrID, char* aAgreementNo, char* aCurrCode, char *aNavPrice, char *aErr);
	int GetPriceRatio(char* aValue1, char* aValue2, char *aPriceRatio, char *aErr);
	afx_msg void OnBnClickedButtonView();
	CEdit m_EdColPrice;
	CEdit m_EdColBasePrice;
	afx_msg void OnBnClickedButtonManualLoadfile();
};
