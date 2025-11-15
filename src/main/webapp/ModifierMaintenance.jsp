<%@ page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<%
  String id = request.getParameter("id"); // L'ID de la maintenance à modifier
  String url = "jdbc:mysql://localhost/residence";
  String driver = "com.mysql.cj.jdbc.Driver";
  Connection con = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try {
    Class.forName(driver);
    con = DriverManager.getConnection(url, "root", "Soukaina2003");

    // Requête pour récupérer les données de la maintenance
    String sql = "SELECT chambre_id, resident_id, description, statut, date_signalement, date_resolution, technicien_id FROM maintenance WHERE id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
      // Récupération des données de la maintenance
      String chambreId = rs.getString("chambre_id");
      String residentId = rs.getString("resident_id");
      String description = rs.getString("description");
      String statut = rs.getString("statut");
      String dateSignalement = rs.getString("date_signalement");
      String dateResolution = rs.getString("date_resolution");
      String technicienId = rs.getString("technicien_id");

      request.setAttribute("chambreId", chambreId);
      request.setAttribute("residentId", residentId);
      request.setAttribute("description", description);
      request.setAttribute("statut", statut);
      request.setAttribute("dateSignalement", dateSignalement);
      request.setAttribute("dateResolution", dateResolution);
      request.setAttribute("technicienId", technicienId);
    } else {
      out.println("<p>Maintenance non trouvée.</p>");
    }
  } catch (Exception e) {
    e.printStackTrace();
    out.println("<p>Erreur lors de la récupération des données de maintenance.</p>");
  }
%>

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

  <!-- MAIN -->
  <main>
    <h1>Modifier Maintenance</h1>

    <% String chambreId = (String) request.getAttribute("chambreId"); %>
    <% String residentId = (String) request.getAttribute("residentId"); %>
    <% String description = (String) request.getAttribute("description"); %>
    <% String statut = (String) request.getAttribute("statut"); %>
    <% String technicienId = (String) request.getAttribute("technicienId"); %>

    <% if (chambreId != null) { %>
    <!-- Formulaire de modification -->
    <form class="edit" method="POST" action="ModifierMaintenance">
      <input type="hidden" name="id" value="<%= id %>">

      <label for="chambre_id">ID Chambre :</label>
      <input type="number" id="chambre_id" name="chambre_id" value="<%= chambreId %>" readonly><br>

      <label for="resident_id">ID Résident :</label>
      <input type="number" id="resident_id" name="resident_id" value="<%= residentId %>" readonly><br>

      <label for="description">Description :</label>
      <textarea id="description" name="description" required><%= description %></textarea><br>

      <label for="statut">Statut :</label>
      <select id="statut" name="statut" required>
        <option value="En attente" <%= "En attente".equals(statut) ? "selected" : "" %>>En attente</option>
        <option value="Terminé" <%= "Terminé".equals(statut) ? "selected" : "" %>>Terminé</option>
      </select><br>

      <label for="technicien_id">Technicien :</label>
      <select id="technicien_id" name="technicien_id" >
        <%
          // Charger les techniciens disponibles
          try (Connection connTechnicien = DriverManager.getConnection("jdbc:mysql://localhost/residence", "root", "Soukaina2003");
               PreparedStatement ps = connTechnicien.prepareStatement("SELECT id, nom, prenom FROM technicien WHERE disponibilite = 'disponible';");
               ResultSet rsTechnicien = ps.executeQuery()) {
            while (rsTechnicien.next()) {
        %>
        <option value="<%= rsTechnicien.getInt("id") %>" <%= rsTechnicien.getInt("id") == Integer.parseInt(technicienId) ? "selected" : "" %> >
          <%= rsTechnicien.getString("nom") %> <%= rsTechnicien.getString("prenom") %>
        </option>
        <%
            }
          } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Erreur lors du chargement des techniciens disponibles.</p>");
          }
        %>
      </select><br>

      <input type="submit">Mettre à jour</input>
    </form>
    <% } %>

  </main>
</section>
</body>
</html>
