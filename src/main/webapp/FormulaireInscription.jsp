<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="FormulaireInscription.css">
    <title>Page d'inscription</title>
</head>
<body>
<div class="container">
    <div class="left">
        <div class="subtitle"><h2>Vous êtes les Bienvenues!</h2></div>
        <img src="images/ess.png" alt="Illustration" class="illustration">
    </div>
    <div class="right">
        <img src="images/RESIDETICON.png" alt="Résidence Icon">
        <form action="InscriptionServlet" method="post" enctype="multipart/form-data">
            <!-- Ligne 1 : Nom et Prénom -->
            <div class="form-row">
                <div class="form-group">
                    <label for="nom">Nom</label>
                    <input type="text" id="nom" name="nom" placeholder="Entrez votre nom" required>
                </div>
                <div class="form-group">
                    <label for="prenom">Prénom</label>
                    <input type="text" id="prenom" name="prenom" placeholder="Entrez votre prénom" required>
                </div>
            </div>

            <!-- Ligne 2 : Email et Téléphone -->
            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Entrez votre email" required>
                </div>
                <div class="form-group">
                    <label for="telephone">Téléphone</label>
                    <input type="text" id="telephone" name="telephone" placeholder="Entrez votre numéro de téléphone" required>
                </div>
            </div>

            <!-- Ligne 3 : Mot de passe -->
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" placeholder="Entrez votre mot de passe" required>
                </div>
                <div class="form-group">
                    <label for="confirm">Confirmer</label>
                    <input type="password" id="confirm" name="confirm" placeholder="Confirmer votre mot de passe" required>
                </div>
            </div>

            <!-- Ligne 4 : CNE -->
            <div class="form-group">
                <label for="cne">CNE</label>
                <input type="text" id="cne" name="cne" placeholder="Entrez votre numéro CNE" required>
            </div>

            <!-- Ligne 5 : Carte Étudiante -->
            <div class="form-group file-upload">
                <label for="carte-etudiante">Carte Étudiante</label>
                <input type="file" id="carte-etudiante" name="carte_etudiante" required>
            </div>

            <!-- Bouton -->
            <div class="form-group">
                <button type="submit">Inscription</button>
            </div>
            <p class="footer-text">                Vous avez déjà un compte?<a href="FormulaireConnexion.jsp"> Connectez-vous           </a></p>
        </form>
    </div>
</div>
</body>
</html>