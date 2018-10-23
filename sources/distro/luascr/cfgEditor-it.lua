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
"Generale",
  
{
    "Dividi editor/output verticalmente",
    "int", "split.vertical", 
    {
        "Dividi orizzontalmente (0)","0",
        "Dividi verticalmente (1)","1",
        "Valore predefinito", "*REMOVE*"
    },
"If split.vertical is set to 1 then the output pane is to the right of the editing pane, if set to 0 then the output pane is below the editing pane."
},

{
    "Riduci il programma a icona",
    "int", "minimize.to.tray",
    {
        "Riduzione a icona standard (0)","0",
        "Riduci a icona nella tray area (1)","1",
        "Valore predefinito", "*REMOVE*"
    },
"Setting this to 1 minimizes SciTE to the system tray rather than to the task bar."
},

{
    "Visibilita' barra delle schede",
    "int", "tabbar.visible",
    {
        "Nascondi la barra (0)","0",
        "Schede sempre visibili (1)","1",
        "Valore predefinito", "*REMOVE*"
    },
"Setting tabbar.visible to 1 makes the tab bar visible at start up. The buffers property must be set to a value greater than 1 for this option to work."
},

{
    "Visibilita' schede con un solo elemento",
    "int", "tabbar.hide.one",
    {
        "Mostra sempre le schede (0)","0",
        "Nascondi le schede quando e' presente un solo elemento (1)","1",
        "Valore predefinito", "*REMOVE*"
    },
"Setting tabbar.hide.one to 1 hides the tab bar until there is more than one tab."
},

{
    "Nascondi indice nelle schede",
    "int", "tabbar.hide.index",
    {
        "Mostra sempre l'indice nelle schede (0)","0",
        "Nascondi l'indice numerico delle schede aperte (1)","1",
        "Valore predefinito", "*REMOVE*"
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
    "Numero massimo di file contemporanei", 
    "int", "buffers", false,
"Set to a number between 1 and 100 to configure that many buffers. Values outside this range are clamped to be within the range. The default is 1 which turns off UI features concerned with buffers.\nThis value is read only once, early in the startup process and only from the global and user properties files. So after changing it, restart SciTE to see the effect. "
},

{
    "Ordine Ctrl+Tab", 
    "str", "buffers.zorder.switching", 
    {
        "Ordine naturale (0)", "0",
        "Ordina in base a utilizzo (1)", "1",
        "Valore predefinito", "*REMOVE*"
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
    "Evidenziazione struttura",
    "int", "fold.highlight", 
    {
        "Non evidenziare (0)","0",
        "Evidenzia struttura (1)","1",
        "Valore predefinito", "*REMOVE*"
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
"Varie",
{
    "Apri file di configurazione personale", 
    "cmd", "IDM_OPENUSERPROPERTIES", false,
    ""
},
{
    "Apri file di configurazione globale", 
    "cmd", "IDM_OPENGLOBALPROPERTIES", false,
    ""
},
{
    "Apri Aiuto di SciTE", 
    "cmd", "IDM_HELP_SCITE", false,
    ""
},
{
    "Apri Guida a RSciTE", 
    "cmd", "RSCITE_GUIDE", false,
    ""
},



}
