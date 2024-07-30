;Tester dialog template

(defun RSciTE_testLoadingDcl ( dclFileName dialogName / 
                                dclid
                                msgMissingDialog
                                lang
                                )
    (setq msgMissingDialog (strcat "[ITA] Il nome di Dialog specificato è mancante: '" dialogName "'"))
    (setq msgMissingDialog (strcat msgMissingDialog "\n[ENG] Specified Dialog Name is missing: '" dialogName "'"))
    
    (if (/= dialogName "")
        (progn 
            (setq dclid (load_dialog dclFileName))    
            (if dclid
                (progn
                    (if (new_dialog dialogName dclid)
                        (start_dialog)
                        (alert msgMissingDialog)
                    );endif
                    (unload_dialog dclid)
                )
            )
        );endp
        (alert msgMissingDialog)
    );endif
    
(prin1)
);enddef


(RSciTE_testLoadingDcl "dclFileNamePosition" "dialogNamePosition")
