Option Explicit
' Autore : Roberto Rossi
' Web    : http://www.redchar.net
' Versione : 1.9
'
' Questo script consente il caricamento di un file lsp
' in un cad
'
'~ Copyright (C) 2015-2022 Roberto Rossi 
'~ *******************************************************************************
'~ This library is free software; you can redistribute it and/or
'~ modify it under the terms of the GNU Lesser General Public
'~ License as published by the Free Software Foundation; either
'~ version 2.1 of the License, or (at your option) any later version.

'~ This library is distributed in the hope that it will be useful,
'~ but WITHOUT ANY WARRANTY; without even the implied warranty of
'~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
'~ Lesser General Public License for more details.

'~ You should have received a copy of the GNU Lesser General Public
'~ License along with this library; if not, write to the Free Software
'~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
'~ *******************************************************************************
'
'
' Cad Supportati : "acad" AutoCAD, "icad" IntelliCAD/ProgeCAD
'
' utilizzo con ricerca automatica cad :
' loadCADLsp.vbs "all" "c:\\test\\file.lsp"
' utilizzo esempio intellicad/progecad :
' loadCADLsp.vbs "icad" "c:\\test\\file.lsp"
' utilizzo esempio AutoCAD :
' loadCADLsp.vbs "acad" "c:\\test\\file.lsp"
' utilizzo esempio BricsCAD :
' loadCADLsp.vbs "bcad" "c:\\test\\file.lsp"
' utilizzo esempio ZwCAD :
' loadCADLsp.vbs "zcad" "c:\\test\\file.lsp"
'


'---------------------------- Intellicad/progeCAD ---------------------------- 
'invia nome di file lsp a IntelliCAD/ProgeCAD
'per essere caricato
function SentToIcad(cmdStr)
    dim obj
    dim shl

    set obj = GetIcad()
    set shl = CreateObject("WScript.Shell")
    shl.AppActivate obj.caption
    
    obj.RunCommand("(load """ & cmdStr & """)")
end function

'ritorna l'oggetto riferito a IntelliCAD/ProgeCAD
function GetIcad()
dim obj

on error resume next
set obj = GetObject(,"Icad.Application")
On Error GoTo 0
if (IsEmpty(obj)) then
    set obj = Nothing
end if

set GetIcad = obj
end function

'ritorna true/false in base all'esistenza dell'oggetto
'riferito a IntelliCAD/ProgeCAD
function ExistIcad()
dim result
dim obj
    
    set obj = GetIcad()
    
    if (obj is Nothing) then
        result = false
    else
        result = true
    end if

ExistIcad = result
end function

'---------------------------- ZwCAD ---------------------------- 
'invia nome di file lsp a ZwCAD
'per essere caricato
function SentToZcad(cmdStr)
    dim obj
    dim shl

    set obj = GetZcad()
    obj.ActiveDocument.SendCommand("(load """ & cmdStr & """)" & vbcr)
    
    set shl = CreateObject("WScript.Shell")
    shl.AppActivate obj.caption
end function

'ritorna l'oggetto riferito a ZwCAD
function GetZcad()
    dim obj

    on error resume next
    set obj = GetObject(,"ZWCAD+.Application")
    On Error GoTo 0
    if (IsEmpty(obj)) then
        set obj = Nothing
    end if

    set GetZcad = obj
end function

'ritorna true/false in base all'esistenza dell'oggetto
'riferito a ZwCAD
function ExistZcad()
    dim result
    dim obj        
    set obj = GetZcad()        
    if (obj is Nothing) then
        result = false
    else
        result = true
    end if

    ExistZcad = result
end function

'---------------------------- BricsCAD ---------------------------- 
'invia nome di file lsp a BricsCAD
'per essere caricato
function SentToBcad(cmdStr)
    dim obj
    dim shl

    set obj = GetBcad()
    obj.ActiveDocument.SendCommand("(load """ & cmdStr & """)" & vbcr)

    set shl = CreateObject("WScript.Shell")
    shl.AppActivate obj.caption
end function

'ritorna l'oggetto riferito a BricsCAD
function GetBcad()
    dim obj

    on error resume next
    set obj = GetObject(,"BricscadApp.AcadApplication")
    On Error GoTo 0
    if (IsEmpty(obj)) then
        set obj = Nothing
    end if

    set GetBcad = obj
end function

'ritorna true/false in base all'esistenza dell'oggetto
'riferito a BricsCAD
function ExistBcad()
    dim result
    dim obj        
    set obj = GetBcad()        
    if (obj is Nothing) then
        result = false
    else
        result = true
    end if

    ExistBcad = result
end function


'---------------------------- AutoCAD ---------------------------- 
'invia nome di file lsp a AutoCAD
'per essere caricato
function SentToAcad(cmdStr)
    dim obj
    dim shl

    set obj = GetAcad()
    obj.ActiveDocument.SendCommand("(load """ & cmdStr & """)" & vbcr)

    set shl = CreateObject("WScript.Shell")
    shl.AppActivate obj.caption
end function

function GetAcadApp ( app )
    dim obj

    on error resume next
    set obj = GetObject(,app)
    On Error GoTo 0
    if (IsEmpty(obj)) then
        set obj = Nothing
    end if

    set GetAcadApp = obj
end function

'ritorna l'oggetto riferito a AutoCAD
function GetAcad()
    dim obj
    
    set obj = GetAcadApp("AutoCAD.Application")
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.20")
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.20.1")
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.21")
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.22")
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.23")'AutoCAD 2019
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.23.1")'AutoCAD 2020
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.24")'AutoCAD 2021
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.24.1")'AutoCAD 2022
    end if
    if (obj is Nothing) then
        set obj = GetAcadApp("AutoCAD.Application.24.2")'AutoCAD 2023
    end if
    
    if (IsEmpty(obj)) then
        set obj = Nothing
    end if

    set GetAcad = obj
end function

'ritorna true/false in base all'esistenza dell'oggetto
'riferito a AutoCAD
function ExistAcad()
    dim result
    dim obj        
    set obj = GetAcad()        
    if (obj is Nothing) then
        result = false
    else
        result = true
    end if

    ExistAcad = result
end function

'---------------------------- Procedura principale ---------------------------- 
'funzione principale
sub Main()
    dim cmdStr
    dim cadName

    cmdStr = ""
    cadName = ""

    if (Wscript.Arguments.Count > 1) then
        cmdStr = WScript.Arguments(1)
        cadName = WScript.Arguments(0)
    end if
    
    if (cmdStr <> "") then
        if (cadName = "icad") then
            if (ExistIcad()) then
                SentToIcad(cmdStr)
            else
                call MsgBox("IntelliCAD/ProgeCAD is Missing")
            end if
        elseif (cadName = "acad") then
            if (ExistAcad()) then
                SentToAcad(cmdStr)
            else
                call MsgBox("AutoCAD is Missing")
            end if
        elseif (cadName = "bcad") then
            if (ExistBcad()) then
                SentToBcad(cmdStr)
            else
                call MsgBox("BricsCAD is Missing")
            end if
        elseif (cadName = "zcad") then
            if (ExistZcad()) then
                SentToZcad(cmdStr)
            else
                call MsgBox("ZWCAD is Missing")
            end if
        elseif (cadName = "all") then 'ricerca automatica
        
            if (ExistIcad()) then
                SentToIcad(cmdStr)
            else
                if (ExistAcad()) then
                    SentToAcad(cmdStr)
                else
                    if (ExistBcad()) then
                        SentToBcad(cmdStr)
                    else
                        if (ExistZcad()) then
                            SentToZcad(cmdStr)
                        else
                            call MsgBox("CAD is Missing")
                        end if
                    end if
                end if
            end if

        end if            
    else
        call MsgBox("Missing File Name")
    end if
    
end sub

Main()

