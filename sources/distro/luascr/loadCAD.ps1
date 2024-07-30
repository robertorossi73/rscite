# -*- coding: utf-8 -*-
#
# Autore : Roberto Rossi
# Web    : http://www.redchar.net
# Versione : 4.4.3
#
# Questo script consente il caricamento di un file lsp e scr(script)
# in un cad
#
#~ Copyright (C) 2024 Roberto Rossi 
#~ *******************************************************************************
#~ This library is free software; you can redistribute it and/or
#~ modify it under the terms of the GNU Lesser General Public
#~ License as published by the Free Software Foundation; either
#~ version 2.1 of the License, or (at your option) any later version.
#
#~ This library is distributed in the hope that it will be useful,
#~ but WITHOUT ANY WARRANTY; without even the implied warranty of
#~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#~ Lesser General Public License for more details.
#
#~ You should have received a copy of the GNU Lesser General Public
#~ License along with this library; if not, write to the Free Software
#~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#~ *******************************************************************************
#
#
# Cad Supportati : "acad" AutoCAD, "icad" progeCAD/IntelliCAD
#                  "bricscad" BricsCAD (BricscadApp.AcadApplication)
#
#
#
#
#
#
# utilizzo con ricerca automatica cad :
# loadCADLsp.ps1 "all" "c:\\test\\file.lsp"
# utilizzo esempio intellicad/progecad :
# loadCADLsp.ps1 "icad" "c:\\test\\file.lsp"
# utilizzo esempio AutoCAD :
# loadCADLsp.ps1 "acad" "c:\\test\\file.lsp"
#
#
#
#

chcp 65001
cls

class clsCAD
{
  [System.MarshalByRefObject] $cadObj = $null
  [string] $cadId = ""
  [string] $cadName = ""
  [string] $errMessage = ""
  
  # inizializza oggetto con identificativo COM applicazione e nome della stessa
  [bool] initialize([string] $cadIdName, [string] $cadStrName)
  {
    $this.cadId = $cadIdName
    $this.cadName = $cadStrName
    $this.cadObj = $null
    $this.errMessage = ""
    
    if ($this.tryGet() -ne $true)
    {
      $this.errMessage = "`n`n[ita] Il CAD selezionato è mancante o non è aperto!`n[eng] Selected CAD is missing or not opened!"
      return $false
    }
    return $true
  }
  
  # cerca istanza del cad
  [bool] tryGet()
  {
    try 
    {
      $this.cadObj = [Runtime.Interopservices.Marshal]::GetActiveObject($this.cadId)
    }
    catch {
      $this.cadObj = $null
      return $false
    }    
    return $true
  }
  
  # crea nuova istanza del cad
  [bool] tryNew()
  {
    try 
    {
      $this.cadObj = New-Object -COMObject $this.cadId
    }
    catch {
      $this.cadObj = $null
      return $false
    }    
    return $true
  }
  
  # controlla se il file analizzato è uno script .scr
  [bool] isScript($filePath)
  {
    $fileext = [System.IO.Path]::GetExtension($filePath).ToUpper()
    if ($fileext -eq ".SCR") 
    {
      return $true
    } else
    {
      return $false
    }
  }
 
}

class clsPcad : clsCAD
{
  clsPcad()
  {
    $this.initialize("Icad.Application", "progeCAD")
  }
  
  loadFile($filename)
  {
    if ($this.isScript($filename))
    {
      $this.cadObj.RunScript($filename)
    } else
    {
      $this.cadObj.LoadLisp($filename)
    }
  }

}

class clsBricscad : clsCAD
{
  clsBricscad()
  {
    $this.initialize("BricscadApp.AcadApplication", "Bricscad")
  }
  
  loadFile($filename)
  {
    if ($this.isScript($filename))
    {
      $this.cadObj.RunScript($filename.replace("\","\\"))
    } else
    {
      $this.cadObj.ActiveDocument.EvaluateLisp("(load `"" + $filename.replace("\","\\") + "`")")
    }
  }

}

class clsZWCADcad : clsCAD
{
  clsZWCADcad()
  {
    $this.initialize("ZWCAD.Application", "ZWCAD")
  }
  
  loadFile($filename)
  {
    if ($this.isScript($filename))
    {
      #$this.cadObj.RunScript($filename.replace("\","\\"))
      $this.cadObj.ActiveDocument.PostCommand("(command ""_.script"" """ + $filename.replace("\","\\") + """) ")
    } else
    {
      #$this.cadObj.ActiveDocument.EvaluateLisp("(load `"" + $filename.replace("\","\\") + "`")")
      $this.cadObj.ActiveDocument.PostCommand("(load """ + $filename.replace("\","\\") + """) ")
    }
  }

}

class clsAcad : clsCAD
{
  clsAcad()
  {
    $cadName = "AutoCAD"
    #https://en.wikipedia.org/wiki/AutoCAD_version_history
    #TODO: da verificare
    $this.initialize("AutoCAD.Application", $cadName)
    
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.25", $cadName) } #2025
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.24.3", $cadName) } #2024
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.24.2", $cadName) } #2023
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.24.1", $cadName) } #2022
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.24", $cadName) } #2021
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.23.1", $cadName) } #2020
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.23", $cadName) } #2019
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.22", $cadName) } #2018
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.21", $cadName) } #2017
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.20.1", $cadName) } #2016
    if ($this.cadObj -eq $null) { 
      $this.initialize("AutoCAD.Application.20", $cadName) } #2015    
  }
  
  loadFile($filename)
  {
    if ($this.isScript($filename))
    {
      $this.cadObj.ActiveDocument.PostCommand("(command ""_.script"" """ + $filename + """) ")
    } else
    {
      $this.cadObj.ActiveDocument.PostCommand("(load """ + $filename + """) ")
    }
  }
  
}

### Impostazione base
$debug = $false #attiva o disattiva la modalità debug
#$debug = $true #attiva o disattiva la modalità debug
### Fine Impostazione base


$showError = $false
$verb = $args[0]
$filename = $args[1]

###debug
if ($debug)
{
  $verb = "zcad"
  $filename = "C:\Temp\file caricabili\ci®Ωo.lsp"
  #$filename = "C:\Temp\file caricabili\test.scr"
  $showError = $true
}
###end debug

if ($verb)
{
  #write-output $args[0]
} else
{
  write-output "Missing parameter 1"
  $showError = $true
}

if ($verb)
{
  #write-output $args[1]
} else
{
  write-output "Missing parameter 2"
  $showError = $true
}

if ($verb -eq "icad")
{
  $cad = [clsPcad]::new()
  if ($cad.cadObj -ne $null) { 
    #write-output ("ok " + $cad.cadId)
    $cad.loadFile($filename)
  }
  else { 
    write-output ($cad.errMessage + " - " + $cad.cadName) 
    $showError = $true
  }
}

if ($verb -eq "bcad")
{
  $cad = [clsBricscad]::new()
  if ($cad.cadObj -ne $null) { 
    #write-output ("ok " + $cad.cadId)
    $cad.loadFile($filename)
  }
  else { 
    write-output ($cad.errMessage + " - " + $cad.cadName) 
    $showError = $true
  }
}

if ($verb -eq "zcad")
{
  $cad = [clsZWCADcad]::new()
  if ($cad.cadObj -ne $null) { 
    #write-output ("ok " + $cad.cadId)
    $cad.loadFile($filename)
  }
  else { 
    write-output ($cad.errMessage + " - " + $cad.cadName) 
    $showError = $true
  }
}

if ($verb -eq "acad")
{
  $cad = [clsAcad]::new()
  if ($cad.cadObj -ne $null) { 
    #write-output ("ok " + $cad.cadId) 
    $cad.loadFile($filename)
  }
  else { 
    write-output ($cad.errMessage + " - " + $cad.cadName) 
    $showError = $true
  }
}

if ($showError)
{
  write-output("`n[ita]Premi un tasto per continuare...`n[eng]Press Key to continue...")
  [Console]::ReadKey()
}


