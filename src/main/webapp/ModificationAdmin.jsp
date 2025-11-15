<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%
    String AdminId = request.getParameter("id"); // L'ID du resident à modifier
    String url = "jdbc:mysql://localhost/residence";
    String driver = "com.mysql.cj.jdbc.Driver";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        con = DriverManager.getConnection(url, "root", "Soukaina2003");

        // Requête pour récupérer les données de la chambre
        String sql = "SELECT id, nom, telephone, email, cnie FROM admin WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, AdminId);
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
<h2>Formulaire de Modification d'/ Admin</h2>
<form class="edit" method="post" action="EditAdmin" >
    <input type="hidden" name="id" value="<%= rs.getString("id") %>">
    <% out.println("ID de la chambre à modifier : " + rs.getString("id")); %>
    <label for="nom">Nom :</label>
    <input type="text" id="nom" name="nom" value="<%= rs.getString("nom") %>" required><br>
    <label for="telephone">Nom :</label>
    <input type="text" id="telephone" name="telephone" value="<%= rs.getString("telephone") %>" required><br>
    <label for="email">Email :</label>
    <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required><br>
    <label for="cnie">CNIE :</label>
    <input type="text" id="cnie" name="cnie" value="<%= rs.getString("cnie") %>"><br>
    <input type="submit" value="Mettre à jour">
</form>
</body>
</html>

<%
        } else {
            out.println("Admin non trouvée.");
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

