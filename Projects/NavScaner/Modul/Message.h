#pragma once

class CMessage
{
public:
	CMessage(void);
	~CMessage(void);
	virtual void AddClient(LPARAM lParam);
};
