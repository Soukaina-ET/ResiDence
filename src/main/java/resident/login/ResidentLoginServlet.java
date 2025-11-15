package resident.login;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.logging.*;
import jakarta.servlet.ServletException;
import resident.DatabaseConnection.DatabaseConnection;
import org.mindrot.jbcrypt.BCrypt; // Ajouter la dépendance bcrypt
@WebServlet("/ResidentLogin")
public class ResidentLoginServlet extends HttpServlet {
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            try (Connection conn = DatabaseConnection.getConnection()) {
                String query = "SELECT * FROM resident WHERE email = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, email);
                ResultSet rs = stmt.executeQuery();

                if (rs.next() && BCrypt.checkpw(password, rs.getString("password"))) {
                    HttpSession session = request.getSession();
                    session.setAttribute("id", rs.getInt("id"));
                    session.setAttribute("nom", rs.getString("nom"));
                    session.setAttribute("prenom", rs.getString("prenom"));
                    session.setAttribute("profile_image", rs.getString("profile_image"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("telephone", rs.getString("telephone"));
                    session.setAttribute("chambre_id", rs.getInt("chambre_id"));
                    response.sendRedirect("residentJsp/residentDashboard.jsp");
                } else {
                    request.setAttribute("error", "Email ou mot de passe incorrect.");
                    request.getRequestDispatcher("FormulaireConnexion.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                // Logger l'erreur et rediriger vers une page d'erreur
                e.printStackTrace();
                request.setAttribute("error", "Une erreur s'est produite. Veuillez réessayer plus tard.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        }
    }


