package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.ConnectionOracle;
import mx.edu.utez.locker.model.Alumno;
import mx.edu.utez.locker.model.Administrador; // Asegúrate de importar el modelo Administrador
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class DaoAlumno {

    public boolean registrar(Alumno alumno) {
        String sql = "INSERT INTO ALUMNO (MATRICULA, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO, CORREO, CONTRASENA, ID_CARRERA) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, alumno.getMatricula());
            ps.setString(2, alumno.getNombres());
            ps.setString(3, alumno.getApellidoPaterno());
            ps.setString(4, alumno.getApellidoMaterno());
            ps.setString(5, alumno.getCorreo());
            ps.setString(6, alumno.getContrasena());

            if (alumno.getIdCarrera() != null && !alumno.getIdCarrera().isEmpty()) {
                ps.setString(7, alumno.getIdCarrera());
            } else {
                ps.setNull(7, Types.VARCHAR);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Intenta autenticar al usuario.
     * 1. Busca en la tabla ADMINISTRADOR. Si lo encuentra, retorna un objeto Administrador.
     * 2. Si no, busca en la tabla ALUMNO. Si lo encuentra, retorna un objeto Alumno.
     * 3. Si no existe en ninguno, retorna null.
     */
    public Object iniciarSesion(String correo, String contrasena) {
        System.out.println(">>> Intentando iniciar sesión con:");
        System.out.println("    Correo recibido: [" + correo + "]");
        System.out.println("    Contraseña recibida: [" + contrasena + "]");

        // 1. INTENTAR AUTENTICAR COMO ADMINISTRADOR (en texto plano)
        String queryAdmin = "SELECT ID_ADMIN, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO, CORREO, CONTRASENA " +
                "FROM ADMINISTRADOR " +
                "WHERE LOWER(TRIM(CORREO)) = LOWER(TRIM(?)) " +
                "AND TRIM(CONTRASENA) = ?";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(queryAdmin)) {

            ps.setString(1, correo);
            ps.setString(2, contrasena); // Se envía en texto plano

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Administrador admin = new Administrador();
                    admin.setIdAdministrador(rs.getInt("ID_ADMIN"));
                    admin.setNombres(rs.getString("NOMBRES"));
                    admin.setApellidoPaterno(rs.getString("APELLIDO_PATERNO"));
                    admin.setApellidoMaterno(rs.getString("APELLIDO_MATERNO"));
                    admin.setCorreo(rs.getString("CORREO"));
                    admin.setContrasena(rs.getString("CONTRASENA"));
                    admin.setRol("ADMIN");

                    System.out.println(">>> ¡ADMINISTRADOR encontrado exitosamente!");
                    return admin;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 2. SI NO FUE ADMIN, INTENTAR AUTENTICAR COMO ALUMNO (en texto plano)
        String queryAlumno = "SELECT a.ID_ALUMNO, a.MATRICULA, a.NOMBRES, a.APELLIDO_PATERNO, " +
                "a.APELLIDO_MATERNO, a.CORREO, a.CONTRASENA " +
                "FROM ALUMNO a " +
                "WHERE LOWER(TRIM(a.CORREO)) = LOWER(TRIM(?)) " +
                "AND TRIM(a.CONTRASENA) = TRIM(?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(queryAlumno)) {

            ps.setString(1, correo);
            ps.setString(2, contrasena); // Se envía en texto plano

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Alumno alumno = new Alumno();
                    alumno.setIdAlumno(rs.getInt("ID_ALUMNO"));
                    alumno.setMatricula(rs.getString("MATRICULA"));
                    alumno.setNombres(rs.getString("NOMBRES"));
                    alumno.setApellidoPaterno(rs.getString("APELLIDO_PATERNO"));
                    alumno.setApellidoMaterno(rs.getString("APELLIDO_MATERNO"));
                    alumno.setCorreo(rs.getString("CORREO"));
                    alumno.setContrasena(rs.getString("CONTRASENA"));
                    alumno.setRol("ALUMNO");

                    System.out.println(">>> ¡ALUMNO encontrado exitosamente!");
                    return alumno;
                } else {
                    System.out.println(">>> No se encontró usuario en ADMINISTRADOR ni en ALUMNO.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    // 1. Guardar token y vigencia de 15 min
    public boolean guardarTokenRecuperacion(String correo, String token) {
        String sql = "UPDATE ALUMNO SET TOKEN_RECUPERACION = ?, " +
                "TOKEN_EXPIRACION = SYSTIMESTAMP + INTERVAL '15' MINUTE " +
                "WHERE LOWER(TRIM(CORREO)) = LOWER(TRIM(?))";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, correo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Validar token
    public boolean validarToken(String correo, String token) {
        String sql = "SELECT ID_ALUMNO FROM ALUMNO " +
                "WHERE LOWER(TRIM(CORREO)) = LOWER(TRIM(?)) " +
                "AND TOKEN_RECUPERACION = ? " +
                "AND TOKEN_EXPIRACION >= SYSTIMESTAMP";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Cambiar contraseña y limpiar token
    public boolean actualizarContrasena(String correo, String nuevaContrasena) {
        String sql = "UPDATE ALUMNO SET CONTRASENA = ?, TOKEN_RECUPERACION = NULL, TOKEN_EXPIRACION = NULL " +
                "WHERE LOWER(TRIM(CORREO)) = LOWER(TRIM(?))";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaContrasena);
            ps.setString(2, correo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}