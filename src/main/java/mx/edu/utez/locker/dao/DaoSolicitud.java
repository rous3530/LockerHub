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
        String query = "SELECT s.ID_SOLICITUD, a.MATRICULA, " +
                "a.NOMBRES || ' ' || a.APELLIDO_PATERNO || ' ' || NVL(a.APELLIDO_MATERNO, '') AS nombre_completo, " +
                "NVL(c.NOMBRE, 'Sin Carrera') AS carrera, s.CUATRI_ACTUAL, s.GRUPO_ACTUAL, s.ESTATUS_SOLICITUD " +
                "FROM SOLICITUD s " +
                "INNER JOIN ALUMNO a ON s.ID_ALUMNO = a.ID_ALUMNO " +
                "LEFT JOIN CARRERA c ON a.ID_CARRERA = c.ID_CARRERA " +
                "WHERE UPPER(s.ESTATUS_SOLICITUD) = 'PENDIENTE' " +
                "ORDER BY s.FECHA_SOLICITUD ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudDto dto = new SolicitudDto();
                dto.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
                dto.setMatricula(rs.getString("MATRICULA"));
                dto.setNombreCompleto(rs.getString("nombre_completo"));
                dto.setCarrera(rs.getString("carrera"));
                dto.setCuatrimestre(rs.getString("CUATRI_ACTUAL"));
                dto.setGrupo(rs.getString("GRUPO_ACTUAL"));
                dto.setEstado(rs.getString("ESTATUS_SOLICITUD"));

                lista.add(dto);
            }
        } catch (SQLException e) {
            System.err.println("Error en obtenerSolicitudesPendientes: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // 2. CAMBIAR ESTATUS DE LA SOLICITUD POR MATRÍCULA
    public boolean cambiarEstadoSolicitud(String matricula, String nuevoEstatus) {
        String query = "UPDATE SOLICITUD " +
                "SET ESTATUS_SOLICITUD = ? " +
                "WHERE ESTATUS_SOLICITUD = 'PENDIENTE' " +
                "AND ID_ALUMNO = (SELECT ID_ALUMNO FROM ALUMNO WHERE MATRICULA = ?)";

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
        String query = "SELECT COUNT(*) FROM locker";
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
        String query = "SELECT COUNT(*) FROM locker WHERE estatus = 'DISPONIBLE'";
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


// 8. OBTENER SOLICITUDES POR ESTADO (Nombre de tabla EDIFICIO en singular)
public List<SolicitudDto> obtenerSolicitudesPorEstado(String estado) {
    List<SolicitudDto> lista = new ArrayList<>();

    String query = "SELECT s.ID_SOLICITUD, a.MATRICULA, " +
            "a.NOMBRES || ' ' || a.APELLIDO_PATERNO || ' ' || NVL(a.APELLIDO_MATERNO, '') AS nombre_completo, " +
            "NVL(c.NOMBRE, 'Sin Carrera') AS carrera, s.CUATRI_ACTUAL, s.GRUPO_ACTUAL, s.ESTATUS_SOLICITUD, " +
            "CASE " +
            "   WHEN l.NUMERO IS NOT NULL THEN ed.NOMBRE || '-' || l.NUMERO " +
            "   ELSE 'Sin asignar' " +
            "END AS CASILLERO_CODIGO " +
            "FROM SOLICITUD s " +
            "INNER JOIN ALUMNO a ON s.ID_ALUMNO = a.ID_ALUMNO " +
            "LEFT JOIN CARRERA c ON a.ID_CARRERA = c.ID_CARRERA " +
            "LEFT JOIN LOCKER l ON s.ID_LOCKER = l.ID_LOCKER " +
            "LEFT JOIN EDIFICIO ed ON l.ID_EDIFICIO = ed.ID_EDIFICIO " +
            "WHERE UPPER(s.ESTATUS_SOLICITUD) LIKE UPPER(?) " +
            "ORDER BY s.FECHA_SOLICITUD ASC";

    try (Connection con = ConnectionOracle.getConnection();
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setString(1, "%" + estado + "%");

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SolicitudDto dto = new SolicitudDto();
                dto.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
                dto.setMatricula(rs.getString("MATRICULA"));
                dto.setNombreCompleto(rs.getString("nombre_completo"));
                dto.setCarrera(rs.getString("carrera"));
                dto.setCuatrimestre(rs.getString("CUATRI_ACTUAL"));
                dto.setGrupo(rs.getString("GRUPO_ACTUAL"));
                dto.setEstado(rs.getString("ESTATUS_SOLICITUD"));
                dto.setCasilleroCodigo(rs.getString("CASILLERO_CODIGO"));

                lista.add(dto);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error en obtenerSolicitudesPorEstado: " + e.getMessage());
        e.printStackTrace();
    }
    return lista;
}
    // 9. OBTENER TOTAL DE ESTUDIANTES EN ESPERA DE CUPO
    public int obtenerEsperaCupo() {
        String query = "SELECT COUNT(*) FROM SOLICITUD WHERE UPPER(ESTATUS_SOLICITUD) = 'ESPERA_CUPO'";
        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estudiantes en espera de cupo: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    // 7. CLASE DTO INTERNA Y MÉTODO DE LOCKERS
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

    public List<LockerDto> obtenerLockersDisponiblesPorEdificio(int idEdificio) {
        List<LockerDto> lista = new ArrayList<>();
        String query = "SELECT ID_LOCKER, NUMERO " +
                "FROM LOCKER " +
                "WHERE ID_EDIFICIO = ? AND UPPER(ESTATUS) = 'DISPONIBLE' " +
                "ORDER BY NUMERO ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idEdificio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LockerDto dto = new LockerDto();
                    dto.setIdLocker(rs.getInt("ID_LOCKER"));
                    dto.setNumeroLocker(rs.getString("NUMERO"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}