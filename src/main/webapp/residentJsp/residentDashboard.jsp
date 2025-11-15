<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Résident</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            overflow: hidden;
            height: 100vh;
        }

        #content main {
            height: calc(100vh - 60px);
            overflow-y: auto;
            padding: 20px;
            background: #f8f9fa;
        }

        /* Scrollbar personnalisée */
        #content main::-webkit-scrollbar {
            width: 8px;
        }

        #content main::-webkit-scrollbar-track {
            background: #f1f5f9;
        }

        #content main::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            border-radius: 10px;
        }

        .dashboard-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0 0 5px 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header h1 i {
            font-size: 36px;
            color: #3498db;
        }

        .page-subtitle {
            color: #7f8c8d;
            font-size: 14px;
        }

        /* Cartes statistiques */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3498db 0%, #2980b9 100%);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #3498db;
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.2);
        }

        .stat-card:nth-child(2)::before {
            background: linear-gradient(90deg, #27ae60 0%, #229954 100%);
        }

        .stat-card:nth-child(3)::before {
            background: linear-gradient(90deg, #f39c12 0%, #e67e22 100%);
        }

        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .stat-icon {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .stat-card:nth-child(2) .stat-icon {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }

        .stat-card:nth-child(3) .stat-icon {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            box-shadow: 0 4px 15px rgba(243, 156, 18, 0.3);
        }

        .stat-content h3 {
            font-size: 13px;
            color: #7f8c8d;
            font-weight: 600;
            margin: 0 0 8px 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            line-height: 1;
            margin: 0;
        }

        .stat-label {
            font-size: 12px;
            color: #95a5a6;
            margin-top: 5px;
        }

        /* Sections de tableaux */
        .table-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 2px solid #ebf5fb;
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #ebf5fb;
        }

        .table-header h2 {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-header h2 i {
            font-size: 24px;
            color: #3498db;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .modern-table thead {
            background: linear-gradient(135deg, #ebf5fb 0%, #d6eaf8 100%);
        }

        .modern-table thead th {
            padding: 15px;
            text-align: center;
            font-weight: 600;
            font-size: 13px;
            color: #2c3e50;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
        }

        .modern-table thead th:first-child {
            border-radius: 10px 0 0 0;
        }

        .modern-table thead th:last-child {
            border-radius: 0 10px 0 0;
        }

        .modern-table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid #f0f0f0;
        }

        .modern-table tbody tr:hover {
            background: linear-gradient(90deg, rgba(52, 152, 219, 0.05) 0%, rgba(255, 255, 255, 0) 100%);
            transform: translateX(5px);
        }

        .modern-table tbody td {
            padding: 18px 15px;
            text-align: center;
            color: #2c3e50;
            font-size: 14px;
            border: none;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-badge.paid {
            background: #d5f4e6;
            color: #27ae60;
        }

        .status-badge.pending {
            background: #ebf5fb;
            color: #3498db;
        }

        .status-badge.in-progress {
            background: #fef5e7;
            color: #f39c12;
        }

        .status-badge.completed {
            background: #d5f4e6;
            color: #27ae60;
        }

        .status-badge i {
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #95a5a6;
        }

        .empty-state i {
            font-size: 60px;
            margin-bottom: 15px;
            opacity: 0.3;
            color: #3498db;
        }

        .empty-state h4 {
            font-size: 18px;
            margin-bottom: 8px;
            color: #5d6d7e;
        }

        .empty-state p {
            font-size: 14px;
            color: #7f8c8d;
        }

        .loading-state {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
        }

        .loading-state i {
            font-size: 48px;
            color: #3498db;
            animation: spin 2s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .stat-value {
                font-size: 28px;
            }

            .table-section {
                padding: 15px;
            }

            .modern-table {
                font-size: 12px;
            }

            .modern-table thead th,
            .modern-table tbody td {
                padding: 10px 8px;
            }
        }
    </style>
</head>
<body>
<!-- Vérification de la session -->
<%
    Integer residentId = (Integer) session.getAttribute("id");
    if (residentId != null) {
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

<!-- CONTENT -->
<section id="content">
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
            <span class="num" id="notificationCount">1</span>
        </a>
        <a href="#" class="profile">
            <img src="${pageContext.request.contextPath}/profileImages/<%=session.getAttribute("profile_image")%>" class="profile-image">
            Bonjour <%=session.getAttribute("prenom")%>!
        </a>
    </nav>

    <main>
        <div class="dashboard-container">
            <div class="page-header">
                <h1>
                    <i class='bx bxs-dashboard'></i>
                    Tableau de Bord
                </h1>
                <p class="page-subtitle">Vue d'ensemble de votre résidence</p>
            </div>

            <!-- Statistiques -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon">
                            <i class='bx bx-credit-card'></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>Paiements en attente</h3>
                        <p class="stat-value" id="pendingPayments">
                            <span class="loading-state" style="display: inline-block;">
                                <i class='bx bx-loader-alt' style="font-size: 28px;"></i>
                            </span>
                        </p>
                        <p class="stat-label">Montants dus</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon">
                            <i class='bx bx-wrench'></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>Signalements en cours</h3>
                        <p class="stat-value" id="maintenanceRequests">
                            <span class="loading-state" style="display: inline-block;">
                                <i class='bx bx-loader-alt' style="font-size: 28px;"></i>
                            </span>
                        </p>
                        <p class="stat-label">Interventions actives</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon">
                            <i class='bx bxs-bell'></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <h3>Notifications non lues</h3>
                        <p class="stat-value" id="unreadNotifications">
                            <span class="loading-state" style="display: inline-block;">
                                <i class='bx bx-loader-alt' style="font-size: 28px;"></i>
                            </span>
                        </p>
                        <p class="stat-label">Messages en attente</p>
                    </div>
                </div>
            </div>

            <!-- Derniers paiements -->
            <div class="table-section">
                <div class="table-header">
                    <h2>
                        <i class='bx bx-credit-card'></i>
                        Derniers Paiements
                    </h2>
                </div>
                <div class="table-responsive">
                    <table class="modern-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Montant</th>
                            <th>Date</th>
                            <th>Statut</th>
                        </tr>
                        </thead>
                        <tbody id="recentPayments">
                        <tr>
                            <td colspan="4">
                                <div class="loading-state">
                                    <i class='bx bx-loader-alt'></i>
                                    <p>Chargement des paiements...</p>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Derniers signalements de maintenance -->
            <div class="table-section">
                <div class="table-header">
                    <h2>
                        <i class='bx bx-wrench'></i>
                        Derniers Signalements
                    </h2>
                </div>
                <div class="table-responsive">
                    <table class="modern-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Description</th>
                            <th>Date</th>
                            <th>Statut</th>
                        </tr>
                        </thead>
                        <tbody id="recentMaintenance">
                        <tr>
                            <td colspan="4">
                                <div class="loading-state">
                                    <i class='bx bx-loader-alt'></i>
                                    <p>Chargement des signalements...</p>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</section>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function() {
        // Charger les statistiques
        function loadStatistics() {
            $.ajax({
                url: '${pageContext.request.contextPath}/ResidentDashboardServlet',
                type: 'GET',
                success: function(response) {
                    $('#pendingPayments').html(response.pendingPayments + ' <small>MAD</small>');
                    $('#maintenanceRequests').text(response.maintenanceRequests);
                    $('#unreadNotifications').text(response.unreadNotifications);
                },
                error: function() {
                    $('#pendingPayments').html('<span style="font-size: 16px; color: #e74c3c;">Erreur</span>');
                    $('#maintenanceRequests').html('<span style="font-size: 16px; color: #e74c3c;">Erreur</span>');
                    $('#unreadNotifications').html('<span style="font-size: 16px; color: #e74c3c;">Erreur</span>');
                }
            });
        }

        // Charger les derniers paiements
        function loadRecentPayments() {
            $.ajax({
                url: '${pageContext.request.contextPath}/ResidentDashboardServlet?action=recentPayments',
                type: 'GET',
                success: function(response) {
                    $('#recentPayments').empty();
                    if (response && response.length > 0) {
                        response.forEach(function(payment) {
                            const statusClass = payment.statut.toLowerCase() === 'payé' ? 'paid' : 'pending';
                            const icon = statusClass === 'paid' ? 'bx-check-circle' : 'bx-time-five';
                            $('#recentPayments').append(`
                                <tr>
                                    <td><strong>#${payment.id}</strong></td>
                                    <td><strong>${payment.montant} MAD</strong></td>
                                    <td>${payment.date}</td>
                                    <td>
                                        <span class="status-badge ${statusClass}">
                                            <i class='bx ${icon}'></i>
                                            ${payment.statut}
                                        </span>
                                    </td>
                                </tr>
                            `);
                        });
                    } else {
                        $('#recentPayments').html(`
                            <tr>
                                <td colspan="4">
                                    <div class="empty-state">
                                        <i class='bx bx-credit-card'></i>
                                        <h4>Aucun paiement</h4>
                                        <p>Vous n'avez aucun paiement enregistré</p>
                                    </div>
                                </td>
                            </tr>
                        `);
                    }
                },
                error: function() {
                    $('#recentPayments').html(`
                        <tr>
                            <td colspan="4">
                                <div class="empty-state">
                                    <i class='bx bx-error'></i>
                                    <h4>Erreur de chargement</h4>
                                    <p>Impossible de charger les paiements</p>
                                </div>
                            </td>
                        </tr>
                    `);
                }
            });
        }

        // Charger les derniers signalements de maintenance
        function loadRecentMaintenance() {
            $.ajax({
                url: '${pageContext.request.contextPath}/ResidentDashboardServlet?action=recentMaintenance',
                type: 'GET',
                success: function(response) {
                    $('#recentMaintenance').empty();
                    if (response && response.length > 0) {
                        response.forEach(function(request) {
                            const statusClass = request.statut.toLowerCase() === 'terminé' ? 'completed' : 'in-progress';
                            const icon = statusClass === 'completed' ? 'bx-check-circle' : 'bx-time-five';
                            $('#recentMaintenance').append(`
                                <tr>
                                    <td><strong>#${request.id}</strong></td>
                                    <td style="text-align: left; padding-left: 20px;">${request.description}</td>
                                    <td>${request.date}</td>
                                    <td>
                                        <span class="status-badge ${statusClass}">
                                            <i class='bx ${icon}'></i>
                                            ${request.statut}
                                        </span>
                                    </td>
                                </tr>
                            `);
                        });
                    } else {
                        $('#recentMaintenance').html(`
                            <tr>
                                <td colspan="4">
                                    <div class="empty-state">
                                        <i class='bx bx-wrench'></i>
                                        <h4>Aucun signalement</h4>
                                        <p>Vous n'avez aucun signalement de maintenance</p>
                                    </div>
                                </td>
                            </tr>
                        `);
                    }
                },
                error: function() {
                    $('#recentMaintenance').html(`
                        <tr>
                            <td colspan="4">
                                <div class="empty-state">
                                    <i class='bx bx-error'></i>
                                    <h4>Erreur de chargement</h4>
                                    <p>Impossible de charger les signalements</p>
                                </div>
                            </td>
                        </tr>
                    `);
                }
            });
        }

        // Charger les données au démarrage
        loadStatistics();
        loadRecentPayments();
        loadRecentMaintenance();
    });
</script>
<script src="script.js"></script>
</body>
<% } else { %>
<link rel="stylesheet" type="text/css" href="AffichageAdmin.css">
</head>
<body>
<div class="page1">
    <div class="container1">
        <div class="error-box">
            <img src="images/4O4.png" alt="Erreur 404" class="error-image">
            <p class="error-message">Erreur login ou mot de passe.</p>
            <button onclick="window.location.href='loginResident.html'" class="back-button">Retour à la page de connexion</button>
        </div>
    </div>
</div>
</body>
<% } %>
</html>