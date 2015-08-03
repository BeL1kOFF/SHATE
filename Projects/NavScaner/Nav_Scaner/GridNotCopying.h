#pragma once
#include "grid\gridctrl.h"
#include "grid\MemDC.h"

class CGridNotCopying :
	public CGridCtrl
{
private:
	bool bCanReDraw;	

public:
	CGridNotCopying(void);
	~CGridNotCopying(void);
	DECLARE_MESSAGE_MAP()

protected:
	afx_msg void OnPaint();
public:
	int iBarCodeColumn;
	void SetCanreDraw(bool bReDraw);
	void SelectRow(long iRow);
};
