// SERVICE des commentaires · VERSION FICHIER JSON (celle de depart).
// Elle respecte le contrat (CONTRAT.md) : le cote API peut s'en servir tout de suite pour tester
// ses routes. Le cote base la remplace par une version PostgreSQL, avec les MEMES fonctions.
// Les articles, eux, sont deja dans PostgreSQL (services/articles.service.js).

const pool = require('../db/pool');
const ErreurHttp = require('../utils/erreur-http');

const articleIntrouvable = (id) =>
  new ErreurHttp(404, 'ARTICLE_INTROUVABLE', `L'article ${id} n'existe pas.`);
const introuvable = (id) =>
  new ErreurHttp(404, 'COMMENTAIRE_INTROUVABLE', `Le commentaire ${id} n'existe pas.`);

// Les commentaires d'un article, du plus ancien au plus récent
async function lister(articleId) {
  if (!Number.isInteger(articleId)) throw articleIntrouvable(articleId);

  // 1re requête : l'article existe-t-il ?
  const article = await pool.query('SELECT id FROM articles WHERE id = $1', [articleId]);
  if (article.rowCount === 0) throw articleIntrouvable(articleId);

  // 2e requête : ses commentaires
  const resultat = await pool.query(
    'SELECT id, article_id, nom, texte, cree_le FROM commentaires WHERE article_id = $1 ORDER BY cree_le',
    [articleId],
  );
  return resultat.rows;
}

// Un commentaire par son id
async function trouver(id) {
  if (!Number.isInteger(id)) throw introuvable(id);
  const resultat = await pool.query(
    'SELECT id, article_id, nom, texte, cree_le FROM commentaires WHERE id = $1',
    [id],
  );
  if (resultat.rowCount === 0) throw introuvable(id);
  return resultat.rows[0];
}

// Les commentaires d'un visiteur, du plus récent au plus ancien, avec le titre de l'article
async function parVisiteur(nom) {
  const resultat = await pool.query(
    `SELECT c.id, c.article_id, a.titre, c.nom, c.texte, c.cree_le
     FROM commentaires c
     JOIN articles a ON a.id = c.article_id
     WHERE c.nom = $1
     ORDER BY c.cree_le DESC`,
    [nom],
  );
  return resultat.rows;
}

// Ajouter un commentaire. Si l'article n'existe pas, la base refuse (code 23503) : on en fait une 404.
async function creer(articleId, { nom, texte }) {
  if (!Number.isInteger(articleId)) throw articleIntrouvable(articleId);
  try {
    const resultat = await pool.query(
      `INSERT INTO commentaires (article_id, nom, texte)
       VALUES ($1, $2, $3)
       RETURNING id, article_id, nom, texte, cree_le`,
      [articleId, nom, texte],
    );
    return resultat.rows[0];
  } catch (err) {
    if (err.code === '23503') throw articleIntrouvable(articleId);
    throw err;
  }
}

// Modifier le texte d'un commentaire
async function modifier(id, { texte }) {
  if (!Number.isInteger(id)) throw introuvable(id);
  const resultat = await pool.query(
    `UPDATE commentaires SET texte = $2 WHERE id = $1
     RETURNING id, article_id, nom, texte, cree_le`,
    [id, texte],
  );
  if (resultat.rowCount === 0) throw introuvable(id);
  return resultat.rows[0];
}

// Supprimer un commentaire
async function supprimer(id) {
  if (!Number.isInteger(id)) throw introuvable(id);
  const resultat = await pool.query('DELETE FROM commentaires WHERE id = $1', [id]);
  if (resultat.rowCount === 0) throw introuvable(id);
}

module.exports = { lister, trouver, parVisiteur, creer, modifier, supprimer };