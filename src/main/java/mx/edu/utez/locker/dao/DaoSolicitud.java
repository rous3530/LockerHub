package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.model.EdificioDto;
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
            System.err.println("Error al obtener solicitudes pendientes: " + e.getMessage());
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
            System.err.println("Error al cambiar estado de solicitud: " + e.getMessage());
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
            System.err.println("Error al obtener el total de lockers: " + e.getMessage());
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
            System.err.println("Error al obtener lockers disponibles: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // 5. REGISTRAR UNA NUEVA SOLICITUD
    public boolean registrarSolicitud(int idAlumno, int idEdificio, int idPeriodoCuatri, String grupo, String cuatrimestre) {
        String query = "INSERT INTO SOLICITUD (" +
                "FECHA_SOLICITUD, ESTATUS_SOLICITUD, ID_ALUMNO, ID_EDIFICIO, " +
                "ID_PERIODO_CUATRI, GRUPO_ACTUAL, CUATRI_ACTUAL" +
                ") VALUES (SYSDATE, 'PENDIENTE', ?, ?, ?, ?, ?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idAlumno);
            ps.setInt(2, idEdificio);
            ps.setInt(3, idPeriodoCuatri);
            ps.setString(4, grupo);
            ps.setString(5, cuatrimestre);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar solicitud: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // 6. OBTENER LISTA DE EDIFICIOS / DOCENCIAS
    public List<EdificioDto> obtenerEdificios() {
        List<EdificioDto> lista = new ArrayList<>();
        // Consulta principal a EDIFICIOS; si falla por diferencia de nombre en la BD, intenta con EDIFICIO
        String query = "SELECT id_edificio, nombre FROM EDIFICIOS ORDER BY id_edificio ASC";

        try (Connection con = ConnectionOracle.getConnection()) {
            if (con == null) {
                System.err.println("Error: La conexión a la base de datos es NULL.");
                return lista;
            }

            try (PreparedStatement ps = con.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    EdificioDto edificio = new EdificioDto();
                    edificio.setIdEdificio(rs.getInt("id_edificio"));
                    edificio.setNombre(rs.getString("nombre"));
                    lista.add(edificio);
                }
            } catch (SQLException ex) {
                // Alternativa en caso de que la tabla esté nombrada en singular (EDIFICIO)
                String fallbackQuery = "SELECT id_edificio, nombre FROM EDIFICIO ORDER BY id_edificio ASC";
                try (PreparedStatement psFallback = con.prepareStatement(fallbackQuery);
                     ResultSet rsFallback = psFallback.executeQuery()) {

                    while (rsFallback.next()) {
                        EdificioDto edificio = new EdificioDto();
                        edificio.setIdEdificio(rsFallback.getInt("id_edificio"));
                        edificio.setNombre(rsFallback.getString("nombre"));
                        lista.add(edificio);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener la lista de edificios: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public class LockerDto {
        private int idLocker;
        private String numeroLocker;

        public LockerDto() {}

        public LockerDto(int idLocker, String numeroLocker) {
            this.idLocker = idLocker;
            this.numeroLocker = numeroLocker;
        }

        public int getIdLocker() { return idLocker; }
        public void setIdLocker(int idLocker) { this.idLocker = idLocker; }

        public String getNumeroLocker() { return numeroLocker; }
        public void setNumeroLocker(String numeroLocker) { this.numeroLocker = numeroLocker; }
    }

    // 7. OBTENER LOCKERS DISPONIBLES POR EDIFICIO
    public List<LockerDto> obtenerLockersDisponiblesPorEdificio(int idEdificio) {
        List<LockerDto> lista = new ArrayList<>();
        String query = "SELECT id_locker, numero_locker FROM LOCKERS " +
                "WHERE id_edificio = ? AND UPPER(estatus) = 'DISPONIBLE' " +
                "ORDER BY numero_locker ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idEdificio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LockerDto locker = new LockerDto();
                    locker.setIdLocker(rs.getInt("id_locker"));
                    locker.setNumeroLocker(rs.getString("numero_locker"));
                    lista.add(locker);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener lockers disponibles por edificio: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}