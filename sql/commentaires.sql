-- =============================================================================
-- PARTIE A · Questions 1 et 2 · La table des commentaires
-- A executer dans la base ateliers, APRES db/ateliers.sql.
-- =============================================================================

-- Le script doit pouvoir etre relance : on commence par effacer la table.
DROP TABLE IF EXISTS commentaires;

-- QUESTION 1 · Ecrire le CREATE TABLE commentaires.
-- Les colonnes (memes noms que dans data/commentaires.initial.json) :
--   id          un entier attribue par la base, cle primaire
--   article_id  l'article commente : obligatoire, et forcement un article qui existe
--   nom         le nom du visiteur, obligatoire
--   texte       obligatoire, et pas une chaine vide
--   cree_le     la date et l'heure du commentaire ; par defaut, maintenant
-- Et une regle : quand un article est supprime, ses commentaires disparaissent avec lui.

CREATE TABLE commentaires (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  article_id INT NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  nom TEXT NOT NULL,
  texte TEXT NOT NULL CHECK (texte <> ''),
  cree_le TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


-- QUESTION 2 · Inserer les huit commentaires de data/commentaires.initial.json.
-- Ne donnez PAS les id : la base les attribue. Les dates sont en UTC (le Z final).
INSERT INTO commentaires (article_id, nom, texte, cree_le) VALUES
  (1, 'Claire', 'Et pour le robinier, vous conseillez quoi ?',                  '2026-09-03 08:12:00+00'),
  (1, 'Paul',   'Ma table en pin a tenu deux hivers, pas trois.',               '2026-09-04 16:40:00+00'),
  (1, 'Nadia',  'Article clair, merci.',                                        '2026-09-10 06:05:00+00'),
  (2, 'Hugo',   'Le noyer est magnifique. Combien de temps pour le séchage ?',  '2026-09-17 10:30:00+00'),
  (2, 'Inès',   'Des photos de la pose seraient les bienvenues.',               '2026-09-20 19:15:00+00'),
  (4, 'Lucie',  'J''ai une chaise à faire refaire, vous prenez les commandes ?', '2026-10-09 07:00:00+00'),
  (5, 'Claire', 'Aucune vis visible : comment sont fixés les caissons ?',       '2026-10-16 12:22:00+00'),
  (5, 'Karim',  'Superbe travail.',                                             '2026-10-18 17:47:00+00');


