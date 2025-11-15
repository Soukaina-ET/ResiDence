<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <title>Affichage de demandes d'inscription:</title>
    <style>
        .action-button {
            margin: 0 5px;
            text-decoration: none;
            color: #5041bc; /* Couleur violette */
            font-size: 1.5rem;
        }
        .action-button:hover {
            color: #ff0000; /* Couleur rouge au survol */
        }
        .toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            display: none;
        }
        .toast.error {
            background-color: #f44336;
        }
    </style>
    <script>
        function showToast(message, isError) {
            const toast = document.createElement('div');
            toast.className = 'toast' + (isError ? ' error' : '');
            toast.textContent = message;
            document.body.appendChild(toast);
            toast.style.display = 'block';

            setTimeout(() => {
                toast.style.opacity = '0';
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }

        window.onload = function() {
            const message = '<%= request.getAttribute("message") %>';
            const error = '<%= request.getAttribute("error") %>';
            if (message) showToast(message, false);
            if (error) showToast(error, true);
        };
    </script>
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
        <form method="GET" action="rechercherDemandes.jsp">
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
        <div class="head-title">
            <div class="left">
                <h1>Liste des demandes:</h1>
            </div>

            <table class="student-table" id="chambreTable">
                <!-- Existing table content remains unchanged -->
                <thead>
                <tr>
                    <th>Id</th>
                    <th>Nom</th>
                    <th>Prenom</th>
                    <th>Email</th>
                    <th>Téléphone</th>
                    <th>CNE</th>
                    <th>Carte d'étudiant</th>
                    <th>Date demande</th>
                    <th colspan="2">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    String url = "jdbc:mysql://localhost/residence";
                    String driver = "com.mysql.cj.jdbc.Driver";
                    try {
                        Class.forName(driver);
                        Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM demandes_inscription");

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString(1) %></td>
                    <td><%= rs.getString(2) %></td>
                    <td><%= rs.getString(3) %></td>
                    <td><%= rs.getString(4) %></td>
                    <td><%= rs.getString(5) %></td>
                    <td><%= rs.getString(7) %></td>
                    <%
                        Blob imageBlob = rs.getBlob(8);  // Récupérer le BLOB de l'image
                        InputStream inputStream = imageBlob.getBinaryStream();
                        byte[] imageBytes = new byte[(int) imageBlob.length()];
                        inputStream.read(imageBytes);
                        String base64Image = Base64.getEncoder().encodeToString(imageBytes);

                        Timestamp timestamp = rs.getTimestamp(9);  // Récupérer le TIMESTAMP
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String formattedDate = sdf.format(timestamp);
                    %>
                    <td><img src="data:image/jpeg;base64,<%= base64Image %>" alt="Image chambre" width="200" height="200"></td>
                    <td><%= formattedDate %></td>

                    <td><a href="ValiderServlet?id=<%= rs.getString(1) %>"><ion-icon name="checkmark-circle-outline"></ion-icon></a></td>
                    <td><a href="SupprimerServlet?id=<%= rs.getString(1) %>"><ion-icon name="trash-outline"></ion-icon></a></td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                        con.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        out.println("<p style='color: red;'>Erreur de connexion à la base de données : " + e.getMessage() + "</p>");
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
