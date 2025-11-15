<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
  // Récupérer la session actuelle
  session = request.getSession(false);

  if (session != null) {
    // Invalider la session
    session.invalidate();
  }

  // Rediriger vers la page de connexion ou d'accueil
  response.sendRedirect("loginAdmin.html");
%>

