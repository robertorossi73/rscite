
#include "cprops.h"

bool clPropsDialog::openMenu(HWND parentHwnd, const std::wstring& path, int xPos, int yPos)
{
    ITEMIDLIST* id = 0;
    std::wstring windowsPath = path;
    HRESULT result = 0;
    IShellFolder* ifolder = 0;
    LPCITEMIDLIST idChild = 0;
    IContextMenu* imenu = 0;
    HMENU hMenu = 0;
    int iCmd = 0;

    result = SHParseDisplayName(windowsPath.c_str(), 0, &id, 0, 0);
    if (!SUCCEEDED(result) || !id)
        return false;
    CItemIdListManager idReleaser(id);

    result = SHBindToParent(id, IID_IShellFolder, (void**)&ifolder, &idChild);
    if (!SUCCEEDED(result) || !ifolder)
        return false;
    CComInterfaceManager ifolderReleaser(ifolder);

    result = ifolder->GetUIObjectOf(parentHwnd, 1, (const ITEMIDLIST**)&idChild, IID_IContextMenu, 0, (void**)&imenu);
    if (!SUCCEEDED(result) || !ifolder)
        return false;
    CComInterfaceManager menuReleaser(imenu);

    hMenu = CreatePopupMenu();
    if (!hMenu)
        return false;
    if (SUCCEEDED(imenu->QueryContextMenu(hMenu, 0, 1, 0x7FFF, CMF_NORMAL)))
    {
        iCmd = TrackPopupMenuEx(hMenu, TPM_RETURNCMD, xPos, yPos, parentHwnd, NULL);
        if (iCmd > 0)
        {
            CMINVOKECOMMANDINFOEX info = { 0 };
            info.cbSize = sizeof(info);
            info.fMask = 0x00004000; // CMIC_MASK_UNICODE;
            info.hwnd = parentHwnd;
            info.lpVerb = MAKEINTRESOURCEA(iCmd - 1);
            info.lpVerbW = MAKEINTRESOURCEW(iCmd - 1);
            info.nShow = SW_SHOWNORMAL;
            imenu->InvokeCommand((LPCMINVOKECOMMANDINFO)&info);
        }

    }
    DestroyMenu(hMenu);

    return true;
}



