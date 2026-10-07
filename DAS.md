# Documento di Architettura Software (DAS)

> Le sezioni e i paragrafi marcati **[NUOVO]** sono stati aggiunti rispetto alla prima bozza. Le parti originali sono state mantenute e corrette (refusi, naming).

## 1. Introduzione

Il presente documento descrive l'architettura software dell'applicazione di gestione degli allenamenti, definendo l'organizzazione dei dati tra il database remoto (Cloud) e la persistenza locale (Device), oltre alla logica di autenticazione e sincronizzazione.

### 1.1 Ambito **[NUOVO]**
- **Piattaforma:** app mobile Flutter (Android / iOS).
- **Funzioni coperte:** autenticazione, gestione delle schede di allenamento, consultazione del catalogo esercizi, svolgimento e storico degli allenamenti, profilo utente.
- **Fuori ambito (per ora):** gestione corsi e messaggi della palestra, pagamenti, pannello di amministrazione per i trainer.

### 1.2 Glossario **[NUOVO]**
| Termine | Significato |
|---|---|
| Scheda | Insieme ordinato di esercizi programmati, appartenente a un utente |
| Esercizio programmato | Un esercizio del catalogo inserito in una scheda, con serie, ripetizioni e recupero |
| Allenamento | Una sessione di allenamento svolta (storico) |
| Lazy / on-demand | Dato scaricato solo nel momento in cui serve |
| Sync | Allineamento tra database locale e remoto |

---

## 2. Decisioni architetturali **[NUOVO]**

| # | Decisione | Motivazione |
|---|---|---|
| D1 | Backend: **Supabase** (Auth, Postgres, Storage) | Auth e API REST già pronte, nessun backend da scrivere |
| D2 | Persistenza locale: **SQLite** (`sqflite`) | Uso offline e avvio rapido |
| D3 | Strategia **Offline-First / Local Cache**: l'app legge sempre dal DB locale; la rete serve solo per sincronizzare e per il catalogo | Palestre con copertura scarsa |
| D4 | Gli **ID delle entità create dall'utente sono UUID generati sul dispositivo** | Permette di creare schede offline senza collisioni |
| D5 | Conflitti di sync: **last-write-wins** sul campo `updated_at` | Semplice, sufficiente per dati personali di un singolo utente |
| D6 | Il catalogo esercizi è **sola lettura** per l'app | Nessun utente deve poterlo modificare |
| D7 | Le password **non vengono mai salvate** dall'app: ci pensa Supabase Auth | Sicurezza |

---

## 3. Stack e organizzazione a livelli **[NUOVO]**

```text
UI (Pages / Widgets)
        |
State (Sessione / ChangeNotifier o equivalente)
        |
Repository  (EserciziRepository, SchedeRepository, AuthRepository, AllenamentiRepository)
        |                         |
Database locale (sqflite)    Supabase client (REST / Auth / Storage)
```

- La UI **non parla mai direttamente** con Supabase o SQLite: passa dai repository.
- I repository decidono da dove leggere (locale o remoto) e gestiscono la sync.
- Pacchetti principali: `supabase_flutter`, `sqflite`, `cached_network_image`, `connectivity_plus`, `uuid`, `shared_preferences`.

---

## 4. Architettura dei Dati

L'applicazione adotta una strategia **Offline-First / Local Cache**, utilizzando **Supabase** per il backend e la sincronizzazione globale, e **SQLite** per la memorizzazione e le prestazioni locali.

### 4.1 Convenzione dei nomi **[NUOVO]**
Il catalogo importato (`exercises`) ha colonne in inglese, mentre le tabelle dell'app sono in italiano. Va scelta **una sola convenzione** per le tabelle e le colonne di applicazione (es. tutto in italiano, `snake_case`), mantenendo le colonne di `exercises` come da dataset. Le tabelle locali devono avere **lo stesso nome** e le stesse colonne delle remote, così il mapping resta banale (oggi: `profilo` locale vs `profiles` remota).

### 4.2 Database Remoto: Supabase (Cloud)

- **`auth.users`** (tabella di sistema Supabase): gestisce registrazione e autenticazione (email, password hash, JWT, `user_id`).
- **`profiles`**: dati estesi del profilo (nome, URL immagine profilo, preferenze). `id` è chiave esterna verso `auth.users.id`.
- **`exercises`**: catalogo globale degli esercizi, sola lettura.
- **`schede`**: schede di allenamento, associate all'utente tramite `user_id`.
- **`esercizi_programmati`** **[NUOVO]**: esercizi contenuti in ciascuna scheda. È la tabella che lega `schede` a `exercises` e che rende possibile il download lazy.
- **`allenamenti`** **[NUOVO]**: storico degli allenamenti svolti (alimenta riepilogo, calendario e grafici).
- **`serie_eseguite`** **[NUOVO]**: dettaglio di ogni serie svolta in un allenamento.

#### Schema indicativo **[NUOVO]**

```text
auth.users (id)
   |-- 1:1 --> profiles (id, nome, foto_url, updated_at)
   |-- 1:N --> schede (id, user_id, titolo, created_at, updated_at, deleted_at)
   |               '-- 1:N --> esercizi_programmati (id, scheda_id, exercise_id, ordine,
   |                                                  serie, ripetizioni, recupero_sec,
   |                                                  updated_at, deleted_at)
   '-- 1:N --> allenamenti (id, user_id, scheda_id?, scheda_titolo, iniziato_at,
                            terminato_at, durata_sec)
                   '-- 1:N --> serie_eseguite (id, allenamento_id, exercise_id,
                                               numero_serie, ripetizioni, peso_kg)

exercises (id, name, category, body_part, equipment, target, muscle_group,
           secondary_muscles, instruction_steps, media_id, image_path, gif_path, attribution)
```

Note di progetto:
- `esercizi_programmati.exercise_id` è chiave esterna verso `exercises.id`. I campi `serie`, `ripetizioni`, `recupero_sec` sono un esempio: vanno allineati ai campi di `EsercizioProgrammato`.
- `allenamenti.scheda_titolo` è una **copia (snapshot)**: se la scheda viene rinominata o eliminata, lo storico resta leggibile. Per lo stesso motivo `scheda_id` è opzionale.
- `deleted_at` implementa la **cancellazione logica**, necessaria per propagare le eliminazioni tra dispositivi durante la sync.
- `updated_at` va aggiornato lato server (trigger), non dal client, per evitare problemi di orologio dei dispositivi.

### 4.3 Database Locale: SQLite (Device)

- **`profilo`**: copia locale dei dati dell'utente attivo.
- **`schede`**: schede dell'utente autenticato, per consultazione e uso offline.
- **`esercizi_programmati`** **[NUOVO]**: esercizi di ogni scheda, con una **copia dei dati essenziali** dell'esercizio (`nome`, `image_path`, `body_part`) in modo che la scheda si apra subito, anche offline.
- **`esercizi_cache`** **[NUOVO]**: dettagli completi degli esercizi già scaricati (istruzioni, GIF, muscoli secondari). Si popola con il download lazy e ha valore di cache.
- **`allenamenti`** e **`serie_eseguite`** **[NUOVO]**: storico locale, anche degli allenamenti non ancora sincronizzati.

Le tabelle locali modificabili dall'utente (`schede`, `esercizi_programmati`, `allenamenti`, `serie_eseguite`) hanno due colonne aggiuntive **[NUOVO]**:

| Colonna | Scopo |
|---|---|
| `user_id` | Separa i dati di utenti diversi sullo stesso dispositivo |
| `sync_state` | `synced`, `pending_upsert`, `pending_delete`: cosa va ancora inviato al server |

---

## 5. Sicurezza **[NUOVO]**

- **Row Level Security (RLS) attiva su tutte le tabelle.** Policy minime:
  - `exercises`: `SELECT` pubblico, nessuna scrittura.
  - `profiles`, `schede`, `allenamenti`: l'utente accede solo alle righe con `user_id = auth.uid()` (per `profiles`, `id = auth.uid()`).
  - `esercizi_programmati` e `serie_eseguite`: accessibili solo se la riga padre appartiene all'utente.
- **Chiavi:** nell'app va solo la `anon key`. La `service_role` key **non deve mai** comparire nell'app né nel repository.
- **Sessione:** gestita da `supabase_flutter` (token di accesso + refresh token, rinnovo automatico).
- **Password:** mai salvate localmente.
- **Dati locali:** SQLite non è cifrato di default. Per dati di allenamento il rischio è basso; se in futuro si memorizzano dati sanitari, valutare la cifratura del DB.
- **Privacy / GDPR:** scegliere una regione UE per il progetto Supabase, prevedere informativa privacy e funzione di **cancellazione account** (richiesta anche dagli store).

---

## 6. Flussi Operativi e Logica di Business

### 6.1 Primo avvio ed autenticazione
1. **Richiesta credenziali**: alla prima apertura su un nuovo dispositivo la UI mostra la schermata di login (*Email* e *Password*).
2. **Verifica Supabase Auth**: l'app invia le credenziali all'endpoint di autenticazione; in caso di successo riceve una sessione con token valido e `user_id`.
3. **Errori** **[NUOVO]**: credenziali errate, email non confermata, assenza di rete e timeout producono messaggi distinti e non fanno entrare l'utente.
4. **Download e popolamento dati iniziali**:
   - **Profilo**: lettura da `profiles` e salvataggio nella tabella locale `profilo`.
   - **Schede**: query delle sole schede dell'utente (`WHERE user_id = current_user_id`, escluse quelle con `deleted_at`).
   - **Esercizi programmati** **[NUOVO]**: scaricati insieme alle schede (sono righe leggere, con solo l'`exercise_id`), così le schede sono complete offline. Insieme alle righe si salva la copia di `nome`, `image_path` e `body_part`, ottenuta con un unico join sul catalogo.
   - **Storico** **[NUOVO]**: scaricati gli ultimi N allenamenti (es. ultimi 90 giorni) per riepilogo e grafici; il resto su richiesta.
   - **Salvataggio locale** nelle tabelle SQLite.

### 6.2 Avvio successivo (utente già autenticato) **[NUOVO]**
1. All'avvio, `Supabase.initialize(...)` ripristina la sessione salvata.
2. L'`AuthWrapper` controlla la sessione:
   - sessione presente → apre direttamente la schermata principale, **senza nuovo login**;
   - nessuna sessione → mostra il login.
3. L'interfaccia viene popolata **subito dai dati locali**, senza attendere la rete.
4. In background, se c'è connessione, parte la sincronizzazione (vedi 6.4).
5. **Avvio offline:** se il rinnovo del token fallisce per assenza di rete, l'utente **resta dentro** e usa i dati locali. Viene richiesto un nuovo login solo se il server rifiuta esplicitamente il refresh token (sessione revocata o scaduta).

### 6.3 Strategia di Download Lazy (On-Demand) degli Esercizi
Per ottimizzare i tempi di primo caricamento e ridurre l'uso di rete e spazio:
- I dettagli dei singoli esercizi non vengono scaricati durante il login.
- La lista delle schede e l'apertura di una scheda usano i dati essenziali già presenti in locale (**[NUOVO]** quindi non richiedono rete).
- **Download lazy** dalla tabella remota `exercises`, solo quando l'utente:
  1. apre il **dettaglio di un esercizio** (istruzioni, GIF, muscoli secondari);
  2. avvia una **sessione di allenamento** (**[NUOVO]** si scaricano in un'unica query `IN (...)` i dettagli degli esercizi della scheda non ancora in cache);
  3. sfoglia il **catalogo** per aggiungere esercizi a una scheda (**[NUOVO]** lista paginata a 20 elementi, con ricerca e filtri, senza istruzioni).
- **Cache** **[NUOVO]**: i dettagli scaricati vengono salvati in `esercizi_cache`. Il catalogo è statico, quindi la cache non scade.
- **Contenuto non disponibile offline** **[NUOVO]**: se un dettaglio non è in cache e manca la rete, la UI mostra un messaggio chiaro e usa solo i dati essenziali (nome, miniatura).

### 6.4 Sincronizzazione **[NUOVO]**
**Quando parte:**
- dopo il login;
- all'avvio dell'app e quando torna in primo piano (se online);
- dopo ogni modifica locale (se online);
- su richiesta dell'utente (pull-to-refresh);
- al ritorno della connessione.

**Come funziona (per ogni tabella sincronizzata):**
1. **Push**: l'app invia le righe locali con `sync_state` = `pending_upsert` o `pending_delete`. Se l'invio riesce, le segna `synced`; se fallisce, restano in coda e riprovano alla sync successiva.
2. **Pull**: scarica le righe remote con `updated_at` maggiore dell'ultima sync (l'ultimo timestamp è salvato in locale, per tabella e utente) e le applica al DB locale.
3. **Conflitti**: vince la modifica con `updated_at` più recente (D5).
4. **Eliminazioni**: sono logiche (`deleted_at`); la riga viene rimossa fisicamente dal locale dopo la sync.

### 6.5 Creazione e modifica di una scheda **[NUOVO]**
1. L'utente crea o modifica una scheda: il salvataggio avviene **prima in SQLite**, con UUID generato sul dispositivo e `sync_state = pending_upsert`.
2. L'interfaccia si aggiorna immediatamente.
3. Se online, parte subito il push; altrimenti la modifica resta in coda.
4. Per aggiungere un esercizio: scelta dal catalogo (6.3, punto 3); la riga `esercizi_programmati` viene salvata con la copia di `nome`, `image_path`, `body_part`.

### 6.6 Svolgimento dell'allenamento e storico **[NUOVO]**
1. All'avvio dell'allenamento si scaricano i dettagli mancanti (6.3, punto 2). Se non c'è rete e un dettaglio non è in cache, si può comunque procedere con i dati essenziali.
2. Durante l'allenamento nessuna chiamata di rete: tutto è in memoria e in locale.
3. Alla fine, l'allenamento e le sue serie vengono salvati in SQLite (`pending_upsert`) e sincronizzati appena possibile.
4. Riepilogo, calendario e grafici leggono **solo dal DB locale**.

### 6.7 Logout e cambio utente **[NUOVO]**
1. Se esistono modifiche non sincronizzate (`sync_state` diverso da `synced`), l'app avvisa l'utente e tenta una sync prima di procedere.
2. Esegue `signOut()` su Supabase.
3. Cancella i dati locali dell'utente (profilo, schede, storico, cache) per evitare che un altro utente sullo stesso dispositivo li veda.
4. Torna alla schermata di login.

### 6.8 Registrazione, recupero password ed eliminazione account **[NUOVO]**
- **Registrazione:** `signUp` con email e password; decidere se è richiesta la conferma email. Alla creazione dell'utente un trigger sul database crea la riga corrispondente in `profiles`.
- **Recupero password:** email di reset inviata da Supabase Auth.
- **Eliminazione account:** funzione dedicata che cancella `auth.users` e, a cascata, tutti i dati collegati.

### 6.9 Gestione di errori e rete **[NUOVO]**
- Ogni chiamata remota ha timeout e gestione delle eccezioni nel repository; la UI riceve esiti chiari (successo, offline, errore server).
- Gli errori di sync **non bloccano mai l'uso dell'app**: restano in coda e vengono ritentati.
- L'app non mostra schermate vuote per assenza di rete finché esistono dati locali.

---

## 7. Gestione dei media **[NUOVO]**

- Nel DB sono salvati **percorsi relativi** (`image_path`, `gif_path`); l'URL completo si compone con un unico `mediaBaseUrl` definito in un solo punto del codice.
- **Prototipo:** i file sono letti da GitHub raw. **Produzione:** bucket pubblico di Supabase Storage (o CDN).
- Miniature (JPG) nelle liste, **GIF solo nel dettaglio**.
- Cache su disco con `cached_network_image`: ogni immagine è scaricata una sola volta.
- **Foto profilo:** salvata in un bucket Storage dedicato con policy per utente; il DB conserva l'URL. (Oggi nell'app è un percorso file locale: va migrata.)
- **Licenza:** immagini e GIF sono © Gym visual. Prima di ridistribuirle dal proprio storage in un'app commerciale verificare i termini di licenza e mostrare l'attribuzione nella schermata Crediti.

---

## 8. Diagramma del Flusso di Autenticazione e Sync (sintesi)

```text
[Avvio app]
     |
     v
[Sessione salvata?] --no--> [Login] --> [Supabase Auth] --errore--> [Errore UI]
     |                                        |
    sì                                    successo
     |                                        |
     |                      [Scarica profilo, schede, esercizi programmati, storico]
     |                                        |
     v                                        v
[UI da dati locali SQLite] <------------ [Salva in SQLite]
     |
     +--> (se online) [Sync: push pending -> pull novità]
     |
     +--> [Click dettaglio esercizio / Avvio allenamento]
               |
               +--> in cache? --sì--> mostra
               |
               +--> no --> [Lazy load da 'exercises'] --> [Salva in esercizi_cache] --> mostra
```

---

## 9. Requisiti Non Funzionali

- **Prestazioni:** la UI si popola dai dati locali; login e schermata iniziale non attendono il catalogo. Liste paginate (20 elementi).
- **Disponibilità offline:** dopo il primo avvio, consultazione di schede, creazione di nuove schede e registrazione degli allenamenti funzionano senza rete. I dettagli non ancora in cache non sono disponibili offline.
- **Affidabilità** **[NUOVO]**: nessuna perdita di dati per modifiche fatte offline (coda `pending_*`).
- **Sicurezza** **[NUOVO]**: vedi sezione 5.
- **Consumo dati** **[NUOVO]**: immagini in cache, GIF scaricate solo nel dettaglio, niente download del catalogo completo.
- **Manutenibilità** **[NUOVO]**: accesso ai dati solo tramite repository; un solo punto per URL media e credenziali.

---

## 10. Versionamento e migrazioni **[NUOVO]**

- **SQLite:** usare `version` e `onUpgrade` di `sqflite` per ogni modifica dello schema locale; ogni release che cambia le tabelle incrementa la versione.
- **Migrazione dall'app attuale:** gli utenti e le schede già salvati nel database locale esistente vanno importati (o l'utente rieffettua il login e riscarica i dati). Da decidere se esistono dati reali da preservare.
- **Supabase:** tenere gli script SQL (tabelle, indici, policy, trigger) in file versionati nel repository.

---

## 11. Questioni aperte **[NUOVO]**

1. **Chi crea le schede?** Solo l'utente, oppure anche un trainer che le assegna ai clienti? Nel secondo caso servono ruoli (`cliente` / `trainer`) e policy RLS diverse.
2. **Registrazione:** autonoma dall'app, o account creati dalla palestra?
3. **Conferma email** obbligatoria?
4. **Lingua:** istruzioni in italiano e inglese (già nel DB); nomi, categorie ed equipaggiamento solo in inglese, serve una mappa di traduzione lato app?
5. **Storico:** quanti mesi tenere in locale?
6. **Dati già esistenti** nell'app attuale da migrare?
