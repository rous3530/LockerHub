package mx.edu.utez.locker;

import java.io.File;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionOracle {

    private static final String USER = "admin";
    private static final String PASSWORD = "contrasenaSegura1!";

    public static Connection getConnection() throws SQLException {
        try {
            // 1. Obtener la ruta de la carpeta 'wallet' desde el ClassLoader
            URL walletUrl = ConnectionOracle.class.getClassLoader().getResource("wallet");

            if (walletUrl == null) {
                throw new SQLException("No se encontró la carpeta 'wallet' en src/main/resources/wallet/");
            }

            // 2. Formatear la ruta para Windows (convertir '\' a '/')
            File walletDir = new File(walletUrl.toURI());
            String walletPath = walletDir.getAbsolutePath().replace("\\", "/");

            // 3. Registrar la ruta global de la Wallet
            System.setProperty("oracle.net.tns_admin", walletPath);

            // 4. Usar el alias exacto de tu tnsnames.ora: lockerhub_high
            String dbUrl = "jdbc:oracle:thin:@lockerhub_high?TNS_ADMIN=" + walletPath;

            Class.forName("oracle.jdbc.OracleDriver");
            return DriverManager.getConnection(dbUrl, USER, PASSWORD);

        } catch (Exception e) {
            throw new SQLException("Error al conectar con la base de datos Oracle: " + e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        System.out.println("Intentando conectar a Oracle Autonomous Database...");
        try (Connection con = getConnection()) {
            if (con != null && !con.isClosed()) {
                System.out.println("==========================================");
                System.out.println(" ¡CONEXIÓN EXITOSA A ORACLE DATABASE!");
                System.out.println(" Conectado correctamente como: " + USER);
                System.out.println("==========================================");
            }
        } catch (SQLException e) {
            System.err.println("==========================================");
            System.err.println(" ERROR DE CONEXIÓN:");
            e.printStackTrace();
            System.err.println("==========================================");
        }
    }
}