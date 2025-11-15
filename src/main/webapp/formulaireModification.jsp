<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%
    String chambreId = request.getParameter("id"); // L'ID de la chambre à modifier
    String url = "jdbc:mysql://localhost/residence";
    String driver = "com.mysql.cj.jdbc.Driver";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;   

    try {
        Class.forName(driver);
        con = DriverManager.getConnection(url, "root", "Soukaina2003");

        // Requête pour récupérer les données de la chambre
        String sql = "SELECT * FROM chambre WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, chambreId);
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
    <form class="edit" method="post" action="ModificationServlet" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= rs.getString("id") %>">
        <% out.println("ID de la chambre à modifier : " + rs.getString("id")); %>
        <label for="type_chambre">Type :</label>
        <input type="text" id="type_chambre" name="type_chambre" value="<%= rs.getString("type_chambre") %>" required><br>

        <label for="prix_location_jour">Prix location/jour :</label>
        <input type="number" id="prix_location_jour" name="prix_location_jour" value="<%= rs.getString("prix_location_jour") %>" required><br>

        <label for="personne_max">Max personnes :</label>
        <input type="number" id="personne_max" name="personne_max" value="<%= rs.getString("personne_max") %>" required><br>

        <label for="caracteristiques">Caractéristiques :</label>
        <textarea id="caracteristiques" name="caracteristiques" rows="4" cols="50" required><%= rs.getString("caracteristiques") %></textarea><br>

        <label for="statut">Statut :</label>
        <select id="statut" name="statut" required>
            <option value="Disponible" <%= rs.getString("statut").equals("Disponible") ? "selected" : "" %>>Disponible</option>
            <option value="en maintenance" <%= rs.getString("statut").equals("en maintenance") ? "selected" : "" %>>En maintenance</option>
            <option value="Occupée" <%= rs.getString("statut").equals("Occupée") ? "selected" : "" %>>Occupée</option>
        </select><br>
        <label for="image_path">Image :</label>
        <input type="file" id="image_path" name="image_path" accept="image/*"><br><br>

        <input type="submit" value="Mettre à jour">
    </form>
</body>
</html>

<%
     } else {
            out.println("Chambre non trouvée.");
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
