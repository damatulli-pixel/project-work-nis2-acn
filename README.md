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
