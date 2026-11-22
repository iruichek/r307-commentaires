-- =============================================================================
-- PARTIE A · Question 3 · Six requetes
-- Sous chaque question : votre requete, puis le resultat obtenu, en commentaire.
-- =============================================================================

-- R1. Les commentaires de l'article 2, du plus recent au plus ancien : nom, texte.
SELECT nom, texte
FROM commentaires
WHERE article_id = 2
ORDER BY cree_le DESC;
-- Résultat
-- Inès | Des photos de la pose seraient les bienvenues.
-- Hugo | Le noyer est magnifique. Combien de temps pour le séchage ?


-- R2. Le nombre de commentaires de CHAQUE article, y compris ceux qui n'en ont aucun :
--     id, titre, nb_commentaires.

SELECT a.id, a.titre, COUNT(c.id) AS nb_commentaires
FROM articles a
LEFT JOIN commentaires c ON c.article_id = a.id
GROUP BY a.id, a.titre
ORDER BY a.id;
-- Résultat
-- 1 | Choisir son bois pour une table de jardin   | 3
-- 2 | Une bibliothèque sur mesure à Besançon      | 2
-- 3 | Huile ou vernis : ce qui protège vraiment   | 0
-- 4 | Restaurer une chaise paillée                | 1
-- 5 | Une cuisine en chêne massif à Dole          | 2
-- 6 | Affûter ses ciseaux à bois                  | 0


-- R3. Les articles qui n'ont aucun commentaire : id, titre.
SELECT a.id, a.titre
FROM articles a
WHERE NOT EXISTS (
  SELECT 1 FROM commentaires c WHERE c.article_id = a.id
);
-- Résultat
-- 3 | Huile ou vernis : ce qui protège vraiment
-- 6 | Affûter ses ciseaux à bois


-- R4. Pour chaque auteur, le nombre total de commentaires recus sur ses articles,
--     du plus commente au moins commente.

SELECT au.prenom AS auteur, COUNT(c.id) AS nb_commentaires
FROM commentaires c
JOIN articles a  ON a.id  = c.article_id
JOIN auteurs  au ON au.id = a.auteur_id
GROUP BY au.id, au.prenom
ORDER BY nb_commentaires DESC;
-- Résultat
-- Marc   | 5
-- Théo   | 2
-- Sophie | 1



-- R5. Les visiteurs (nom) qui ont commente plus d'un article.

SELECT nom, COUNT(DISTINCT article_id) AS nb_articles
FROM commentaires
GROUP BY nom
HAVING COUNT(DISTINCT article_id) > 1;
-- Résultat
-- Claire | 2

-- R6. Les trois commentaires les plus recents, avec le titre de leur article.
SELECT c.nom, c.texte, c.cree_le, a.titre
FROM commentaires c
JOIN articles a ON a.id = c.article_id
ORDER BY c.cree_le DESC
LIMIT 3;
-- Résultat
-- Karim  | Superbe travail.                                                | 2026-10-18 17:47:00+00 | Une cuisine en chêne massif à Dole
-- Claire | Aucune vis visible : comment sont fixés les caissons ?          | 2026-10-16 12:22:00+00 | Une cuisine en chêne massif à Dole
-- Lucie  | J'ai une chaise à faire refaire, vous prenez les commandes ?    | 2026-10-09 07:00:00+00 | Restaurer une chaise paillée


















