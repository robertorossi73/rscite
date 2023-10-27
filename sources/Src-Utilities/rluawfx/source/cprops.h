
#include <string>
#include <ShlObj.h>

class clPropsDialog
{
private:

    class CItemIdListManager {
    private:
        ITEMIDLIST* iList;
    public:
        explicit CItemIdListManager(ITEMIDLIST* listID) : iList(listID)
        {}

        ~CItemIdListManager()
        { 
            if (iList) 
                CoTaskMemFree(iList); 
        }
    };

    class CComInterfaceManager {
    private:
        IUnknown* i;
    public:
        explicit CComInterfaceManager(IUnknown* iU) : i(iU)
        {}

        ~CComInterfaceManager()
        { 
            if (i) 
                i->Release(); 
        }
    };

public:
    
    bool openMenu(HWND parentHwnd, const std::wstring& path, int xPos, int yPos);
};
