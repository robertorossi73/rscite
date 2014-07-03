<?php

/*
 Questo modulo consente la generazione di hash di stringhe
 
 Autore : Roberto Rossi
 Versione : 0.0.2
 Copyright  : Roberto Rossi 2010
 
 
*/

//echo(file_get_contents("php://stdin")."\n");
//var_dump($_SERVER);
if ($_SERVER["argc"] == 4) 
{
  //tipo conversione, FILE o STRING
  $tipo = $_SERVER["argv"][1];
  $algoritmo = $_SERVER["argv"][2];
  $frase = $_SERVER["argv"][3];
}

  if (($tipo == "string") && (isset($frase)))
  {
    echo("->Selezione ($algoritmo) : \"".$frase."\"");
    
    $result = "";
    if (($algoritmo == "all") || ($algoritmo == "md5")) 
    {
      $result .= "\nmd5 : ".md5($frase);
    }
    
    if (($algoritmo == "all") || ($algoritmo == "sha1"))
    {
      $result .= "\nsha1 : ".sha1($frase);
    }

    if (($algoritmo == "all") || ($algoritmo == "crc32"))
    {
      $result .= sprintf("\ncrc32 : %u",crc32($frase));
    }
    echo($result);
  }
  else
    echo("NULL");



















?>