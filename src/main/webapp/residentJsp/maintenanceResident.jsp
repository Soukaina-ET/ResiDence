<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Maintenance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="dashboard.css">
    <style>
        .card { margin: 20px; }
        .table th, .table td { text-align: center; }
    </style>
</head>
<body>
<!-- Vérification de la session -->
<%
    Integer residentId = (Integer) session.getAttribute("id");
    Integer chambreId = (Integer) session.getAttribute("chambre_id");
    if (residentId == null || chambreId == null) {
        response.sendRedirect(request.getContextPath() + "/loginResident.jsp");
        return;
    }
%>

<!-- SIDEBAR -->
<section id="sidebar">
    <a href="#" class="brand">
        <i class='bx bxs-home'></i>
        <span class="text">RESIDET</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="residentDashboard.jsp">
                <i class='bx bxs-dashboard'></i>
                <span class="text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="profilResident.jsp">
                <i class='bx bxs-user-detail'></i>
                <span class="text">Profil</span>
            </a>
        </li>
        <li>
            <a href="paiementResident.jsp">
                <i class="bx bx-credit-card"></i>
                <span class="text">Paiements</span>
            </a>
        </li>
        <li class="active">
            <a href="maintenanceResident.jsp">
                <i class="bx bx-wrench"></i>
                <span class="text">Maintenance</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu">
        <li>
            <a href="parametreResident.jsp">
                <i class='bx bxs-cog'></i>
                <span class="text">Paramètres</span>
            </a>
        </li>
        <li>
            <a href="deconnexion.jsp" class="logout">
                <i class='bx bxs-log-out-circle'></i>
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
        <i class='bx bx-menu'></i>
        <a href="#" class="nav-link">Catégories</a>
        <form method="GET" action="rechercheResident.jsp">
            <div class="form-input">
                <input type="text" name="rech" id="rech" placeholder="Rechercher...">
                <button type="submit" class="search-btn" value="Rechercher"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <input type="checkbox" id="switch-mode" hidden>
        <label for="switch-mode" class="switch-mode"></label>
        <a href="notificationResident.jsp" class="notification">
            <i class='bx bxs-bell'></i>
            <span class="num" id="notificationCount">0</span>
        </a>
        <a href="#" class="profile">
            <img src="${pageContext.request.contextPath}/profileImages/<%=session.getAttribute("profile_image")%>" class="profile-image">
            Bonjour <%=session.getAttribute("prenom")%>!
        </a>
    </nav>
    <!-- NAVBAR -->

    <!-- MAIN -->
    <main>
        <div class="container">
            <h1 class="mt-4">Maintenance</h1>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>

            <!-- Formulaire pour signaler un problème de maintenance -->
            <form action="${pageContext.request.contextPath}/MaintenanceServlet" method="post">
                <div class="form-group mb-3">
                    <label for="description">Description du problème</label>
                    <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Signaler</button>
            </form>

            <!-- Liste des signalements de maintenance -->
            <h2 class="mt-4">Mes Signalements</h2>
            <table class="student-table" id="chambreTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Chambre</th>
                    <th>Description</th>
                    <th>Statut</th>
                    <th>Date de Signalement</th>
                    <th>Commentaire Admin</th>
                </tr>
                </thead>
                <tbody>
                <%
                    String selectMaintenance = "SELECT * FROM maintenance WHERE resident_id = ?";
                    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
                         PreparedStatement ps = con.prepareStatement(selectMaintenance)) {
                        ps.setInt(1, residentId);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getInt("chambre_id") %></td>
                    <td><%= rs.getString("description") %></td>
                    <td><%= rs.getString("statut") %></td>
                    <td><%= rs.getTimestamp("date_signalement") %></td>
                    <td><%= rs.getString("commentaire_admin") %></td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>
</section>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>