-- 04_views_export.sql
-- Vista tabellare/CSV e vista JSON.

CREATE OR REPLACE VIEW Vista_Profilo_ACN AS
SELECT
    az.ragione_sociale AS "Organizzazione",
    sc.nome_servizio AS "Servizio Essenziale",
    sc.livello_criticita AS "Rischio Servizio",
    a.nome_asset AS "Apparato/Asset",
    a.stato AS "Stato Operativo",
    ft.nome_fornitore AS "Dipendenza Supply Chain",
    af.livello_dipendenza AS "Criticita Fornitore",
    c.nome_cognome AS "Punto di Contatto",
    c.ruolo_nis2 AS "Ruolo",
    c.email AS "Email"
FROM Azienda az
JOIN Servizio_Critico sc
    ON az.id_azienda = sc.id_azienda
JOIN Asset_Servizio asrv
    ON sc.id_servizio = asrv.id_servizio
JOIN Asset a
    ON asrv.id_asset = a.id_asset
LEFT JOIN Asset_Fornitore af
    ON a.id_asset = af.id_asset
LEFT JOIN Fornitore_Terzo ft
    ON af.id_fornitore = ft.id_fornitore
LEFT JOIN Contatto c
    ON az.id_azienda = c.id_azienda;

CREATE OR REPLACE VIEW Vista_Profilo_ACN_JSON AS
SELECT json_agg(row_to_json(profilo)) AS payload_istituzionale
FROM (
    SELECT
        az.ragione_sociale AS organizzazione,
        sc.nome_servizio AS servizio_essenziale,
        a.nome_asset AS apparato,
        a.stato AS stato_operativo,
        ft.nome_fornitore AS gestore_esterno,
        c.nome_cognome AS punto_contatto,
        c.ruolo_nis2 AS ruolo,
        c.email AS email
    FROM Azienda az
    JOIN Servizio_Critico sc
        ON az.id_azienda = sc.id_azienda
    JOIN Asset_Servizio asrv
        ON sc.id_servizio = asrv.id_servizio
    JOIN Asset a
        ON asrv.id_asset = a.id_asset
    LEFT JOIN Asset_Fornitore af
        ON a.id_asset = af.id_asset
    LEFT JOIN Fornitore_Terzo ft
        ON af.id_fornitore = ft.id_fornitore
    LEFT JOIN Contatto c
        ON az.id_azienda = c.id_azienda
) profilo;

-- Query da eseguire in pgAdmin per l'output tabellare:
SELECT * FROM Vista_Profilo_ACN;

-- Query da eseguire in pgAdmin per il JSON:
SELECT jsonb_pretty(payload_istituzionale::jsonb)
FROM Vista_Profilo_ACN_JSON;
