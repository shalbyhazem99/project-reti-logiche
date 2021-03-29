# Prova Finale di Reti Logiche - a.a. 2020-2021
Si vuole realizzare un componente come da [specifica](https://github.com/shalbyhazem99/project-reti-logiche/tree/main/specification/PFRL_Specifica.pdf), in grado di svolgere una versione semplificata del processo di equalizzazione dell’istogramma di un’immagine, ossia di ricalibrare il contrasto di quest’ultima, effettuando una ridistribuzione dei valori di intensità pixel per pixel.

## Esempio funzionamento

Immagine pre equalizzazione
![alt text](https://github.com/shalbyhazem99/project-reti-logiche/tree/main/documentation/esempio/preEqualizzazione.jpg)

## Implementazione

L'[implementazione](https://github.com/shalbyhazem99/project-reti-logiche/blob/main/project_reti_logiche.vhd) consiste nello sviluppo di una macchina a stati finiti. Oltre all'implementazione consegnata per l'esame è stata presa in considerazione un'altra [versione](https://github.com/shalbyhazem99/project-reti-logiche/blob/main/project_reti_logiche_v2.vhd) come la prima ma senza moltiplicazione. 

## Casi di test

Il corretto funzionamento del componente sviluppato è stato verificato tramite [numerosi TestBench](https://github.com/shalbyhazem99/project-reti-logiche/tree/main/test_banch). In particolare, si è scelto di concentrare l’attenzione su diversi casi critici possibili durante l’esecuzione e sul corretto calcolo di tutti i valori utilizzati. Di seguito una breve lista di condizioni e test
più significativi:

	* Corretto calcolo e utilizzo di tutti i possibili shift value;
	* Condizione particolare: n col · n row = 0
	* Casi limite di dimensione dell’immagine: 1x1 e 128x128 pixel;
	* Caso di reset dell’elaborazione;
	* Caso di reset dell’elaborazione seguito da un cambio di immagine in memoria;
	* Corretto rapporto tra i segnali i rst, i start e o done durante l’esecuzione.
## Sviluppatori

[Shalby Hazem](https://github.com/shalbyhazem99)

[Perego Niccolò](https://github.com/peregoniccolo)
