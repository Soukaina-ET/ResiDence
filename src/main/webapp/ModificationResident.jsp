<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%
  String residentId = request.getParameter("id"); // L'ID du resident à modifier
  String url = "jdbc:mysql://localhost/residence";
  String driver = "com.mysql.cj.jdbc.Driver";
  Connection con = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try {
    Class.forName(driver);
    con = DriverManager.getConnection(url, "root", "Soukaina2003");

    // Requête pour récupérer les données de la chambre
    String sql = "SELECT id, nom, prenom, email, telephone, cne, carte_etudiante, date_demande, chambre_id FROM resident WHERE id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, residentId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Formulaire Modification</title>
  <link rel="stylesheet" type="text/css" href="dashboard.css">
</head>
<body>
<h2>Formulaire de Modification de Chambre</h2>
<form class="edit" method="post" action="EditServlet" enctype="multipart/form-data">
  <input type="hidden" name="id" value="<%= rs.getString("id") %>">
  <% out.println("ID du résident à modifier : " + rs.getString("id")); %>

  <label for="nom">Nom :</label>
  <input type="text" id="nom" name="nom" value="<%= rs.getString("nom") %>" required><br>

  <label for="prenom">Prenom :</label>
  <input type="text" id="prenom" name="prenom" value="<%= rs.getString("prenom") %>" required><br>

  <label for="email">Email :</label>
  <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required><br>

  <label for="telephone">Téléphone :</label>
  <input type="number" id="telephone" name="telephone" value="<%= rs.getString("telephone") %>" required><br>

  <label for="cne">CNE :</label>
  <input type="text" id="cne" name="cne" value="<%= rs.getString("cne") %>" required><br>

  <label for="carte_etudiante">Carte Étudiante :</label>
  <input type="file" id="carte_etudiante" name="carte_etudiante" accept="image/*"><br><br>

  <label for="chambre_id">Numéro de Chambre :</label>
  <input type="text" id="chambre_id" name="chambre_id" value="<%= rs.getString("chambre_id") %>"><br> <!-- Non obligatoire -->

  <label for="date_demande">Date de Demande :</label>
  <input type="date" id="date_demande" name="date_demande" value="<%= rs.getString("date_demande") %>" disabled><br>

  <input type="submit" value="Mettre à jour">
</form>
</body>
</html>

<%
    } else {
      out.println("Resident non trouvée.");
    }
  } catch (Exception e) {
    e.printStackTrace();
    out.println("Erreur de base de données : " + e.getMessage());
  } finally {
    try {
      if (rs != null) rs.close();
      if (pstmt != null) pstmt.close();
      if (con != null) con.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
%>

