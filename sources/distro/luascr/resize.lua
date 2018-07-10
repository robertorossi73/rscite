--[[
Author  : Roberto Rossi
Version : 1.0.0
Web     : http://www.redchar.net

Questo modulo consente di ridimensionare la finestra corrente ad una dimensione
precisa, scelta da una risoluzione predefinita oppure inserita dall'utente.

Definizioni delle risoluzioni:
https://en.wikipedia.org/wiki/Graphics_display_resolution

Copyright (C) 2017-2018 Roberto Rossi 
*******************************************************************************
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
*******************************************************************************
]]

do
    require("luascr/rluawfx")
    
    --Variabile Globale per dati
    if (G_resize_lua_Last_Value == nil) then
        G_resize_lua_Last_Value = ""
    end
    
    --ritorna una tabella con due elementi {larghezza, altezza}, data una
    -- stringa di dati
    local function resize_lua_extractXY( str )
        local result = {}
        local strTmp
        local pos
        local posX
        local x
        local y
        
        pos = string.find(str, "(", 1, true)
        if (pos) then
            strTmp = string.sub(str, 1, pos-1)
        else
            strTmp = str
        end
        
        strTmp = rfx_Trim(strTmp)
        strTmp = string.lower(strTmp)
        posX = string.find(str, "x", 1, true)
        if (posX) then
           x = string.sub(strTmp,1, posX-1) 
           y = string.sub(strTmp,posX+1)
           result = {tonumber(x),tonumber(y)}
        end
        return result
    end
    
    function buttonOk_click(control, change)
        local value = ""
        local xy = {}
        
        value = wcl_strip:getValue("ITEMVALUES")
        xy = resize_lua_extractXY(value)
        
        if (#xy == 2) then
            if (xy[1] and xy[2]) then
                rwfx_SetWindowSize(xy[1], xy[2])
                G_resize_lua_Last_Value = tostring(xy[1]).."x"..tostring(xy[2])
            else
                print("Size Window Error 1!")
            end
        else
            print("Size Window Error 2!")
        end
        wcl_strip:close()
    end
    
    function buttonCancel_click(control, change)
        wcl_strip:close()
    end
    
    function buttonTemplate_click(control, change)
        local result = false
        local scelta = false
        local item
        local dataSizeStr = ""
        local i
        local v
        
          --[[  

        Tabelle risoluzione tratte da Wikipedia
        Le tabelle sono formate da 4 o 5 elemnti separati da tabulazioni
        La linea dopo il titolo (senza tabs) viene ignorata
          
***  High-definition Name
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  nHD 	640 	360 	16:9 	0.230
***  qHD 	960 	540 	16:9 	0.518
***  HD 	1280 	720 	16:9 	0.922
***  HD+ 	1600 	900 	16:9 	1.440
***  FHD 	1920 	1080 	16:9 	2.074
***  (W)QHD 	2560 	1440 	16:9 	3.686
***  QHD+ 	3200 	1800 	16:9 	5.760
***  4K UHD 	3840 	2160 	16:9 	8.294
***  5K UHD+ 	5120 	2880 	16:9 	14.746
***  8K UHD 	7680 	4320 	16:9 	33.178
***  Video Graphics Array Name
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  QQVGA 	160 	120 	4:3 	0.019
***  HQVGA 	240 	160 	3:2 	0.038
***  	256 	160 	16:10 	0.043
***  QVGA 	320 	240 	4:3 	0.077
***  WQVGA 	384 	240 	16:10 	0.092
***  WQVGA 	360 	240 	3:2 	0.086
***  WQVGA 	400 	240 	5:3 	0.096
***  HVGA 	480 	320 	3:2 	0.154
***  VGA 	640 	480 	4:3 	0.307
***  WVGA 	768 	480 	16:10 	0.368
***  WVGA 	720 	480 	3:2 	0.345
***  WVGA 	800 	480 	5:3 	0.384
***  FWVGA 	˜854 	480 	16:9 	0.410
***  SVGA 	800 	600 	4:3 	0.480
***  DVGA 	960 	640 	3:2 	0.614
***  WSVGA 	1024 	576 	16:9 	0.590
***  WSVGA 	1024 	600 	128:75 	0.614          
***  Variants of WQVGA
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  360 	240 	15:10 	0.086
***  376 	240 	4.7:3 	0.0902
***  384 	240 	16:10 	0.0922
***  400 	240 	15:9 	0.0960
***  428 	240 	16:9 	0.103
***  432 	240 	16:9 	0.104
***  480 	270 	16:9 	0.130
***  480 	272 	16:9 	0.131
***  Variants of HVGA
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  480 	270 	16:9 	0.1296
***  480 	272 	16:9 	0.1306
***  480 	320 	3:2 	0.1536
***  640 	240 	8:3 	0.1536
***  480 	360 	4:3 	0.1728
***  Variants of WVGA
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  640 	360 	16:9 	0.230
***  640 	384 	15:9 	0.246
***  720 	480 	15:10 	0.346
***  768 	480 	16:10 	0.369
***  800 	450 	16:9 	0.360
***  800 	480 	15:9 	0.384
***  848 	480 	16:9 	0.407
***  852 	480 	16:9 	0.409
***  853 	480 	16:9 	0.409
***  854 	480 	16:9 	0.410
***  Extended Graphics Array
***  Name 	H (px) 	V (px) 	H:V 	H × V (Mpx)
***  XGA 	1024 	768 	4:3 	0.786
***  WXGA 	1152 	768 	3:2 	0.884
***  WXGA 	1280 	768 	5:3 	0.983
***  WXGA 	1280 	800 	16:10 	1.024
***  WXGA 	1360 	768 	˜16:9 	1.044
***  FWXGA 	1366 	768 	˜16:9 	1.049
***  XGA+ 	1152 	864 	4:3 	0.995
***  WXGA+ 	1440 	900 	16:10 	1.296
***  WSXGA 	1440 	960 	3:2 	1.382
***  SXGA 	1280 	1024 	5:4 	1.310
***  SXGA+ 	1400 	1050 	4:3 	1.470
***  WSXGA+ 	1680 	1050 	16:10 	1.764
***  UXGA 	1600 	1200 	4:3 	1.920
***  WUXGA 	1920 	1200 	16:10 	2.304
***  Variants of WXGA
***  H (px) 	V (px) 	H:V 	H × V (Mpx)
***  1152 	768 	15:10 	0.884
***  1280 	720 	16:9 	0.922
***  1280 	768 	15:9 	0.983
***  1280 	800 	16:10 	1.024
***  1344 	768 	7:4 	1.032
***  1360 	768 	16:9 	1.044
***  1366 	768 	16:9 	1.049
***  Variants of XGA+
***  Origin	H (px) 	V (px) 	H:V 	H × V (Mpx)
***  SVGA	1152 	864 	4:3 	0.995
***  Sun	1152 	900 	1.28:1 	1.037
***  Apple	1152 	870 	˜1.32:1 	1.002
***  NeXT	1120 	832 	˜11:8 	0.932
***  Quad Extended Graphics Array
***  Name 	H (px) 	V (px) 	H:V 	H × V (Mpx)
***  QWXGA 	2048 	1152 	16:9 	2.359
***  QXGA 	2048 	1536 	4:3 	3.145
***  WQXGA 	2560 	1600 	16:10 	4.096
***  	2880 	1800 	16:10 	5.184
***  QSXGA 	2560 	2048 	5:4 	5.242
***  WQSXGA 	3200 	2048 	25:16 	6.553
***  QUXGA 	3200 	2400 	4:3 	7.680
***  WQUXGA 	3840 	2400 	16:10 	9.216
***  Hyper Extended Graphics Array
***  Name 	H (px) 	V (px) 	H:V 	H × V (Mpx)
***  HXGA 	4096 	3072 	4:3 	12.582
***  WHXGA 	5120 	3200 	16:10 	16.384
***  HSXGA 	5120 	4096 	5:4 	20.971
***  WHSXGA 	6400 	4096 	25:16 	26.214
***  HUXGA 	6400 	4800 	4:3 	30.720
***  WHUXGA 	7680 	4800 	16:10 	36.864

]]

        --ogni dimnsione ha questo formato:
        -- [x]X[y] [descrizione racchiusa tra parentesi tonde]
        -- es.: 2048x1152 (Quad Extended Graphics Array, QWXGA, 16:9, 2.359Mpx)
        --
        local dataSize = {
                    "640 x 360 (High-definition Name,nHD ,16:9 ,0.230 Mpx)",
                    "960 x 540 (High-definition Name,qHD ,16:9 ,0.518 Mpx)",
                    "1280 x 720 (High-definition Name,HD ,16:9 ,0.922 Mpx)",
                    "1600 x 900 (High-definition Name,HD+ ,16:9 ,1.440 Mpx)",
                    "1920 x 1080 (High-definition Name,FHD ,16:9 ,2.074 Mpx)",
                    "2560 x 1440 (High-definition Name,(W)QHD ,16:9 ,3.686 Mpx)",
                    "3200 x 1800 (High-definition Name,QHD+ ,16:9 ,5.760 Mpx)",
                    "3840 x 2160 (High-definition Name,4K UHD ,16:9 ,8.294 Mpx)",
                    "5120 x 2880 (High-definition Name,5K UHD+ ,16:9 ,14.746 Mpx)",
                    "7680 x 4320 (High-definition Name,8K UHD ,16:9 ,33.178 Mpx)",
                    "160 x 120 (Video Graphics Array Name,QQVGA ,4:3 ,0.019 Mpx)",
                    "240 x 160 (Video Graphics Array Name,HQVGA ,3:2 ,0.038 Mpx)",
                    "256 x 160 (Video Graphics Array Name,,16:10 ,0.043 Mpx)",
                    "320 x 240 (Video Graphics Array Name,QVGA ,4:3 ,0.077 Mpx)",
                    "384 x 240 (Video Graphics Array Name,WQVGA ,16:10 ,0.092 Mpx)",
                    "360 x 240 (Video Graphics Array Name,WQVGA ,3:2 ,0.086 Mpx)",
                    "400 x 240 (Video Graphics Array Name,WQVGA ,5:3 ,0.096 Mpx)",
                    "480 x 320 (Video Graphics Array Name,HVGA ,3:2 ,0.154 Mpx)",
                    "640 x 480 (Video Graphics Array Name,VGA ,4:3 ,0.307 Mpx)",
                    "768 x 480 (Video Graphics Array Name,WVGA ,16:10 ,0.368 Mpx)",
                    "720 x 480 (Video Graphics Array Name,WVGA ,3:2 ,0.345 Mpx)",
                    "800 x 480 (Video Graphics Array Name,WVGA ,5:3 ,0.384 Mpx)",
                    "˜854 x 480 (Video Graphics Array Name,FWVGA ,16:9 ,0.410 Mpx)",
                    "800 x 600 (Video Graphics Array Name,SVGA ,4:3 ,0.480 Mpx)",
                    "960 x 640 (Video Graphics Array Name,DVGA ,3:2 ,0.614 Mpx)",
                    "1024 x 576 (Video Graphics Array Name,WSVGA ,16:9 ,0.590 Mpx)",
                    "1024 x 600 (Video Graphics Array Name,WSVGA ,128:75 ,0.614 Mpx)",
                    "240 x 15:10 (Variants of WQVGA,15:10 ,0.086 Mpx)",
                    "240 x 4.7:3 (Variants of WQVGA,4.7:3 ,0.0902 Mpx)",
                    "240 x 16:10 (Variants of WQVGA,16:10 ,0.0922 Mpx)",
                    "240 x 15:9 (Variants of WQVGA,15:9 ,0.0960 Mpx)",
                    "240 x 16:9 (Variants of WQVGA,16:9 ,0.103 Mpx)",
                    "240 x 16:9 (Variants of WQVGA,16:9 ,0.104 Mpx)",
                    "270 x 16:9 (Variants of WQVGA,16:9 ,0.130 Mpx)",
                    "272 x 16:9 (Variants of WQVGA,16:9 ,0.131 Mpx)",
                    "270 x 16:9 (Variants of HVGA,16:9 ,0.1296 Mpx)",
                    "272 x 16:9 (Variants of HVGA,16:9 ,0.1306 Mpx)",
                    "320 x 3:2 (Variants of HVGA,3:2 ,0.1536 Mpx)",
                    "240 x 8:3 (Variants of HVGA,8:3 ,0.1536 Mpx)",
                    "360 x 4:3 (Variants of HVGA,4:3 ,0.1728 Mpx)",
                    "360 x 16:9 (Variants of WVGA,16:9 ,0.230 Mpx)",
                    "384 x 15:9 (Variants of WVGA,15:9 ,0.246 Mpx)",
                    "480 x 15:10 (Variants of WVGA,15:10 ,0.346 Mpx)",
                    "480 x 16:10 (Variants of WVGA,16:10 ,0.369 Mpx)",
                    "450 x 16:9 (Variants of WVGA,16:9 ,0.360 Mpx)",
                    "480 x 15:9 (Variants of WVGA,15:9 ,0.384 Mpx)",
                    "480 x 16:9 (Variants of WVGA,16:9 ,0.407 Mpx)",
                    "480 x 16:9 (Variants of WVGA,16:9 ,0.409 Mpx)",
                    "480 x 16:9 (Variants of WVGA,16:9 ,0.409 Mpx)",
                    "480 x 16:9 (Variants of WVGA,16:9 ,0.410 Mpx)",
                    "1024 x 768 (Extended Graphics Array,XGA ,4:3 ,0.786 Mpx)",
                    "1152 x 768 (Extended Graphics Array,WXGA ,3:2 ,0.884 Mpx)",
                    "1280 x 768 (Extended Graphics Array,WXGA ,5:3 ,0.983 Mpx)",
                    "1280 x 800 (Extended Graphics Array,WXGA ,16:10 ,1.024 Mpx)",
                    "1360 x 768 (Extended Graphics Array,WXGA ,˜16:9 ,1.044 Mpx)",
                    "1366 x 768 (Extended Graphics Array,FWXGA ,˜16:9 ,1.049 Mpx)",
                    "1152 x 864 (Extended Graphics Array,XGA+ ,4:3 ,0.995 Mpx)",
                    "1440 x 900 (Extended Graphics Array,WXGA+ ,16:10 ,1.296 Mpx)",
                    "1440 x 960 (Extended Graphics Array,WSXGA ,3:2 ,1.382 Mpx)",
                    "1280 x 1024 (Extended Graphics Array,SXGA ,5:4 ,1.310 Mpx)",
                    "1400 x 1050 (Extended Graphics Array,SXGA+ ,4:3 ,1.470 Mpx)",
                    "1680 x 1050 (Extended Graphics Array,WSXGA+ ,16:10 ,1.764 Mpx)",
                    "1600 x 1200 (Extended Graphics Array,UXGA ,4:3 ,1.920 Mpx)",
                    "1920 x 1200 (Extended Graphics Array,WUXGA ,16:10 ,2.304 Mpx)",
                    "768 x 15:10 (Variants of WXGA,15:10 ,0.884 Mpx)",
                    "720 x 16:9 (Variants of WXGA,16:9 ,0.922 Mpx)",
                    "768 x 15:9 (Variants of WXGA,15:9 ,0.983 Mpx)",
                    "800 x 16:10 (Variants of WXGA,16:10 ,1.024 Mpx)",
                    "768 x 7:4 (Variants of WXGA,7:4 ,1.032 Mpx)",
                    "768 x 16:9 (Variants of WXGA,16:9 ,1.044 Mpx)",
                    "768 x 16:9 (Variants of WXGA,16:9 ,1.049 Mpx)",
                    "1152 x 864 (Variants of XGA+,SVGA,4:3 ,0.995 Mpx)",
                    "1152 x 900 (Variants of XGA+,Sun,1.28:1 ,1.037 Mpx)",
                    "1152 x 870 (Variants of XGA+,Apple,˜1.32:1 ,1.002 Mpx)",
                    "1120 x 832 (Variants of XGA+,NeXT,˜11:8 ,0.932 Mpx)",
                    "2048 x 1152 (Quad Extended Graphics Array,QWXGA ,16:9 ,2.359 Mpx)",
                    "2048 x 1536 (Quad Extended Graphics Array,QXGA ,4:3 ,3.145 Mpx)",
                    "2560 x 1600 (Quad Extended Graphics Array,WQXGA ,16:10 ,4.096 Mpx)",
                    "2880 x 1800 (Quad Extended Graphics Array,,16:10 ,5.184 Mpx)",
                    "2560 x 2048 (Quad Extended Graphics Array,QSXGA ,5:4 ,5.242 Mpx)",
                    "3200 x 2048 (Quad Extended Graphics Array,WQSXGA ,25:16 ,6.553 Mpx)",
                    "3200 x 2400 (Quad Extended Graphics Array,QUXGA ,4:3 ,7.680 Mpx)",
                    "3840 x 2400 (Quad Extended Graphics Array,WQUXGA ,16:10 ,9.216 Mpx)",
                    "4096 x 3072 (Hyper Extended Graphics Array,HXGA ,4:3 ,12.582 Mpx)",
                    "5120 x 3200 (Hyper Extended Graphics Array,WHXGA ,16:10 ,16.384 Mpx)",
                    "5120 x 4096 (Hyper Extended Graphics Array,HSXGA ,5:4 ,20.971 Mpx)",
                    "6400 x 4096 (Hyper Extended Graphics Array,WHSXGA ,25:16 ,26.214 Mpx)",
                    "6400 x 4800 (Hyper Extended Graphics Array,HUXGA ,4:3 ,30.720 Mpx)",
                    "7680 x 4800 (Hyper Extended Graphics Array,WHUXGA ,16:10 ,36.864 Mpx)"
            }
        
        for i, v in ipairs(dataSize) do
            if (dataSizeStr == "") then
                dataSizeStr = v
            else
                dataSizeStr = dataSizeStr.."|"..v
            end
        end
        
        scelta = rwfx_ShowList_Repos(dataSizeStr,"Dimensioni Predefinite", "module_resize_lua", false)
        if scelta then
            item = dataSize[scelta+1]
            G_resize_lua_Last_Value = item
            wcl_strip:setValue("ITEMVALUES", G_resize_lua_Last_Value)
            --buttonOk_click(control, change)
        end
    end
    
    local function main()
        --local title = "Dimensione(Larghezza x Altezza): "
        local title = _t(420)
        
        wcl_strip:init()
        wcl_strip:addButtonClose()
        
        wcl_strip:addLabel(nil, "  "..title.." : ")
        wcl_strip:addText("ITEMVALUES","")
        --wcl_strip:addButton("TEMPLATE","&Predefinite", buttonTemplate_click, false)
        wcl_strip:addButton("TEMPLATE",_t(421), buttonTemplate_click, false)
        --wcl_strip:addButton("OK","&Ridimensiona Finestra", buttonOk_click, true)
        wcl_strip:addButton("OK",_t(422), buttonOk_click, true)
        --wcl_strip:addButton("CANCEL","&Annulla", buttonCancel_click)
        wcl_strip:addButton("CANCEL",_t(239), buttonCancel_click)
        wcl_strip:show()
        
        --wcl_strip:setList("ITEMVALUES", dataSize)
        wcl_strip:setValue("ITEMVALUES", G_resize_lua_Last_Value)

    end
    
    --questa funzione, dal file corrente, converte la tabella copiata da
    -- Wikipedia in un arrai adatto al programma
    --
    -- Formato linea output, esempio:
    --  "640x360 (High-Definition, nHD, 16:9, 0.230 Mpx)"
    --  "[dat2]x[dat3] ([title], [dat1], [dat4], [dat5])"
    local function convert_Data_To_Array()
        local i = 0
        local txtLine = ""
        local endLine = editor.LineCount
        local dat = {}
        local title = ""
        local txtOut = ""
        
        while (i < endLine) do
            txtLine = editor:GetLine(i)
            if (string.sub(txtLine, 1, 5) == "***  ") then
                txtLine = rfx_RemoveReturnLine(txtLine)
                txtLine = string.sub(txtLine, 6)
                if (string.find(txtLine, "\t")) then
                    --print("Risoluzione -> "..rfx_RemoveReturnLine(txtLine))
                    dat = rfx_Split(txtLine, "\t")
                    if (#dat == 5) then
                        txtOut = "\""..dat[2].."x "..dat[3].."("..title..
                                 ","..dat[1]..","..dat[4]..","..dat[5].." Mpx)\","
                    else
                        txtOut = "\""..dat[2].."x "..dat[3].."("..title..
                                 ","..dat[3]..","..dat[4].." Mpx)\","
                    end
                    print(txtOut)
                else 
                    --print("Titolo -> "..rfx_RemoveReturnLine(txtLine))
                    title = rfx_RemoveReturnLine(txtLine)
                    i = i + 1
                end
            end
            i = i + 1
        end
        
    end
    
    main()
    --convert_Data_To_Array()
end




---end file