--[[
Author  : Roberto Rossi
Version : 1.2.2
Web     : http://www.redchar.net

Questo modulo genera una frase "Mica siamo qui..."

Archivio frasi liberamente tratto da 
http://www.diegorizzi.com/index.php/humor/non-siamo-mica-qui-a

Copyright (C) 2012-2015 Roberto Rossi 
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

--------------------------------- Change Log ----------------------------------
V.1.2.0 :
  - eliminata interfaccia usando solo pannello output
V.1.1.0 :
  - introdotta interfaccia Stripe
V.1.0.1 :
  - modificata identificazione random della frase da mostrare in modo che risulti
    più casuale

]]

do
  require("luascr/rluawfx")

  local frasiMicaQui = {"Non siamo mica qui a pettinare le bambole...",
                "Non siamo mica qui a mettere lo smalto ai criceti...",
                "Non siamo mica qui a smacchiare i giaguari...",
                "Non siamo mica qui a pettinare i bruchi...",
                "Non siamo mica qui a spingere le tartarughe...",
                "Non siamo mica qui ad asciugare gli scogli...",
                "Non siamo mica qui a far disegnare i coccodrilli alle scimmie...",
                "Non siamo mica qui a grattare la pancia ai macachi...",
                "Non siamo mica qui a far ballare i cammelli...",
                "Non siamo mica qui ad allattare le manguste...",
                "Non siamo mica qui a pettinare le giraffe...",
                "Non siamo mica qui a far abbronzare l`orso bruno...",
                "Non siamo mica qui a far giocare gli scimpanze`...",
                "Non siamo mica qui a far la ceretta ai procioni...",
                "Non siamo mica qui a far ballare i trichechi...",
                "Non siamo mica qui a far camminare le quaglie...",
                "Non siamo mica qui a srotolare i pitoni...",
                "Non siamo mica qui a far accoppiare i conigli con le marmotte...",
                "Non siamo mica qui a far camminare i babbuini...",
                "Non siamo mica qui a raccontare le favole ai trichechi...",
                "Non siamo mica qui a far cantare le balene...",
                "Non siamo mica qui a pettinare le quaglie...",
                "Non siamo mica qui a far la permanente al polinano...",
                "Non siamo mica qui per far giocare a tombola i trichechi...",
                "Non siamo mica qui a far cantare la scimmia...",
                "Non siamo mica qui a far disegnare i coccodrilli agli scimpanze`...",
                "Non siamo mica qui a cercar di far accoppiare le formiche con gli elefanti...",
                "Non siamo mica qui ad arricciare la coda ai camaleonti...",
                "Non siamo mica qui a tagliar le unghie agli ippopotami...",
                "Non siamo mica qui a cavalcare l'orsetto lavatore...",
                "Non siamo mica qui a far la pedicure alle balene...",
                "Non siamo mica qui a pulire la schiena agli stercorari...",
                "Non siamo mica qui a pettinare le anaconde...",
                "Non siamo mica qui ad ammaestrare i calabroni...",
                "Non siamo mica qui a raddrizzare le banane...",
                "Non siamo mica qui a pulirci il culo con l'ortica...",
                "Non siamo mica qui a rasare i \"pelati\"...",
                "Non siamo mica qui a passare l'aspirapolvere sulla spiaggia...",
                "Non siamo mica qui ad allattare le manguste...",
                "Non siamo mica qui a fare le meches ai koala...",
                "Non siamo mica qui a svuotare il mare con un cucchiaino...",
                "Non siamo mica qui a dar da bere alle cozze...",
                "Non siamo mica qui a contare le gocce del mare...",
                "Non siamo mica qui a scopare il lago...",
                "Non siamo mica qui a mescolare i pirana con le mani...",
                "Non siamo mica qui a sbucciare l'anguria con le mani...",
                "Non siamo mica qui a controllare con una lente se cresce l'erba...",
                "Non siamo mica qui a friggere le uova sode...",
                "Non siamo mica qui a far la ceretta inguinale ai procioni...",
                "Non siamo mica qui a pettinare i baffi ai trichechi...",
                "Non siamo mica qui a dar lo smalto ai criceti...",
                "Non siamo mica qui a far rotolare pitoni...",
                "Mica stamo a fasse magnà 'l cazzo dalle mosche",
                "Non siamo mica qui a piallare il naso a Pinocchio...",
                "Non siamo mica qui a cambiare gli infissi al colosseo...",
                "Non siamo mica qui a mettere i sandali ai millepiedi...",
                "Non siamo mica qui ad accecare le talpe...",
                "Non siamo qui a mungere gli ippopotami...",
                "Non siamo qui a schiacciare i punti neri ai coccodrilli...",
                "Non siamo mica qui a mettere i pois alle coccinelle...",
                "Non siamo mica qui ad aprire gli occhi ai cinesi...",
                "Non siamo mica qui a mangiare il brodo sotto la pioggia...",
                "Non siamo mica qui a leggere al buio...",
                "Non siamo mica qui a spianare le gobbe ai cammelli...",
                "Non siamo mica qui a lasciare un messaggio dopo il segnale acustico...",
                "Non siamo mica qui ad affilare i pesci spada...",
                "Non siamo mica qui a ricamare la tela di Penelope...",
                "Non siamo mica qui a fare i buchi al groviera con il trapano...",
                "Non siamo mica qui ad illuminare l’altra faccia della Luna...",
                "Non siamo mica qui a rincorrere i bradipi...",
                "Non siamo mica qui a svegliare i ghiri...",
                "Non siamo mica qui a incrociare le parallele...",
                "Non siamo mica qui a dar da bere ai pesci...",
                "Non siamo mica qui a contare i fiocchi di neve...",
                "Non siamo mica qui a consolare i salici piangenti...",
                "Non siamo mica qui a gonfiar le vele soffiando....",
                "Non siamo mica qui a svuotare la vasca con il colino...",
                "Non siamo mica qui a colorare i camaleonti...",
                "Non siamo mica qui a fare i buchi nell'acqua col trapano...",
                "Non siamo mica qui a trapanare il polistirolo...",
                "Non siamo mica qui a scartavetrare le Dolomiti...",
                "Non siamo mica qui a infilare il culo nelle pedate...",
                "Non siamo mica qui a fare gli architetti dei Faraoni...",
                "Non siamo mica qui a dipingere le unghie agli Ottomani...",
                "Non siamo mica qui a insaccare la nebbia...",
                "Non siam mica qui a mettere i pannelli fotovoltaici alle lucciole...",
                "Non siamo mica qui ad asciugare le lacrime al coccodrillo...",
                "Non siamo mica qui a fare il tiro al piattello coi pesci volanti...",
                "Non siamo mica qui a mettere l’apparecchio ai denti agli squali...",
                "Non siamo mica qui a vedere sorgere il sole a Ostia Lido...",
                "Non siamo mica qui a tappare i formicai...",
                "Non siamo mica qui ad ammazzare le zanzare con la cerbottana...",
                "Non siamo mica qui a sbendare le mummie...",
                "Non siamo mica qui a depilare lo Yeti...",
                "Non siamo mica qui per sciare sulla forfora...",
                "Non siamo mica qui a spolverare le dune...",
                "Non siamo mica qui a stirare i perizoma...",
                "Non siamo mica qui a spalmare l’autan alle zanzare...",
                "Non siamo mica qui a addormentare il can che morde...",
                "Non siamo mica qui a togliere le occhiaie ai panda...",
                "Non siamo mica qui a prelevare il sangue alle zanzare...",
                "Non siamo mica qui a dare l’ansiolitico alle cavallette...",
                "Non siamo mica qui a dare l’attack alle cicale...",
                "Non siamo mica qui a dare il deodorante alle cimici...",
                "Non siamo mica qui ad insegnar catechismo alle foche monache...",
                "Non siamo mica qui a dare l’ansiolitico alle cavallette...",
                "Non siamo mica qui a prelevare il sangue alle zanzare...",
                "Non siamo mica qui a fare l’elemosina all’uranio impoverito...",
                "Non siamo mica qui a tagliar le unghie ai pesci...",
                "Non siamo mica qui a portare a spasso le lumache al guinzaglio...",
                "Non siamo mica qui a inamidare i colletti alle giraffe...",
                "Non siamo mica qui a mettere le infradito ai maiali...",
                "Non siamo mica qui a lavare i denti alle galline...",
                "Non siamo mica qui ad asciugarci i capelli con l' \"iPhone\"...",
                "Non siamo mica qui a lavare i denti alle balene...",
                "Non siamo mica qui a scavare tunnel ai neutrini...",
                "Non siamo mica qui a cambiare le ruote ai pavoni...",
                "Non siamo mica qui a truccare le cozze...",
                "Non siamo mica qui a prendere lezioni dall’albero maestro...",
                "Non siamo mica qui a passare il folletto nel deserto...",
                "Non siamo mica qui a schiacciare i punti neri ai dalmata...",
                "Non siamo mica qui a produrre frigoriferi a legna...",
                "Non siamo mica qui a spremere i cachi per risparmiar sul guttalax...",
                "Non siamo mica qui a covare l’uovo di Colombo...",
                "Non siamo mica qui a far l’aerosol ai formichieri...",
                "Non siamo mica qui a farci la ceretta coi Big Babol...",
                "Non siamo mica qui a mettere i fiori nei cannoni da neve...",
                "Non siamo mica qui a cantare attenti al luppolo...",
                "Non siamo mica qui a scaldare il posto col microonde...",
                "Non siamo mica qui a far la besciamella con Lasonil...",
                "Non siamo mica qui a metterci la brillantina sui peli del petto...",
                "Non siamo mica qui a imbottigliare l'idraulico liquido...",
                "Non siamo mica qui a soffiare il naso ai piccioni...",
                "Non siamo mica qui a fare il pesto con le foglie della marijuana...",
                "Non siamo mica qui a farci rosicchiar le unghie dai castori...",
                "Non siamo mica qui a tenere il piede in 2 scarpe...",
                "Non siamo mica qui a tagliar via i bordi ai toast...",
                "Non siamo mica qui a cotonare i Pooh...",
                "Non siamo mica qui a mettere la schiuma da barba nei Ringo...",
                "Non siamo mica qui a rompere le noci a Cip e Ciop...",
                "Non siamo mica qui a rimettere il dentifricio nel tubetto...",
                "Non siamo mica qui a mettere le bucce di banana nei palaghiaccio...",
                "Non siamo mica qui a fare il parmigiano con il latte di soia...",
                "Non siamo mica qui a far la ceretta allo Yeti...",
                "Non siamo mica qui a dar la cera in autostrada...",
                "Non siamo mica qui a inaffiare l'orto con la cedrata Tassoni...",
                "Non siamo mica qui a far la permanente ai cocker...",
                "Non siamo mica qui a piatrellare il bagno con le sottilette...",
                "Non siamo mica qui a mettere il perizoma al toro da monta...",
                "Non siamo mica qui a montare le tende a Lampedusa per portarci le tedesche...",
                "Non siamo mica qui a chiudere i buchi dell'Emmenthal...",
                "Non siamo mica qui a bussare prima di aprir le vongole...",
                "Non siamo mica qui a fare le 7 differenze con le gemelle Kessler...",
                "Non siamo mica qui a spalmare la pasta di fissan sul culatello...",
                "Non siamo mica qui a temperare i grissini...",
                "Non siamo mica qui a farci compagnia alle tende...da sole...",
                "Non siamo mica qui a portar la borsa al pitone...",
                "Non siamo mica qui a far saltar la corda al canguro...",
                "Non siamo mica qui a lucidare gli squali...",
                "Non siamo mica qui a organizzare le corse nei sacchi per gli struzzi...",
                "Non siamo mica qui a far l’happy hour con i vampiri...",
                "Non siamo mica qui a giocare a calcio con i fenicotteri...",
                "Non siamo mica qui a far portare le buste della spesa alle cicogne...",
                "Non siamo mica qui a far mosaici con i gusci delle tartarughe...",
                "Non siamo mica qui a far maglioncini ai ferri per le pecore...",
                "Non siamo mica qui a regalare ovetti kinder alle galline...",
                "Non siamo mica qui a fare i preparatori atletici per dei cinghiali...",
                "Non siamo mica qui a prenotare un tavolo al cinese per un setter irlandese...",
                "Non siamo mica qui a sbrinare gli igloo...",
                "Non siamo mica qui a togliere le scarpe a mille piedi...",
                "Non siamo mica qui a mangiare le noccioline alle scimmie...",
                "Non siamo mica qui a fare le corna ai cervi...",
                "Non siamo mica qui a dormire col ghiro...",
                "Non siamo mica qui a cercare le stelle nella stalla...",
                "Non siamo mica qui a sciogliere la treccia di raperunzel...",
                "Non siamo mica qui a sentire le cicali che cantano...",
                "Non siamo mica qui a fare le righe alla zebra...",
                "Non siamo mica qui a far pagare l’imu sulla casa alle lumache...",
                "Non siamo mica qui a girare la ruota del pavone...",
                "Non siamo mica qui a lucidare il pomo di Adamo...",
                "Non siamo mica qui a dar la cera alle api...",
                "Non siamo mica qui a vedere la luce al buio...",
                "Non siamo mica qui a far la convergenza ai trolley...",
                "Non siamo mica qui a chiederci se miss maglietta bagnata prende il raffreddore...",
                "Non siamo mica qui a svegliare gli orsi in letargo...",
                "Non siamo mica qui a sotterrare lombrichi...",
                "Non siamo mica qui a verniciare la muraglia cinese...",
                "Non siamo mica qui a mettere il pannolone alle fontane...",
                "Non siam mica qui ad ammaestrare i batteri...",
                "Non siam mica qui a mungere le foche...",
                "Non siam mica qui a imbottigliare l’aria...",
                "Non siam mica qui a pettinare le stringhe...",
                "Non siam mica qui a condire il sale...",
                "Non Siam mica qui a sbucciare le ciliegie...",
                "Non siamo mica qui a mettere il pannolone alle fontane...",
                "Non siamo mica qui a verniciare la muraglia cinese...",
                "Non siamo mica qui a svegliare gli orsi in letargo...",
                "Non siamo mica qui a sotterrare lombrichi...",
                "Non siamo mica qui a mangiare le noccioline alle scimmie...",
                "Non siamo mica qui a fare le corna ai cervi...",
                "Non siamo mica qui a dormire col ghiro...",
                "Non siamo mica qui a cercare le stelle nella stalla...",
                "Non siamo mica qui a sciogliere la treccia di raperunzel...",
                "Non siamo mica qui a sentire le cicali che cantano...",
                "Non siamo mica qui a fare le righe alla zebra...",
                "Non siamo mica qui a far pagare l’imu sulla casa alle lumache...",
                "Non siamo mica qui a far piangere i coccodrilli...",
                "Non siamo mica qui a girare la ruota del pavone...",
                "Non siamo mica qui a lucidare il pomo di Adamo...",
                "Non siamo mica qui a togliere la cera alle api...",
                "Non siamo mica qui a vedere la luce al buio...",
                "Non siamo mica qui a togliere le scarpe a mille piedi...",
                "Non siamo mica qui a cercare i buchi delle talpe...",
                "Non siamo mica qui a sbinare gli iglu...",
                "Non siamo mica qui a portar la borsa al pitone(!)...",
                "Non siamo mica qui a far cambiar colore al camaleonte...",
                "Non siamo mica qui a far saltar la corda al canguro...",
                "Non siamo mica qui a lucidare gli squali...",
                "Non siamo mica qui a organizzare le corse nei sacchi per gli struzzi...",
                "Non siamo mica qui a far l’happy hour con i vampiri...",
                "Non siamo mica qui a giocare a calcio con i fenicotteri...",
                "Non siamo mica qui a far portare le buste della spesa alle cicogne...",
                "Non siamo mica qui a far mosaici con i gusci delle tartarughe...",
                "Non siamo mica qui a fabbricare maglioncini ai ferri per le pecore...",
                "Non siamo mica qui a regalare ovetti kinder alle galline...",
                "Non siamo mica qui a fare i preparatori atletici per dei cinghiali...",
                "Non siamo mica qui a scritturare come speaker radio delle trote...",
                "Non siamo mica qui a prenotare un tavolo al cinese per un setter irlandese(!)...",
                "Non siam mica qui a temperare i grissini...",
                "Non siam mica qui a inamidare i colletti alle giraffe...",
                "Non siam mica qui a farci compagnia alle tende...da sole...",
                "Non siamo mica quì a spalar neve con i cucchiai...",
                "Non siamo mica qui a soffiare il naso ai piccioni...",
                "Non siamo mica qui a contare i chicchi di riso dei cinesi...",
                "Non siam mica qui a far l’aerosol ai formichieri!!",
                "Non siam mica qui a covare l’uovo di Colombo!!",
                "Siam mica qui a spremere i cachi per risparmiar sul guttalax...",
                "Siam mica quì a produrre frigoriferi a legna!!!",
                "Siam mica quì a schiacciare i punti neri ai dalmata...",
                "Non siamo mica quì a schiaccaire i punti neri ai dalmata!",
                "Non siamo mica quì a vendere il ghiaccio agli Eschimesi..."
              }

  function genFrase_micaqui(init)
    local maxid = table.maxn(frasiMicaQui)
    local id
    local frase = ""
    local result
    
    if init then
      math.randomseed(os.time())
    end
    
    id = math.random(1, maxid)
    id = math.random(1, maxid)
    frase = frasiMicaQui[id]    
    return frase
  end
  
  local function show()    
    local attuale = ""
    local nuova = ""
    local i = 0
    
 --   attuale = wcl_strip:getValue("FRASE")
    nuova = attuale
    
   -- while (nuova == attuale) do
      nuova = genFrase_micaqui(false)
     -- i = i + 1
    --end
    
    print("\n>Non siamo mica qui...\nFrase del giorno :\n\""..nuova.."\"")
    
  end
              
  show()
end
