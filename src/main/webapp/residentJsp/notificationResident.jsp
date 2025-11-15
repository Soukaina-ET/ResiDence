<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Notifications</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
  <link rel="stylesheet" href="dashboard.css">
  <style>
    .card { margin: 20px; }
    .table th, .table td { text-align: center; }
    .notification-item {
      padding: 10px;
      border-bottom: 1px solid #ddd;
    }
    .notification-item.unread {
      background-color: #f9f9f9;
    }
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
      <img src="${pageContext.request.contextPath}/profileImages/<%=session.getAttribute("profile_image")%>" class="profile-image">
      Bonjour <%=session.getAttribute("prenom")%>!
    </a>
  </nav>
  <!-- NAVBAR -->

  <!-- MAIN -->
  <main>
    <div class="head-title">
      <div class="left">
        <h1>Notifications</h1>
      </div>

      <table class="student-table" id="chambreTable">
        <!-- Existing table content remains unchanged -->
        <thead>
        <tr>
          <th>message</th>
          <th>Status</th>
          <th>Actions</th>
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
            ResultSet rs = stmt.executeQuery("SELECT id, resident_id, message, status FROM notifications");

            while (rs.next()) {
        %>
        <tr>
          <td><%= rs.getString(2) %></td>
          <td><%= rs.getString(3) %></td>
          <td><%= rs.getString(4) %></td>
          <td><a href="NotificationsServlet?id=<%= rs.getString(1) %>"><ion-icon name="eye-outline"></ion-icon></a></td>
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

</body>
</html>