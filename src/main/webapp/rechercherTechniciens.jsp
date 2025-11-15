<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche des Techniciens</title>
    <link rel="stylesheet" href="dashboard.css">
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
            <a href="paiement.jsp">
                <i class="bx bx-credit-card"></i>
                <span class="text">Paiement</span>
            </a>
        </li>
        <li>
            <a href="maintenance.jsp">
                <i class="bx bx-wrench"></i>
                <span class="text">Maintenance</span>
            </a>
        </li>
        <li>
            <a href="statistiques.jsp">
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
            <a href="deconnexion.jsp" class="logout">
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
        <form method="GET" action="rechercherTechniciens.jsp">
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
<h1>Résultats de la recherche</h1>
<table class="student-table" id="chambreTable">
    <thead>
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Prénom</th>
        <th>Téléphone</th>
        <th>Email</th>
        <th>Disponibilité</th>
        <th colspan="2">Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        String rech = request.getParameter("rech");
        String query = "SELECT * FROM technicien WHERE nom LIKE ? OR prenom LIKE ? OR email LIKE ?";
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, "%" + rech + "%");
            ps.setString(2, "%" + rech + "%");
            ps.setString(3, "%" + rech + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("nom") %></td>
        <td><%= rs.getString("prenom") %></td>
        <td><%= rs.getString("telephone") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("disponibilite") %></td>
        <td>
            <a href="ModifierTechnicien?id=<%= rs.getInt("id") %>"><ion-icon name="pencil-outline"></ion-icon> </a>
        </td>
        <td><a href="SupprimerTechnicien?id=<%= rs.getInt("id") %>"><ion-icon name="trash-outline"></ion-icon></a></td>
    </tr>
    <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
    </tbody>
</table>
            </div>
        </div>
    </main>
</section>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

<script src="script.js"></script>
</body>
</html>