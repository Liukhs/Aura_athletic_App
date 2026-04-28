<div align=center>

# ⚡ Aura Athletic App
**Il tuo compagno digitale per l'allenamento in palestra**

Aura Athletic App è un applicazione Flutter moderna progettata per gli iscritti alla palestra. Permette di consultare le schede allenamento, prepararne, prenotare corsi i tempo reale e monitorare i propri progressi.

Disponibilità di interfaccia "Dark mode" e "Light mode"(Da sistemare)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)
![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg?style=for-the-badge)

</div>

---
## 🚀 Funzionalità Principali

* **🔐 Autenticazione Intelligente:** Sistema di login con persistenza dei dati, tramite `shared_preferences`.
* **📅 Gestione Corsi:** Visualizzazione dei corsi disponibili con calcolo dei partecipanti in tempo reale.
* **💪 Schede di Allenamento:** Accesso alle schede create dal coach e possibilità di creare le proprie.
* **🌐 Sincronizzazione Cloud:** DB dedicato per il salvataggio e scaricamento dei dati 
---
## 🛠️ Tecnologie Utilizzate

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** Provider / Session Singleton
* **Persistenza Dati:** `shared_preferences`
* **Networking:** `http` per il recupero dei dati da database remoto.
* **Backend:** Database JSON ospitato su GitHub (in transizione verso MySQL/PHP).
---

## 📂 Struttura del Progetto

```text
lib/
├── data/           # Gestione della sessione e dati mock
├── models/         # Modelli degli oggetti (Utente, Corso, Esercizio, ecc.)
├── pages/          # Schermate dell'app (Login, Home, Profilo)
├── services/       # Servizi API e DataService per il fetch dei dati
├── widgets/        # Componenti grafici riutilizzabili (es. cardCorso)
└── main.dart       # Punto di ingresso dell'applicazione
```
---

## ⚙️ Installazione e Setup

### Clonazione della repository
```bash
git clone https://github.com/Liukhs/Aura_athletic_App.git
```
### Entrare nella cartella del progetto
```bash
cd aura_athletic_app/prova
```
### Installa le dipendenze
```bash
flutter pub get
```
### Avvia l'applicazione
```bash
flutter run
```
---
## 🚧 Roadmap
- [ ] Migrazione Database da Github JSON a MySQL
- [ ] Implementazione di un sistema di Upload per le immagini del profilo
- [ ] Creazione di schede di allenamento personali direttamente dall'applicazione
- [ ] Notifiche push per corsi, fine riposo, e altre

---
## 👤 Autore
- Luca - [Liukhs](https://github.com/Liukhs)
---
⭐️ Se questo progetto ti piace, lascia una stella sul repository!