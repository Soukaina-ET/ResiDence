<%@ page import="java.sql.*, java.util.*" %>
<%
    String paiementId = request.getParameter("id"); // L'ID du resident à modifier
    String url = "jdbc:mysql://localhost/residence";
    String driver = "com.mysql.cj.jdbc.Driver";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        con = DriverManager.getConnection(url, "root", "Soukaina2003");

        // Requête pour récupérer les données de la chambre
        String sql = "SELECT * FROM paiements WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, paiementId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Paiement</title>
</head>
<body>
<h1>Modifier Paiement</h1>
<form class="edit" action="UpdatePaiement" method="POST">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

    <label for="resident_id">ID Résident :</label>
    <input type="text" id="resident_id" name="resident_id" value="<%= rs.getInt("resident_id") %>" readonly><br>

    <label for="chambre_id">ID Chambre :</label>
    <input type="text" id="chambre_id" name="chambre_id" value="<%= rs.getInt("chambre_id") %>"><br>

    <label for="montant_due">Montant Due :</label>
    <input type="number" id="montant_due" name="montant_due" value="<%= rs.getInt("montant_due") %>" step="0.01" required><br>

    <label for="montant_paye">Montant Payé :</label>
    <input type="number" id="montant_paye" name="montant_paye" value="<%= rs.getInt("montant_paye") %>" step="0.01" required><br>

    <label for="mode_paiement">Mode de Paiement :</label>
    <select id="mode_paiement" name="mode_paiement">
        <option value="Espèce" <%= "Espèce".equals(rs.getString("mode_paiement")) ? "selected" : "" %>>Espèce</option>
        <option value="Carte" <%= "Carte".equals(rs.getString("mode_paiement")) ? "selected" : "" %>>Carte</option>
    </select><br>
    <label for="statut">Statut : :</label>
    <textarea id="statut" name="statut"><%= request.getAttribute("statut") %></textarea><br>
    <label for="commentaire">Commentaire :</label>
    <textarea id="commentaire" name="commentaire"><%= request.getAttribute("commentaire") %></textarea><br>

    <input type="submit" value="Mettre à jour le Paiement">
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