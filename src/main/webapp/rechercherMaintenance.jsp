<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <title>Paiement</title>
</head>
<body>
<!-- SIDEBAR -->
<section id="sidebar">
    <a href="#" class="brand">
        <i class='bx bxs-home'></i>
        <span class="text">RESIDET</span>
    </a>
    <ul class="side-menu top">
        <li class="active">
            <a href="affichageAdmin.jsp">
                <i class='bx bxs-dashboard' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="Chambre.jsp">
                <i class='bx bx-bed'></i>
                <span class="text">Chambres</span>
            </a>
        </li>
        <li>
            <a href="residents.jsp">
                <i class='bx bxs-user-detail'></i>
                <span class="text">Résidents</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-credit-card"></i>
                <span class="text">Paiement</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-wrench"></i>
                <span class="text">Maintenance</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class="bx bx-line-chart"></i>
                <span class="text">Statistiques</span>
            </a>
        </li>
        <li>
            <a href="demandes.jsp">
                <i class='bx bx-user-plus'></i>
                <span class="text">Demandes d'inscription</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bxs-group' ></i>
                <span class="text">Admins</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu">

        <li>
            <a href="#">
                <i class='bx bxs-cog' ></i>
                <span class="text">Paramètre</span>
            </a>
        </li>
        <li>
            <a href="#" class="logout">
                <i class='bx bxs-log-out-circle' ></i>
                <span class="text">Déconnexion</span>
            </a>
        </li>
    </ul>
</section>
<!-- SIDEBAR -->



<!-- CONTENT -->
<section id="content">
    <!-- NAVBAR -->
    <nav>
        <i class='bx bx-menu' ></i>
        <a href="#" class="nav-link">Categories</a>
        <form method="GET" action="rechercherMaintenance.jsp">
            <div class="form-input">
                <input type="text" name="rech" id="rech" placeholder="Rechercher...">
                <button type="submit" class="search-btn" value="Rechercher"><i class='bx bx-search' ></i></button>
            </div>
        </form>
        <input type="checkbox" id="switch-mode" hidden>
        <label for="switch-mode" class="switch-mode"></label>
        <a href="#" class="notification">
            <i class='bx bxs-bell' ></i>
            <span class="num">8</span>
        </a>
        <a href="#" class="profile">
            <img src="images/resident.png">
        </a>
    </nav>
    <!-- NAVBAR -->

    <!-- CONTENT -->
    <main>
        <h2>Résultats de la recherche :</h2>
        <table class="student-table" id="chambreTable">
            <thead>
            <tr>
                <th>ID</th>
                <th>Chambre</th>
                <th>Résident</th>
                <th>Description</th>
                <th>Statut</th>
                <th>Date Signalement</th>
                <th>Date Résolution</th>
                <th>Nom Technicien</th>
                <th>Prenom Technicien</th>
            </tr>
            </thead>
            <tbody>
            <%
                String rech = request.getParameter("rech");
                String url = "jdbc:mysql://localhost/residence";
                String user = "root";
                String password = "Soukaina2003";

                Connection con = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Charger le driver MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Connexion à la base de données
                    con = DriverManager.getConnection(url, user, password);

                    // Requête SQL pour la recherche
                    String query = "SELECT m.id, m.chambre_id, m.resident_id, m.description, m.statut, m.date_signalement, m.date_resolution, " +
                            "t.nom AS technicien_nom, t.prenom AS technicien_prenom " +
                            "FROM maintenance m " +
                            "LEFT JOIN technicien t ON m.technicien_id = t.id " +
                            "WHERE m.id LIKE ? OR m.chambre_id LIKE ? OR m.resident_id LIKE ? " +
                            "OR m.description LIKE ? OR m.statut LIKE ? OR m.date_signalement LIKE ? " +
                            "OR t.nom LIKE ? OR t.prenom LIKE ?";

                    pstmt = con.prepareStatement(query);


                    // Définir les valeurs des placeholders
                    for (int i = 1; i <= 8; i++) {
                        pstmt.setString(i, "%" + rech + "%");
                    }

                    // Exécuter la requête
                    rs = pstmt.executeQuery();

                    // Vérifier si des résultats sont retournés
                    if (!rs.isBeforeFirst()) {
                        out.println("<tr><td colspan='7'>Aucun résultat trouvé.</td></tr>");
                    } else {
                        while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getInt("chambre_id") %></td>
                <td><%= rs.getInt("resident_id") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= rs.getString("statut") %></td>
                <td><%= rs.getTimestamp("date_resolution") %></td>
                <td><%= rs.getTimestamp("date_signalement") %></td>
                <td><%= rs.getString("technicien_nom") %></td>
                <td><%= rs.getString("technicien_prenom") %></td>
            </tr>
            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Erreur lors de la récupération des données : " + e.getMessage() + "</td></tr>");
                } finally {
                    // Fermeture des ressources
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
            </tbody>
        </table>
    </main>
    <a href="maintenance.jsp">Retour</a>
</section>
</body>
</html>