<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
    if (residentId == null) {
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
        <li class="active">
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
        <li>
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
        <form method="GET" action="rechercher.jsp">
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
            <img src="${pageContext.request.contextPath}/profileImages/<%=session.getAttribute("profile_image")%>" class="profile-image">Bonjour <%=session.getAttribute("prenom")%>!
        </a>
    </nav>
    <!-- NAVBAR -->

    <!-- MAIN -->
    <main>
        <div class="container">
            <h1 class="mt-4">Mes Paiements</h1>

            <!-- Affichage des messages d'erreur ou de succès -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>

            <!-- Liste des paiements -->
            <sql:setDataSource var="db" driver="com.mysql.cj.jdbc.Driver"
                               url="jdbc:mysql://localhost/residence"
                               user="root" password="Soukaina2003" />

            <sql:query dataSource="${db}" var="result">
                SELECT * FROM paiements WHERE resident_id = ?
                <sql:param value="${sessionScope.id}" />
            </sql:query>

            <table class="table table-striped">
                <thead>
                <tr>
                    <th>ID Paiement</th>
                    <th>ID Résident</th>
                    <th>ID Chambre</th>
                    <th>Montant Due</th>
                    <th>Montant Payé</th>
                    <th>Date de Paiement</th>
                    <th>Mode de Paiement</th>
                    <th>Statut</th>
                    <th>Commentaire</th>
                    <th colspan="2">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="row" items="${result.rows}">
                    <tr>
                        <td>${row.id}</td>
                        <td>${row.resident_id}</td>
                        <td>${row.chambre_id}</td>
                        <td>${row.montant_due}</td>
                        <td>${row.montant_paye}</td>
                        <td>${row.date_paiement}</td>
                        <td>${row.mode_paiement}</td>
                        <td>${row.statut}</td>
                        <td>${row.commentaire}</td>
                        <td><a href="${pageContext.request.contextPath}/DeletePaiement?id=${row.id}"><ion-icon name="trash-outline"></ion-icon></a></td>
                        <td><a href="${pageContext.request.contextPath}/GenererRecu?id=${row.id}"><ion-icon name="download"></ion-icon></a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <!-- Formulaire pour soumettre un nouveau paiement -->
            <h2 class="mt-4">Soumettre un Paiement</h2>
            <form action="${pageContext.request.contextPath}/PaiementServlet" method="post">
                <div class="form-group">
                    <label for="montant_due">Montant Due</label>
                    <input type="number" step="0.01" class="form-control" id="montant_due" name="montant_due" required>
                </div>
                <div class="form-group">
                    <label for="montant_paye">Montant payé</label>
                    <input type="number" step="0.01" class="form-control" id="montant_paye" name="montant_paye" required>
                </div>
                <div class="form-group">
                    <label for="mode_paiement">Mode de Paiement</label>
                    <select class="form-control" id="mode_paiement" name="mode_paiement" required>
                        <option value="Espèce">Espèce</option>
                        <option value="Carte Bancaire">Carte Bancaire</option>
                        <option value="Virement">Virement</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="commentaire">Commentaire</label>
                    <textarea class="form-control" id="commentaire" name="commentaire" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Soumettre</button>
            </form>
        </div>
    </main>
</section>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.min.js"></script>
</body>
</html>