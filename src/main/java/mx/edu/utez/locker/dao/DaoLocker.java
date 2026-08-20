package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.model.LockerDto;
import mx.edu.utez.locker.ConnectionOracle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DaoLocker {

    // Método para obtener TODOS los lockers de un edificio (disponibles, ocupados, etc.)
    public List<LockerDto> obtenerLockersPorEdificio(int idEdificio) {
        List<LockerDto> lista = new ArrayList<>();
        String query = "SELECT ID_LOCKER, NUMERO, PLANTA, ESTATUS, ID_EDIFICIO " +
                "FROM LOCKER " +
                "WHERE ID_EDIFICIO = ? " +
                "ORDER BY NUMERO ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idEdificio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LockerDto dto = new LockerDto();
                    dto.setIdLocker(rs.getString("ID_LOCKER"));
                    dto.setNumeroLocker(rs.getString("NUMERO"));
                    dto.setPiso(rs.getString("PLANTA"));
                    dto.setEstatus(rs.getString("ESTATUS"));
                    // Si tu DTO maneja el idEdificio, puedes mapearlo también:
                    // dto.setIdEdificio(rs.getInt("ID_EDIFICIO"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean liberarCasilleroPorEstudiante(int idSolicitud) {
        String sql = "UPDATE SOLICITUD SET ID_LOCKER = NULL WHERE ID_SOLICITUD = ?";


        try (Connection conn = ConnectionOracle.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Nos aseguramos de que la conexión permita commit manual o forzamos commit
            conn.setAutoCommit(false);

            ps.setInt(1, idSolicitud);
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                conn.commit(); // ¡Esto guarda permanentemente el cambio en Oracle!
                System.out.println("Filas realmente afectadas en la tabla SOLICITUD: " + filasAfectadas);
                return true;
            } else {
                conn.rollback();
                System.out.println("No se encontró la solicitud con ID: " + idSolicitud);
                return false;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}