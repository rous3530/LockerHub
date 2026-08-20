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

    // Método para liberar el casillero de un estudiante
    public boolean liberarCasilleroPorEstudiante(int idEstudiante) {
        boolean exito = false;
        // Ajusta la consulta dependiendo de cómo relacionalmente guardes la asignación en tu BD Oracle
        String sql = "UPDATE LOCKER SET ESTATUS = 'DISPONIBLE' WHERE ID_LOCKER = (SELECT ID_LOCKER FROM SOLICITUD WHERE ID_SOLICITUD = ?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idEstudiante);
            int filasAfectadas = ps.executeUpdate();
            exito = filasAfectadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exito;
    }
}