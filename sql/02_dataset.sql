-- 02_dataset.sql
-- Dataset simulato. Gli ID non vengono forzati manualmente,
-- così le sequence SERIAL rimangono sincronizzate.

INSERT INTO Azienda (ragione_sociale, partita_iva, settore_nis2)
VALUES (
    'Industria Meccanica di Precisione S.p.A.',
    'IT12345678901',
    'Fabbricazione macchinari'
);

INSERT INTO Contatto (id_azienda, nome_cognome, ruolo_nis2, email, telefono)
SELECT
    id_azienda,
    'Mario Rossi',
    'CISO - Chief Information Security Officer',
    'm.rossi@industriameccanica.it',
    '+393331234567'
FROM Azienda
WHERE partita_iva = 'IT12345678901';

INSERT INTO Servizio_Critico (id_azienda, nome_servizio, livello_criticita)
SELECT
    id_azienda,
    'Controllo Qualità Telemetrico e Produzione CNC',
    'Critico'
FROM Azienda
WHERE partita_iva = 'IT12345678901';

INSERT INTO Asset (id_azienda, nome_asset, tipologia, stato)
SELECT id_azienda, 'Server Cluster SCADA', 'Hardware/OT', 'Attivo'
FROM Azienda
WHERE partita_iva = 'IT12345678901';

INSERT INTO Asset (id_azienda, nome_asset, tipologia, stato)
SELECT id_azienda, 'Firewall Perimetrale Reparto', 'Network', 'Attivo'
FROM Azienda
WHERE partita_iva = 'IT12345678901';

INSERT INTO Fornitore_Terzo (nome_fornitore, tipologia_fornitura)
VALUES ('SecureNet IT S.r.l.', 'Manutenzione Rete');

INSERT INTO Asset_Servizio (id_asset, id_servizio)
SELECT a.id_asset, s.id_servizio
FROM Asset a
JOIN Servizio_Critico s
  ON s.nome_servizio = 'Controllo Qualità Telemetrico e Produzione CNC'
WHERE a.nome_asset IN ('Server Cluster SCADA', 'Firewall Perimetrale Reparto');

INSERT INTO Asset_Fornitore (id_asset, id_fornitore, livello_dipendenza)
SELECT a.id_asset, f.id_fornitore, 'Critico'
FROM Asset a
CROSS JOIN Fornitore_Terzo f
WHERE a.nome_asset = 'Firewall Perimetrale Reparto'
  AND f.nome_fornitore = 'SecureNet IT S.r.l.';
