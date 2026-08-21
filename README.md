# Project Work NIS2 / ACN

Progetto sviluppato nell'ambito del corso di laurea in Informatica per le Aziende Digitali (L-31).

## Titolo

**Progettazione e implementazione di un Database Relazionale per la conformità NIS2: gestione di asset, servizi e supply chain secondo le linee guida ACN**

## Obiettivo

Il progetto realizza un database relazionale PostgreSQL per catalogare:

- asset IT e OT;
- servizi critici;
- dipendenze da fornitori terzi;
- punti di contatto e responsabilità organizzative;
- storico delle modifiche.

L'obiettivo è supportare la raccolta e l'esportazione strutturata delle informazioni utili alla predisposizione dei profili richiesti dall'ACN nell'ambito della Direttiva NIS2.

## Tecnologie utilizzate

- PostgreSQL 15+
- SQL
- PL/pgSQL
- pgAdmin
- Modello relazionale normalizzato in Terza Forma Normale (3NF)

## Struttura del repository

```text
project-work-nis2-acn/
├── sql/
│   ├── 01_schema.sql
│   ├── 02_dataset.sql
│   ├── 03_trigger_history.sql
│   ├── 04_views_export.sql
│   ├── 05_indexes_roles.sql
│   └── 06_tests.sql
├── output/
│   ├── profilo_acn.csv
│   └── profilo_acn.json
└── docs/
    └── documentazione_tecnica.pdf
```
## Script SQL

01_schema.sql

Creazione delle tabelle, chiavi primarie, chiavi esterne e vincoli di integrità.

02_dataset.sql

Popolamento del database con un dataset simulato utilizzato per il collaudo.

03_trigger_history.sql

Trigger e funzione PL/pgSQL per la storicizzazione delle modifiche degli asset.

04_views_export.sql

Creazione delle viste:

Vista_Profilo_ACN
Vista_Profilo_ACN_JSON

utilizzate per produrre output strutturati destinati alla reportistica.

05_indexes_roles.sql

Creazione degli indici, procedura di data retention e ruoli RBAC.

06_tests.sql

Test di:

integrità referenziale;
unicità delle relazioni;
storicizzazione;
generazione delle viste;
output finale.
Output

## Output

La cartella `output` contiene:

- `profilo_acn.csv`, output principale del prototipo;
- `profilo_acn.json`, esempio aggiuntivo di interoperabilità applicativa.

## Validazione

Il progetto è stato validato end-to-end su un database PostgreSQL vuoto.

Sono stati verificati con esito positivo:

- creazione dello schema;
- caricamento del dataset;
- trigger di storicizzazione;
- viste ACN e JSON;
- indici;
- ruoli RBAC;
- vincoli di foreign key;
- chiave primaria composta;
- registrazione dello stato precedente in `Asset_History`.

Il dataset utilizzato è simulato e non contiene dati riferiti a infrastrutture reali.

## Ordine di esecuzione


Gli script devono essere eseguiti nell'ordine seguente:

```text
01_schema.sql
02_dataset.sql
03_trigger_history.sql
04_views_export.sql
05_indexes_roles.sql
06_tests.sql
```

## Documentazione

La documentazione tecnica completa è disponibile nella cartella `docs`.

Il Project Work principale descrive il modello concettuale, le scelte di normalizzazione, i trade-off progettuali, gli aspetti di sicurezza e le modalità di utilizzo del database nell'ambito NIS2/ACN.

## Nota

Il database costituisce un prototipo a supporto della gestione strutturata delle informazioni. Non rappresenta da solo una soluzione completa di conformità NIS2, che richiede anche misure organizzative, procedurali e tecniche ulteriori.
output/
sql/
README.md
