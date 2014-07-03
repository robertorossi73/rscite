<?php

/*
Questo script genera i file di definizione per le classi e per i metodi
definiti in PHP
*/
$destCartella = dirname(__file__)."\\";

$fileClassi = fopen($destCartella."phpclass.lst","w");
$classi = get_declared_classes();
sort($classi);
foreach( $classi as $value )
{
  $metodi = get_class_methods($value);
  if (count($metodi) > 0)
  {
    fwrite($fileClassi,$value."\n"); //scrittura nome classe
    
    $fileMetodi = fopen($destCartella."$value.lst","w");
    sort($metodi);
    foreach($metodi as $metod)
    {
      fwrite($fileMetodi,$metod."\n");//scrittura nome metodo
    }
    fclose($fileMetodi);
  }
}
fclose($fileClassi);

echo("\nEsecuzione script conclusa con successo!\n");
?>