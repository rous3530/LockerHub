package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.ConnectionOracle;
import mx.edu.utez.locker.model.AlumnoDashboardDto;
import mx.edu.utez.locker.model.SolicitudDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DaoAlumnoPortal {

    // 1. OBTENER INFORMACIÓN DEL PERFIL Y LOCKER ACTUAL DEL ALUMNO
    public AlumnoDashboardDto obtenerDashboardAlumno(int idAlumno) {
        AlumnoDashboardDto dto = null;
        String query = "SELECT a.id_alumno, a.matricula, " +
                "a.nombres || ' ' || a.primer_apellido || ' ' || NVL(a.segundo_apellido, '') AS nombre_completo, " +
                "a.carrera, s.CUATRI_ACTUAL, s.GRUPO_ACTUAL, " +
                "l.CODIGO_LOCKER, e.NOMBRE_EDIFICIO, l.PISO, p.NOMBRE_PERIODO, s.ESTATUS_SOLICITUD " +
                "FROM ALUMNOS a " +
                "LEFT JOIN SOLICITUD s ON a.id_alumno = s.ID_ALUMNO AND s.ESTATUS_SOLICITUD IN ('ASIGNADO', 'ACEPTADO', 'PENDIENTE') " +
                "LEFT JOIN ASIGNACION_LOCKER al ON s.ID_SOLICITUD = al.ID_SOLICITUD " +
                "LEFT JOIN LOCKERS l ON al.ID_LOCKER = l.ID_LOCKER " +
                "LEFT JOIN EDIFICIO e ON s.ID_EDIFICIO = e.ID_EDIFICIO " +
                "LEFT JOIN PERIODO_CUATRI p ON s.ID_PERIODO_CUATRI = p.ID_PERIODO_CUATRI " +
                "WHERE a.id_alumno = ?";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idAlumno);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dto = new AlumnoDashboardDto();
                    dto.setIdAlumno(rs.getInt("id_alumno"));
                    dto.setMatricula(rs.getString("matricula"));
                    dto.setNombreCompleto(rs.getString("nombre_completo"));
                    dto.setCarrera(rs.getString("carrera"));
                    dto.setCuatrimestreActual(rs.getString("CUATRI_ACTUAL"));
                    dto.setGrupoActual(rs.getString("GRUPO_ACTUAL"));

                    dto.setIdLocker(rs.getString("CODIGO_LOCKER"));
                    dto.setEdificio(rs.getString("NOMBRE_EDIFICIO"));
                    dto.setPiso(rs.getString("PISO"));
                    dto.setPeriodoVigente(rs.getString("NOMBRE_PERIODO"));
                    dto.setEstatusLocker(rs.getString("ESTATUS_SOLICITUD"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dto;
    }

    // 2. OBTENER RECIENTES SOLICITUDES DEL ALUMNO (ÚLTIMAS 3 PARA LA TABLA)
    public List<SolicitudDto> obtenerHistorialReciente(int idAlumno) {
        List<SolicitudDto> lista = new ArrayList<>();
        String query = "SELECT * FROM (" +
                "    SELECT s.ID_SOLICITUD, l.CODIGO_LOCKER, s.ESTATUS_SOLICITUD, p.NOMBRE_PERIODO " +
                "    FROM SOLICITUD s " +
                "    LEFT JOIN ASIGNACION_LOCKER al ON s.ID_SOLICITUD = al.ID_SOLICITUD " +
                "    LEFT JOIN LOCKERS l ON al.ID_LOCKER = l.ID_LOCKER " +
                "    LEFT JOIN PERIODO_CUATRI p ON s.ID_PERIODO_CUATRI = p.ID_PERIODO_CUATRI " +
                "    WHERE s.ID_ALUMNO = ? " +
                "    ORDER BY s.FECHA_SOLICITUD DESC" +
                ") WHERE ROWNUM <= 3";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idAlumno);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SolicitudDto dto = new SolicitudDto();
                    dto.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
                    dto.setGrupo(rs.getString("CODIGO_LOCKER")); // Usamos atributo como ref de Locker
                    dto.setEstado(rs.getString("ESTATUS_SOLICITUD"));
                    dto.setCuatrimestre(rs.getString("NOMBRE_PERIODO")); // Usamos atributo como periodo
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}