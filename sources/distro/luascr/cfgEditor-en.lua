--[[
Autore  : Roberto Rossi
Web     : http://www.redchar.net

Editor di configurazione per le proprietà di SciTE

Configurazioni

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
    
    --configurazioni disponibili divise in gruppi logici
    --Dati.
    --  Ogni elemento presenta un titolo, un tipo, il nome della configurazione (es.:"view.whitespace"),
    --      i valori possibili con descrizione, infine l'identificativo della descrizione lunga che verrà cercato nel file corrente delle traduzioni
    --  Se l'elemento è una stringa e non una tabella significa che è il nome di gruppo
    --  Se l'elemtno è un comando diretto significa che la sua esecuzione genererà un'azione diretta e precisa
    --I tipi previsti sono :
    --                          configurazione manuale (manual), solo descrizione
    --                          numero intero   (int)
    --                          stringa         (str)
    --                          comando diretto (cmd)
    --
    
cfgEditor_tblItems = {
--1."Titolo", 2."Tipo", 3."configurazione", 4."valori possibili oppure false per valori liberi", 5."id descrizione estesa"


-- --------------------------------------------------------------------
"Globals",
  
{
    "Split output pane and editing pane",
    "int", "split.vertical", 
    {
        "Horizontal split (0)","0",
        "Vertical split (1)","1",
        "Default value", "*REMOVE*"
    },
"If split.vertical is set to 1 then the output pane is to the right of the editing pane, if set to 0 then the output pane is below the editing pane."
},

{
    "Minimize to tray",
    "int", "minimize.to.tray",
    {
        "Standard minimize (0)","0",
        "Minimize to tray (1)","1",
        "Default value", "*REMOVE*"
    },
"Setting this to 1 minimizes SciTE to the system tray rather than to the task bar."
},

{
    "Tabbar visibility",
    "int", "tabbar.visible",
    {
        "Hide tabbar (0)","0",
        "Show tabbar (1)","1",
        "Default value", "*REMOVE*"
    },
"Setting tabbar.visible to 1 makes the tab bar visible at start up. The buffers property must be set to a value greater than 1 for this option to work."
},

{
    "Tabbar hide one",
    "int", "tabbar.hide.one",
    {
        "Show always tabbar (0)","0",
        "Hide the tabbar until there is more than one tab (1)","1",
        "Default value", "*REMOVE*"
    },
"Setting tabbar.hide.one to 1 hides the tab bar until there is more than one tab."
},

{
    "Tabbar hide index",
    "int", "tabbar.hide.index",
    {
        "Show buffer index (0)","0",
        "Hide buffer index (1)","1",
        "Default value", "*REMOVE*"
    },
"Setting tabbar.hide.index to 1 will hide the buffer number in tabs. "
},

-- --------------------------------------------------------------------
-- "Dimensione e visibilita'",

-- {
--     "Font/Colore pannello di Output", 
--     "str", "style.errorlist.32", false,
--     "Output panel color configuration."
-- },
-- {"Cfg 3", "int", "", false, 105},

-- --------------------------------------------------------------------
-- "Stile Elementi",

-- {"Cfg 1", "int", "", false, 106},
-- {"Cfg 2", "str", "", false, 107},
-- {"Cfg 3", "int", "", false, 108},

-- --------------------------------------------------------------------
-- "Scripting",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
"Controllo",

{
    "Max opened files (buffers)",
    "int", "buffers", false,
"Set to a number between 1 and 100 to configure that many buffers. Values outside this range are clamped to be within the range. The default is 1 which turns off UI features concerned with buffers.\nThis value is read only once, early in the startup process and only from the global and user properties files. So after changing it, restart SciTE to see the effect. "
},

{
    "Buffers zorder switching",
    "str", "buffers.zorder.switching", 
    {
        "Order based on the buffer number (0)", "0",
        "Order of their previous selection (1)", "1",
        "Default value", "*REMOVE*"
    },
"This setting chooses the ordering of buffer switching when Ctrl+Tab pressed. Set to 1, the buffers are selected in the order of their previous selection otherwise they are chosen based on the buffer number."
},

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Indentazione",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Interruzione linee lunghe",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
"Folding",

{
    "Fold highlight",
    "int", "fold.highlight", 
    {
        "Disable highlight (0)","0",
        "Enable highlight for current folding block (1)","1",
        "Default value", "*REMOVE*"
    }, 
"Set to 1 to enable highlight for current folding block (smallest one that contains the caret). By default, it's disable."
},

-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Ricerca e sostituzione",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Comportamento",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Barra di stato",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Internazzionalizzazione",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Esportazione",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "Stampa",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
-- "RSciTE",

-- {"Cfg 1", "int", "", false, 109},
-- {"Cfg 2", "str", "", false, 110},
-- {"Cfg 3", "int", "", false, 111},

-- --------------------------------------------------------------------
"Others",
{
    "Open personal configuration file", 
    "cmd", "IDM_OPENUSERPROPERTIES", false,
    ""
},
{
    "Open global configuration file", 
    "cmd", "IDM_OPENGLOBALPROPERTIES", false,
    ""
},
{
    "Open SciTE Help", 
    "cmd", "IDM_HELP_SCITE", false,
    ""
},



}
