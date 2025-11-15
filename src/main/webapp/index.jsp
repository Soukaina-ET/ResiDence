<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RESIDET</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
<!-- En-tête -->
<header>
    <nav class="navbar">
        <img src="images/Residetblancicone.png" alt="Logo RESIDET" class="logo">
        <ul>
            <li><a href="#">Accueil</a></li>
            <li><a href="#">À propos</a></li>
            <li><a href="#">Fonctionnalités</a></li>
            <li><a href="#">Contact</a></li>
        </ul>
        <div class="buttons">
            <a href="loginAdmin.html" class="btn btn-login">Connexion</a>
            <a href="FormulaireInscription.jsp" class="btn btn-register">Inscription</a>
        </div>
    </nav>
    <section class="hero">
        <div class="hero-content">
            <h1>Simplifiez votre vie en résidence !<br> Avec <span>RESIDET</span></h1>
            <p>Inscrivez-vous dès aujourd'hui et découvrez comment nous vous facilitons le quotidien en résidence.</p>
            <a href="FormulaireInscription.jsp" class="btn btn-primary">Inscrivez-vous maintenant !</a>
        </div>
        <div class="hero-image">
            <img src="images/j.png" alt="Illustration résidence">
        </div>
    </section>
</header>

<!-- Section Gestion de résidence -->
<section class="section">
    <h2>Gestion de résidence</h2>
    <p>Gérez chambres, étudiants et services facilement grâce à notre interface conviviale.</p>
    <img src="images/chambre.jpg" alt="Plan des chambres" class="section-img">
    <a href="FormulaireInscription.jsp" class="btn btn-secondary">Commencez ici</a>
</section>

<!-- Section Communauté -->
<section class="section communauté">
    <h2>Communauté</h2>
    <p>Restez en contact et communiquez facilement avec les résidents de votre résidence.</p>
    <a href="FormulaireInscription.jsp" class="btn btn-secondary">En savoir plus</a>
</section>

<!-- Section Paiement -->
<section class="section">
    <h2>Paiement</h2>
    <p>Simplifiez les paiements des loyers et services via notre plateforme sécurisée.</p>
    <img src="images/pay.png" alt="Paiement en ligne" class="section-img">
    <a href="FormulaireInscription.jsp" class="btn btn-secondary">Commencez ici</a>
</section>

<!-- Section Maintenance -->
<section class="section">
    <h2>Facile Maintenance</h2>
    <p>Signalez des incidents et suivez l'avancement des réparations rapidement et efficacement.</p>
    <img src="images/maintenance.jpg" alt="Illustration Maintenance" class="section-img">
    <a href="FormulaireInscription.jsp" class="btn btn-secondary">Lancez-vous</a>
</section>

<!-- Pied de page -->
<footer>
    <p>"Inscrivez-vous dès aujourd'hui pour bénéficier d'une interface conviviale et moderne."</p>
</footer>
</body>
</html>