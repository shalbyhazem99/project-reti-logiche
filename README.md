# project_reti_logiche

## casi di test
-verifica dei vari shift <br>
-caso particolare in cui n-colonne e n righe =0 <br>
-1x1 (caso base) <br>
-128x128 (case limite): nel nostro testbench non sarà implementata poichè non particolarmente interessante al fine di verificare il corretto funzionamento del modulo (è abbastanza una 2x2 per verificare che funzioni anche 128x128 e viene effettuato con la verifica dei shift vari) <br>
-caso di reset: portato alto il segnale i_reset il modulo si deve riportare in uno stato da cui è pronto a partire con un altra elaborazione (nel nostro caso WAIT_START)<br>
-verifica del rapporto tra i segnali di start e done<br>
**per la verifica degli ultimi due casi è stato utile l'analisi grafica dei signali d'uscita del nostro modulo (di cui si riporta immagine)<br>
**nel caso di reset abbiamo presupposto che anche il segnale dei start venga riportato basso per il periodo in cui il reset è alto ma è indifferente<br>
