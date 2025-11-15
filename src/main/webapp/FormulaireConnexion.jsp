<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Page de connexion</title>
  <link rel="stylesheet" type="text/css" href="loginAdmin.css">
</head>
<body>
<div class="container">
  <div class="left-rectangle">
    <img src="images/RESIDETICON.png" alt="Illustration1" class="illustration1">
    <p class="subtitle">Heureux de vous revoir Resident😃 </p>
    <form method="post" action="ResidentLogin">
      <input type="email" placeholder="Entrez votre adresse email" class="input-field" name="email">
      <input type="password" placeholder="Entrez votre mot de passe" class="input-field" name="password">
      <button type="submit" class="btn">Se connecter</button>
      <button type="button" class="google-btn"><img src="images/google.png" alt="Google Logo">Connexion par Google</button>
    </form>
    <p class="footer-text">                  Vous n'avez pas de compte ?<a href="FormulaireInscription.jsp"> Inscrivez-vous               </a></p>
  </div>
  <div class="right-rectangle">
    <h2>Vous êtes les Bienvenues!</h2>
    <img src="images/o.png" alt="Illustration" class="illustration">
  </div>
</div>
</body>
</html>

