# Aura Athletic App 🏋️‍♂️

Applicazione per la gestione della palestra **Aura Athletic Club**

## Funzionalità principali
* **Visualizzazione Schede** Possibilità di visualizzare e utilizzare le schede create dal coach 
* **Prenotazione corsi**  Gestione in tempo reale delle prenotazioni e dei posti disponibili ai corsi della palestra
* **Comunicazioni** Possibilità di fornire qualsiasi tipo di comunicazione sulla palestra a tutti i clienti contemporaneamente
* **Cronologia allenamenti** Con la cronologia degli allenamenti è possibile vedere tutti gli allenamenti fatti e salvati per consultarli e vedere i miglioramenti

## Architettura
Utilizzo di un approccio **singleton** per la gestione della `Sessione` e `ListenableBuilder` per la reattività della UI.