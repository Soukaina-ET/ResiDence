package admin.admins;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.sql.*;
@WebServlet("/InsertAdmin")
public class InsertAdmin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String password = request.getParameter("password");
        if (password == null || password.isEmpty()) {
            response.getWriter().println("Le mot de passe est manquant");
            return; // Sortir de la méthode si le mot de passe est absent
        }
        String cnie = request.getParameter("cnie");

        System.out.println("Nom: " + request.getParameter("nom"));
        System.out.println("Email: " + request.getParameter("email"));
        System.out.println("Téléphone: " + request.getParameter("telephone"));
        System.out.println("Mot de passe: " + request.getParameter("password"));
        System.out.println("CNIE: " + request.getParameter("cnie"));
        // Générer un salt
        String salt = generateSalt();

        // Hacher le mot de passe avec le salt
        String hashedPassword = hashPassword(password, salt);

        // Connexion à la base de données et insertion
        String url = "jdbc:mysql://localhost/residence";
        String driver = "com.mysql.cj.jdbc.Driver";
        try {
            Class.forName(driver);
            Connection con = DriverManager.getConnection(url, "root", "Soukaina2003");

            String query = "INSERT INTO admin (nom, email, telephone, password, salt, cnie) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, nom);
            stmt.setString(2, email);
            stmt.setString(3, telephone);
            stmt.setString(4, hashedPassword);
            stmt.setString(5, salt);
            stmt.setString(6, cnie);

            int result = stmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("admins.jsp");
            } else {
                response.getWriter().println("Erreur lors de l'ajout de l'admin");
            }

            stmt.close();
            con.close();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur de connexion à la base de données : " + e.getMessage());
        }
    }

    private String generateSalt() {
        try {
            byte[] salt = new byte[16];
            java.security.SecureRandom.getInstance("SHA1PRNG").nextBytes(salt);
            return Base64.getEncoder().encodeToString(salt);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error generating salt", e);
        }
    }

    private String hashPassword(String password, String salt) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(salt.getBytes());
            byte[] hashedBytes = digest.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}

