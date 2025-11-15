<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <title>Résultats de la recherche</title>
    <link rel="stylesheet" type="text/css" href="dashboard.css">
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
            <a href="#">
                <i class='bx bxs-dashboard' ></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="#">
                <i class='bx bx-bed'></i>
                <span class="text">Chambres</span>
            </a>
        </li>
        <li>
            <a href="#">
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
            <a href="#">
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
        <form method="GET" action="rechercher.jsp">
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

    <!-- MAIN -->
    <main>
        <div class="head-title">
            <div class="left">
                  <h2>Résultats de la recherche :</h2>
            </div>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Type</th>
                <th>Prix location/jour</th>
                <th>Max personnes</th>
                <th>Caractéristiques</th>
                <th>Statut</th>
                <th>Image</th>
                <th colspan="2">Actions</th>
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
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(url, user, password);

                    String query = "SELECT * FROM chambre WHERE id LIKE ? OR type_chambre LIKE ? OR prix_location_jour LIKE ? OR personne_max LIKE ? OR caracteristiques LIKE ? OR statut LIKE ? OR image_path LIKE ?";
                    pstmt = con.prepareStatement(query);
                    for (int i = 1; i <= 7; i++) {
                        pstmt.setString(i, "%" + rech + "%");
                    }
                    rs = pstmt.executeQuery();

                    if (!rs.isBeforeFirst()) {
                        out.println("<tr><td colspan='9'>Aucun résultat trouvé.</td></tr>");
                    } else {
                        while (rs.next()) {
            %>
                     <tr>
                        <td><%= rs.getString("id") %></td>
                        <td><%= rs.getString("type_chambre") %></td>
                        <td><%= rs.getString("prix_location_jour") %></td>
                        <td><%= rs.getString("personne_max") %></td>
                        <td><%= rs.getString("caracteristiques") %></td>
                        <td><%= rs.getString("statut") %></td>
                        <td><img src="<%= rs.getString("image_path") %>" alt="Image chambre" width="100" height="100"></td>
                         <td><button class="open-modal-btn" onclick="openModal(<%= rs.getString(1) %>)"><ion-icon name="pencil-outline"></ion-icon></button></td>
                         <td><a href="SuppressionServlet?id=<%= rs.getString(1) %>"><ion-icon name="trash-outline"></ion-icon></a></td>
                     </tr>
            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='9'>Erreur : " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (con != null) try { con.close(); } catch (SQLException ignored) {}
                }
            %>
        </tbody>
    </table>
                <a href="Chambre.jsp">Retour</a>
        </div>
    </main>
</section>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script src="script.js"></script>
</body>
</html>
