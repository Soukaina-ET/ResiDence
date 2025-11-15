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
  <title>Affichage des Résidents:</title>
  <style>
    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.4);
    }
    .modal-content {
      background-color: #fefefe;
      margin: 10% auto;
      padding: 20px;
      border: 1px solid #888;
      width: 50%;
      box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
    }

    .modal .close {
      color: red !important ; /* Changer la couleur en rouge directement */
      font-size: 30px; /* Augmenter la taille du X */
      font-weight: bold;
      position: absolute; /* Positionner absolument dans le coin supérieur droit */
      top: 10px;
      right: 10px;
      cursor: pointer;
    }
    .close:hover,
    .close:focus {
      color: darkred !important;
      text-decoration: none;
      cursor: pointer;
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
    <form method="GET" action="rechercherAdmin.jsp">
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
        <h1>Liste des Admins:</h1>
        <button id="addChambreBtn" class="add-student-btn" onclick="openAddResidentModal()">Ajouter Admin</button>
      </div>

      <table class="student-table" id="chambreTable">
        <!-- Existing table content remains unchanged -->
        <thead>
        <tr>
          <th>ID</th>
          <th>Nom</th>
          <th>Telephone</th>
          <th>Email</th>
          <th>CNIE</th>
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
            ResultSet rs = stmt.executeQuery("SELECT id, nom, telephone, email, cnie FROM admin");

            while (rs.next()) {
        %>
        <tr>
          <td><%= rs.getString(1) %></td>
          <td><%= rs.getString(2) %></td>
          <td><%= rs.getString(3) %></td>
          <td><%= rs.getString(4) %></td>
          <td><%= rs.getString(5) %></td>
          <td>  <button onclick="openModal(<%= rs.getString(1) %>)">
              <ion-icon name="pencil-outline"></ion-icon>
          </button>
          </td>
          <td><a href="DeleteAdmin?id=<%= rs.getString(1) %>"><ion-icon name="trash-outline"></ion-icon></a></td>
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

<div id="modificationModal" class="modal">
  <div class="modal-content" id="modal-content">
    <button type="button" id="closeModal" class="close">&times;</button>
    <!-- Le formulaire sera inséré ici dynamiquement -->
  </div>
</div>

  </div>
</div>

<!-- Modal for adding resident -->
<div id="addResidentModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <h2>Ajouter un admin</h2>
    <form class="add" method="POST" action="InsertAdmin" >
      <label for="nom">Nom :</label>
      <input type="text" id="nom" name="nom" required><br>

      <label for="email">Email :</label>
      <input type="email" id="email" name="email" required><br>

      <label for="telephone">Téléphone :</label>
      <input type="text" id="telephone" name="telephone" ><br>

      <label for="password">Password</label>
      <input type="password" id="password" name="password" required>

      <label for="cnie">CNIE :</label>
      <input type="text" id="cnie" name="cnie" ><br>

      <input type="submit" value="Envoyer">
      <input type="reset" value="Effacer">
    </form>
  </div>
</div>

<script>
  function openAddResidentModal() {
    document.getElementById("addResidentModal").style.display = "block";
  }

  function closeModal() {
    document.getElementById("addResidentModal").style.display = "none";
  }

  // Fermer le modal si on clique à l'extérieur
  window.onclick = function(event) {
    if (event.target == document.getElementById("addResidentModal")) {
      closeModal();
    }
    if(event.target == document.getElementById("modificationModal")) {
      closeModal();
    }
  }

  // Fonction pour ouvrir le modal
  function openModal(AdminId) {
    fetch('ModificationAdmin.jsp?id=' + AdminId)
            .then(response => {
              if (!response.ok) {
                throw new Error('Erreur réseau lors du chargement du formulaire');
              }
              return response.text();
            })
            .then(data => {
              document.getElementById("modal-content").innerHTML = data;
              document.getElementById("modificationModal").style.display = "block"; // Show the modal

              // Attacher l'événement pour fermer le modal après l'insertion du contenu
              const closeModal = document.getElementById("closeModal");
              if (closeModal) {
                closeModal.onclick = function () {
                  document.getElementById("modificationModal").style.display = "none";
                  document.getElementById("modal-content").innerHTML = ""; // Réinitialiser le contenu
                };
              }
            })
            .catch(error => {
              console.error("Erreur lors du chargement du formulaire : ", error);
            });
  }
</script>

<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

<script src="script.js"></script>
</body>
</html>