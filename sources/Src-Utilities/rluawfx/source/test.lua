--# -*- coding: utf-8 -*-

do
  require("luascr/rluawfx")

--print(rwfx_fileOperation("c:\\Temp\\unicode\\ci®Ωo.txt","c:\\Temp\\scite\\Src-Utilities\\rluawfx\\source\\test_ci®Ωo.txt", "copy", 0))



local nomeFile = ""
nomeFile = rwfx_BrowseForFolder("test",rfx_FN())    
--nomeFile = rwfx_GetFileName("test","", OFN_FILEMUSTEXIST,rfx_FN())
nomeFile = rfx_GF()      
print(nomeFile)
    editor:ReplaceSel(nomeFile)

end 









-- da testare:

-- browseforfolder
-- getfilename
-- 
-- 
-- 
-- 
-- 
-- 
-- 