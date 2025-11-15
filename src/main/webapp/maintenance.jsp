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
        <a href="notifications.jsp" class="notification">
            <i class='bx bxs-bell' ></i>
            <span class="num">2</span>
        </a>
        <a href="#" class="profile">
            <img src="images/resident.png">
        </a>
    </nav>
    <!-- NAVBAR -->

    <!-- MAIN -->
    <main>
        <h1>Gestion de Maintenance</h1>

        <!-- Formulaire d'ajout -->
        <form class="add" method="POST" action="AjouterMaintenance">
            <label for="chambreId">ID Chambre :</label>
            <input type="number" id="chambreId" name="chambreId" required><br>

            <label for="residentId">ID Résident :</label>
            <input type="number" id="residentId" name="residentId" required><br>

            <label for="description">Description :</label>
            <textarea id="description" name="description" required></textarea><br>

            <label for="technicienId">Technicien :</label>
            <select id="technicienId" name="technicienId" required>
                <%
                    // Charger les techniciens disponibles
                    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
                         PreparedStatement ps = con.prepareStatement("SELECT id, nom, prenom FROM technicien WHERE disponibilite= 'disponible';");
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id") %>"><%= rs.getString("nom") %> <%= rs.getString("prenom") %></option>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select><br>

            <input type="submit" value="Ajouter la requête de maintenance">
        </form>

        <!-- Liste des maintenances -->
        <h2>Liste des Maintenances</h2>
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
                <th>Technicien</th>
                <th colspan="3">Actions</th>
            </tr>
            </thead>
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
                     PreparedStatement ps = con.prepareStatement("SELECT m.*, t.nom AS tech_nom, t.prenom AS tech_prenom" +
                             " FROM maintenance m " +
                             "LEFT JOIN technicien t ON m.technicien_id = t.id");
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getInt("chambre_id") %></td>
                <td><%= rs.getInt("resident_id") %></td>
                <td><%= rs.getString("description") %></td>
                <td style="color: <%
                        if (!"Terminé".equals(rs.getString("statut"))) {
                          out.print("#8b0000"); // Rouge sombre pour "Non Terminé"
                        } else {
                           out.print("#006400"); // Vert foncé pour "Terminé"
                        } %>;">
                        <%= rs.getString("statut") %>
                </td>

                <td><%= rs.getTimestamp("date_signalement") %></td>
                <td><%= rs.getTimestamp("date_resolution") != null ? rs.getTimestamp("date_resolution") : "Non défini" %></td>
                <td><%= rs.getString("tech_nom") %> <%= rs.getString("tech_prenom") %></td>
                <td>
                    <a href="ModifierMaintenance.jsp?id=<%= rs.getInt("id") %>"><ion-icon name="pencil-outline"></ion-icon></a>
                </td>
                <td>
                    <a href="SupprimerMaintenance?id=<%= rs.getInt("id") %>"><ion-icon name="trash-outline"></ion-icon></a>
                </td>
                <td>
                    <% if (!"Terminé".equals(rs.getString("statut"))) { %>
                    <form method="POST" action="ValiderMaintenance" style="display:inline;">
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                        <button type="submit"><ion-icon name="checkmark-circle-outline"></ion-icon></button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </table>
        <a href="technicien.jsp">Afficher les techniciens </a>
    </main>
</section>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

<script src="script.js"></script>
</body>
</html>
