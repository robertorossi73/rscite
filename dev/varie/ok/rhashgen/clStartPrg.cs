using System;
using System.Collections.Generic;
//using System.Linq;
using System.Text;

namespace rhashgen
{
    class clStartPrg
    {
        enum commandType {nothing, stringIn, fileIn}

        //esegue il software in base ai parametri passati sulla linea di comando
        //ritornando l'hash desiderato, in caso di errore ritorna ""
        public static string execute(string[] parameters)
        {
            clhasher.hashType algo = clhasher.hashType.nothing;
            string inString = "";
            commandType currentCmd = commandType.nothing;
            string inFile = "";
            string result = "";
            bool stopCommand = false;

            foreach (string par in parameters)
            {
                if ((par[0] == '/') && (!stopCommand))
                {
                    currentCmd = commandType.nothing;

                    if (par.ToUpper() == "/MD5")
                        algo = clhasher.hashType.md5;
                    else if (par.ToUpper() == "/SHA1")
                        algo = clhasher.hashType.sha1;
                    else if (par.ToUpper() == "/S") {
                        currentCmd = commandType.stringIn;
                        stopCommand = true;
                    } else if (par.ToUpper() == "/F") {
                        currentCmd = commandType.fileIn;
                        stopCommand = true;
                    }
                }
                else
                {
                    switch (currentCmd)
                    {
                        case commandType.fileIn:
                            inFile += par;
                            break;
                        case commandType.stringIn:
                            if (inString == "")
                                inString = par;
                            else
                                inString += " " + par;
                            break;
                    }

                    if (!stopCommand)
                        currentCmd = commandType.nothing;
                }

            }

            if (algo != clhasher.hashType.nothing)
            {
                if (inFile != "")
                {
                    result = clhasher.getHash(inFile, algo,true);
                }
                else if (inString != "")
                {
                    result = clhasher.getHash(inString, algo, false);
                }
            }

            return result;
        }
    }
}
