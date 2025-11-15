<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="dashboard.css">
    <title>Notifications</title>
    <style>
        main {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .notifications-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .notifications-header h1 {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .notifications-header h1 i {
            font-size: 36px;
            color: #3498db;
        }

        .notifications-stats {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .stat-badge {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .stat-badge.unread {
            background: linear-gradient(135deg, #5dade2 0%, #3498db 100%);
            box-shadow: 0 4px 15px rgba(93, 173, 226, 0.3);
        }

        .stat-badge i {
            font-size: 18px;
        }

        .notifications-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .notifications-filters {
            padding: 20px 30px;
            background: linear-gradient(135deg, #ebf5fb 0%, #d6eaf8 100%);
            border-bottom: 1px solid #d6eaf8;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 2px solid transparent;
            background: white;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            color: #6c757d;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-btn:hover {
            background: #3498db;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }

        .filter-btn.active {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            border-color: #3498db;
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }

        .notifications-list {
            max-height: calc(100vh - 350px);
            overflow-y: auto;
        }

        .notification-item {
            padding: 25px 30px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: flex-start;
            gap: 20px;
            transition: all 0.3s ease;
            position: relative;
            background: white;
        }

        .notification-item:hover {
            background: linear-gradient(90deg, rgba(52, 152, 219, 0.05) 0%, rgba(255, 255, 255, 0) 100%);
            transform: translateX(5px);
        }

        .notification-item.unread {
            background: linear-gradient(90deg, rgba(52, 152, 219, 0.08) 0%, rgba(255, 255, 255, 0) 100%);
            border-left: 4px solid #3498db;
        }

        .notification-item.unread::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            width: 10px;
            height: 10px;
            background: #5dade2;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
                transform: translateY(-50%) scale(1);
            }
            50% {
                opacity: 0.5;
                transform: translateY(-50%) scale(1.2);
            }
        }

        .notification-icon {
            width: 50px;
            height: 50px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .notification-icon.info {
            background: linear-gradient(135deg, #5dade2 0%, #3498db 100%);
            box-shadow: 0 4px 15px rgba(93, 173, 226, 0.3);
        }

        .notification-icon.warning {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            box-shadow: 0 4px 15px rgba(243, 156, 18, 0.3);
        }

        .notification-icon.success {
            background: linear-gradient(135deg, #27ae60 0%, #229954 100%);
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }

        .notification-content {
            flex: 1;
        }

        .notification-id {
            font-size: 12px;
            color: #7f8c8d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .notification-message {
            font-size: 15px;
            color: #2c3e50;
            line-height: 1.6;
            margin-bottom: 8px;
        }

        .notification-status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-top: 8px;
        }

        .notification-status.read {
            background: #d5f4e6;
            color: #27ae60;
        }

        .notification-status.unread {
            background: #ebf5fb;
            color: #3498db;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .action-btn {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ebf5fb;
            color: #3498db;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .action-btn:hover {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #95a5a6;
        }

        .empty-state i {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
            color: #3498db;
        }

        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #5d6d7e;
        }

        .empty-state p {
            font-size: 16px;
            color: #7f8c8d;
        }

        /* Scrollbar personnalisée */
        .notifications-list::-webkit-scrollbar {
            width: 8px;
        }

        .notifications-list::-webkit-scrollbar-track {
            background: #f8f9fa;
        }

        .notifications-list::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            border-radius: 10px;
        }

        .notifications-list::-webkit-scrollbar-thumb:hover {
            background: #2980b9;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .notifications-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .notification-item {
                padding: 20px 15px;
                flex-direction: column;
            }

            .notification-actions {
                width: 100%;
                justify-content: flex-end;
            }
        }
    </style>
</head>
<body>
<!-- SIDEBAR -->
<section id="sidebar">
    <a href="#" class="brand">
        <i class='bx bxs-home'></i>
        <span class="text">RESIDET</span>
    </a>
    <ul class="side-menu top">
        <li>
            <a href="affichageAdmin.jsp">
                <i class='bx bxs-dashboard'></i>
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
            <a href="admins.jsp">
                <i class='bx bxs-group'></i>
                <span class="text">Admins</span>
            </a>
        </li>
    </ul>
    <ul class="side-menu">
        <li>
            <a href="parametre.jsp">
                <i class='bx bxs-cog'></i>
                <span class="text">Paramètre</span>
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
        <a href="#" class="nav-link">Categories</a>
        <form method="GET" action="rechercherPaiement.jsp">
            <div class="form-input">
                <input type="text" name="rech" id="rech" placeholder="Rechercher...">
                <button type="submit" class="search-btn" value="Rechercher"><i class='bx bx-search'></i></button>
            </div>
        </form>
        <input type="checkbox" id="switch-mode" hidden>
        <label for="switch-mode" class="switch-mode"></label>
        <a href="notifications.jsp" class="notification">
            <i class='bx bxs-bell'></i>
            <span class="num">2</span>
        </a>
        <a href="#" class="profile">
            <img src="images/resident.png">
        </a>
    </nav>

    <main>
        <div class="notifications-header">
            <h1>
                <i class='bx bxs-bell-ring'></i>
                Notifications
            </h1>
            <div class="notifications-stats">
                <div class="stat-badge">
                    <i class='bx bx-envelope'></i>
                    <span id="totalNotif">0 Total</span>
                </div>
                <div class="stat-badge unread">
                    <i class='bx bx-envelope-open'></i>
                    <span id="unreadNotif">0 Non lues</span>
                </div>
            </div>
        </div>

        <div class="notifications-container">
            <div class="notifications-filters">
                <button class="filter-btn active" onclick="filterNotifications('all')">
                    <i class='bx bx-list-ul'></i>
                    Toutes
                </button>
                <button class="filter-btn" onclick="filterNotifications('unread')">
                    <i class='bx bx-envelope'></i>
                    Non lues
                </button>
                <button class="filter-btn" onclick="filterNotifications('read')">
                    <i class='bx bx-check-circle'></i>
                    Lues
                </button>
            </div>

            <div class="notifications-list" id="notificationsList">
                <%
                    String url = "jdbc:mysql://localhost/residence";
                    String driver = "com.mysql.cj.jdbc.Driver";
                    int totalNotif = 0;
                    int unreadNotif = 0;

                    try {
                        Class.forName(driver);
                        Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT id, message, status FROM notification ORDER BY id DESC");

                        boolean hasNotifications = false;
                        while (rs.next()) {
                            hasNotifications = true;
                            totalNotif++;
                            String status = rs.getString(3);
                            String statusClass = status != null && status.equalsIgnoreCase("read") ? "read" : "unread";
                            String itemClass = statusClass.equals("unread") ? "notification-item unread" : "notification-item";

                            if (statusClass.equals("unread")) {
                                unreadNotif++;
                            }

                            // Déterminer l'icône selon le type de message
                            String icon = "bx-bell";
                            String iconClass = "";
                            String message = rs.getString(2).toLowerCase();

                            if (message.contains("paiement") || message.contains("payé")) {
                                icon = "bx-credit-card";
                                iconClass = "success";
                            } else if (message.contains("maintenance") || message.contains("réparation")) {
                                icon = "bx-wrench";
                                iconClass = "warning";
                            } else if (message.contains("demande") || message.contains("inscription")) {
                                icon = "bx-user-plus";
                                iconClass = "info";
                            }
                %>
                <div class="<%= itemClass %>" data-status="<%= statusClass %>">
                    <div class="notification-icon <%= iconClass %>">
                        <i class='bx <%= icon %>'></i>
                    </div>
                    <div class="notification-content">
                        <div class="notification-id">Résident #<%= rs.getString(1) %></div>
                        <div class="notification-message"><%= rs.getString(2) %></div>
                        <span class="notification-status <%= statusClass %>">
                            <i class='bx <%= statusClass.equals("read") ? "bx-check-circle" : "bx-time-five" %>'></i>
                            <%= statusClass.equals("read") ? "Lu" : "Non lu" %>
                        </span>
                    </div>
                    <div class="notification-actions">
                        <a href="NotificationsServlets?id=<%= rs.getString(1) %>" class="action-btn" title="Voir les détails">
                            <i class='bx bx-show'></i>
                        </a>
                    </div>
                </div>
                <%
                    }

                    if (!hasNotifications) {
                %>
                <div class="empty-state">
                    <i class='bx bx-bell-off'></i>
                    <h3>Aucune notification</h3>
                    <p>Vous n'avez aucune notification pour le moment</p>
                </div>
                <%
                        }

                        rs.close();
                        stmt.close();
                        con.close();
                    } catch (SQLException | ClassNotFoundException e) {
                        out.println("<div class='empty-state'>");
                        out.println("<i class='bx bx-error'></i>");
                        out.println("<h3>Erreur de connexion</h3>");
                        out.println("<p>" + e.getMessage() + "</p>");
                        out.println("</div>");
                    }
                %>
            </div>
        </div>
    </main>
</section>

<script>
    // Mettre à jour les statistiques
    document.getElementById('totalNotif').textContent = '<%= totalNotif %> Total';
    document.getElementById('unreadNotif').textContent = '<%= unreadNotif %> Non lues';

    // Fonction de filtrage des notifications
    function filterNotifications(type) {
        const items = document.querySelectorAll('.notification-item');
        const buttons = document.querySelectorAll('.filter-btn');

        // Mettre à jour les boutons actifs
        buttons.forEach(btn => btn.classList.remove('active'));
        event.target.closest('.filter-btn').classList.add('active');

        // Filtrer les notifications
        items.forEach(item => {
            if (type === 'all') {
                item.style.display = 'flex';
            } else {
                if (item.dataset.status === type) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            }
        });
    }
</script>

<script src="script.js"></script>
</body>
</html>