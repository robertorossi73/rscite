<?php
/*
  Autore : Roberto Rossi
  Versione : 1.4.1
  
  Questo script ha il compito di creare il file di installazione di RSciTE,
  inoltre genera il file .zip della versione portabile. In aggiunta viene
  generato il file .zip della 'Guida Alle Caratteristiche' di RSciTE

*/

/*Configurazioni distribuzione*/
$SciTE_VERMAG =     "1";    //versione principale SciTE
$SciTE_VERMIN =     "74";   //versione secondaria SciTE
$SciTE_VERDISTRO =  "2"; //versione distribuzione


/*Configurazioni generali script*/
$Zip =  "C:\\Program Files\\7-Zip\\7z.exe"; ///Zip
$Nsis = "d:\\tools\\Develop_\\nsis20\\makensis.exe";  //Eseguibile NSis V2
$NsisAlt = "c:\\program files\\nsis\\makensis.exe";  //Eseguibile NSis Alternativo


/*---------------------------------------------------------------------------*/
$flagOk = true;
$flagErrorNsis = false;
$flagErrorZip = false;
$nomeFCompresso = "sci".$SciTE_VERMAG."_".$SciTE_VERMIN."-".$SciTE_VERDISTRO;
$nomeFCompressoGuida = "guida_".$SciTE_VERMAG."_".$SciTE_VERMIN."-".$SciTE_VERDISTRO;

function s($comando) {
  system($comando);
}

if (file_exists($Zip)) {
  s("del \".\\release\\".$nomeFCompresso.".zip\"");
  s("del \".\\release\\".$nomeFCompresso.".7z\"");
  s("del \".\\release\\".$nomeFCompressoGuida.".zip\"");
  s("\"$Zip\" u -tzip ./release/".$nomeFCompresso.".zip ../distro/* -r -x!.svn");
  //s("\"$Zip\" u -t7z ./release/".$nomeFCompresso.".7z ../distro/* -r -x!.svn");

  s("\"$Zip\" u -tzip ./release/".$nomeFCompressoGuida.".zip ../distro/hlpscite/rscite/* -r -x!.svn");
} else {
  $flagErrorZip = true;
  $flagOk = false;
}

if (file_exists($Nsis) or file_exists($NsisAlt)) {
  if (file_exists($NsisAlt))
    s("\"$NsisAlt\" /DVERMAGGIORE=$SciTE_VERMAG /DVERMINORE=$SciTE_VERMIN /DVERDISTRIB=$SciTE_VERDISTRO rscite.nsi");
  else
    s("\"$Nsis\" /DVERMAGGIORE=$SciTE_VERMAG /DVERMINORE=$SciTE_VERMIN /DVERDISTRIB=$SciTE_VERDISTRO rscite.nsi");
} else {
  $flagErrorNsis = true;
  $flagOk = false;
}

if ($flagOk)
  echo("\nProcedura Conclusa con successo.");
else {
  echo("\n\n Attenzione, sono stati riscontrati i seguenti errori :");
  if ($flagErrorNsis)
    echo("\n - Manca il file '$Nsis'\n   Impossibile completare la creazione dell'installazione!");
  if($flagErrorZip)
    echo("\n - Manca il file '$Zip'\n   Impossibile completare la creazione degli archivi compressi!");
  echo("\n\n");
}

if ($flagOk) {
  echo("Variabile Ok");
} else {
  echo("Variabile Errata");
}

if ($flagOk) {
  echo("Variabile Ok");
} else {
  echo("Variabile Errata");
}

?>