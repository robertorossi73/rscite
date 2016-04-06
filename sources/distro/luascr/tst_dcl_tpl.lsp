;Tester dialog template

(defun RSciTE_testLoadingDcl ( dclFileName dialogName / 
                                dclid
                                msgMissingDialog
                                lang
                                )
    (setq lang (strcase (getvar "LOCALE")))
    (if (= lang "ITA")
        (progn
            (setq msgMissingDialog (strcat "Il nome di Dialog specificato è mancante: '" dialogName "'"))
        )
        (progn ;ENG and others
            (setq msgMissingDialog (strcat "Specified Dialog Name is missing: '" dialogName "'"))
        )
    )
    
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
