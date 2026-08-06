package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.model.SolicitudDto;
import mx.edu.utez.locker.ConnectionOracle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DaoSolicitud {

    // 1. OBTENER LISTA DE SOLICITUDES PENDIENTES
    public List<SolicitudDto> obtenerSolicitudesPendientes() {
        List<SolicitudDto> lista = new ArrayList<>();
        String query = "SELECT s.ID_SOLICITUD, a.matricula, " +
                "a.nombres || ' ' || a.primer_apellido || ' ' || NVL(a.segundo_apellido, '') AS nombre_completo, " +
                "a.carrera, s.CUATRI_ACTUAL, s.GRUPO_ACTUAL, s.ESTATUS_SOLICITUD " +
                "FROM SOLICITUD s " +
                "INNER JOIN ALUMNOS a ON s.ID_ALUMNO = a.id_alumno " +
                "WHERE s.ESTATUS_SOLICITUD = 'PENDIENTE' " +
                "ORDER BY s.FECHA_SOLICITUD ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudDto dto = new SolicitudDto();
                dto.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
                dto.setMatricula(rs.getString("matricula"));
                dto.setNombreCompleto(rs.getString("nombre_completo"));
                dto.setCarrera(rs.getString("carrera"));
                dto.setCuatrimestre(rs.getString("CUATRI_ACTUAL"));
                dto.setGrupo(rs.getString("GRUPO_ACTUAL"));
                dto.setEstado(rs.getString("ESTATUS_SOLICITUD"));

                lista.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // 2. CAMBIAR ESTATUS DE LA SOLICITUD POR MATRÍCULA
    public boolean cambiarEstadoSolicitud(String matricula, String nuevoEstatus) {
        String query = "UPDATE SOLICITUD " +
                "SET ESTATUS_SOLICITUD = ? " +
                "WHERE ESTATUS_SOLICITUD = 'PENDIENTE' " +
                "AND ID_ALUMNO = (SELECT id_alumno FROM ALUMNOS WHERE matricula = ?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, nuevoEstatus);
            ps.setString(2, matricula);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. OBTENER TOTAL DE LOCKERS REGISTRADOS EN SISTEMA
    public int obtenerTotalLockers() {
        String query = "SELECT COUNT(*) FROM LOCKERS";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. OBTENER TOTAL DE LOCKERS DISPONIBLES
    public int obtenerLockersDisponibles() {
        String query = "SELECT COUNT(*) FROM LOCKERS WHERE estatus = 'DISPONIBLE'";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}