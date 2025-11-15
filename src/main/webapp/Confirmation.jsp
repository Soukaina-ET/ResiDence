<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="AffichageAdmin.css">
    <title>Page de confirmation d'inscription</title>
</head>
<body>
<div class="page1">
    <div class="container1">
        <%
            // Récupérer les messages de succès ou d'erreur
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");

            if (successMessage != null) {
        %>
        <div class="error-box">
            <img src="images/confirmation.png" alt="Confirmation" class="error-image">
            <p class="error-message"> <%= successMessage %> </p>
            <button onclick="window.location.href='index.jsp'" class="back-button">Retour à la page d'accueil</button>
        </div>
        <%
        } else if (errorMessage != null) {
        %>
        <div class="error-box">
            <img src="images/rejet.png" alt="Rejet" class="error-image">
            <p class="error-message"><%= errorMessage %> .</p>
            <button onclick="window.location.href='FormulaireInscription.jsp'" class="back-button">Retour à la page d'inscription</button>
        </div>
        <%
        } else {
        %>
        <div class="error-box">
            <img src="images/404.png" alt="Erreur 404" class="error-image">
            <p class="error-message">Il y a une erreur.</p>
            <button onclick="window.location.href='FormulaireInscription.jsp'" class="back-button">Retour à la page d'inscription</button>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>