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

    // 8. OBTENER SOLICITUDES POR ESTADO
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
        private String idLocker;
        private String numeroLocker;
        private String piso; // Campo agregado para soportar el filtro por planta
        private String estatus;

        public LockerDto() {}

        public LockerDto(String idLocker, String numeroLocker, String piso) {
            this.idLocker = idLocker;
            this.numeroLocker = numeroLocker;
            this.piso = piso;
            this.estatus = estatus;
        }

        public String getIdLocker() { return idLocker; }
        public void setIdLocker(String idLocker) { this.idLocker = idLocker; }

        public String getNumeroLocker() { return numeroLocker; }
        public void setNumeroLocker(String numeroLocker) { this.numeroLocker = numeroLocker; }

        public String getPiso() { return piso; }
        public void setPiso(String piso) { this.piso = piso; }

        public String getEstatus() { return estatus; }
        public void setEstatus(String estatus) { this.estatus = estatus; }
    }

    public List<LockerDto> obtenerLockersPorEdificio(int idEdificio) {
        List<LockerDto> lista = new ArrayList<>();
        // Consultamos TODOS los lockers del edificio, sin importar su estatus
        String query = "SELECT ID_LOCKER, NUMERO, PLANTA, ESTATUS " +
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
                    dto.setEstatus(rs.getString("ESTATUS")); // Aquí viaja "OCUPADO" o "DISPONIBLE"
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean asignarLockerASolicitud(int idSolicitud, String idLocker) {
        String querySolicitud = "UPDATE SOLICITUD SET ID_LOCKER = ? WHERE ID_SOLICITUD = ?";
        String queryLocker = "UPDATE LOCKER SET ESTATUS = 'OCUPADO' WHERE ID_LOCKER = ?"; // Opcional si quieres actualizar el estatus del casillero

        try (Connection con = ConnectionOracle.getConnection()) {
            con.setAutoCommit(false); // Transacción para asegurar integridad

            try (PreparedStatement psSol = con.prepareStatement(querySolicitud);
                 PreparedStatement psLock = con.prepareStatement(queryLocker)) {

                // 1. Actualizar la solicitud con el locker elegido
                psSol.setString(1, idLocker); // Cambiado a setString porque idLocker es String
                psSol.setInt(2, idSolicitud);
                psSol.executeUpdate();

                // 2. Cambiar estatus del locker a ocupado
                psLock.setString(1, idLocker); // Cambiado a setString porque idLocker es String
                psLock.executeUpdate();

                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean aceptarTodasLasSolicitudes() {
        String query = "UPDATE SOLICITUD SET ESTATUS_SOLICITUD = 'ACEPTADA' WHERE ESTATUS_SOLICITUD = 'PRE_ACEPTADA' AND ID_LOCKER IS NOT NULL";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<SolicitudDto> obtenerEstudiantesAceptados() {
        List<SolicitudDto> lista = new ArrayList<>();
        String query = "SELECT s.ID_SOLICITUD, a.MATRICULA, a.NOMBRES, a.APELLIDO_PATERNO, a.APELLIDO_MATERNO, a.CORREO, " +
                "s.CUATRI_ACTUAL, s.GRUPO_ACTUAL " +
                "FROM SOLICITUD s " +
                "JOIN ALUMNO a ON s.ID_ALUMNO = a.ID_ALUMNO " +
                "WHERE s.ESTATUS_SOLICITUD = 'ACEPTADA'";

        System.out.println("=== EJECUTANDO CONSULTA DE ESTUDIANTES ACEPTADOS ===");

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudDto sol = SolicitudDto.mapearDesdeResultSet(rs);
                lista.add(sol);
                System.out.println("Estudiante aceptado encontrado -> Matrícula: " + sol.getMatricula() + ", Nombre: " + sol.getNombreCompleto());
            }

            System.out.println("Total de estudiantes aceptados cargados desde la BD: " + lista.size());

        } catch (SQLException e) {
            System.out.println("ERROR SQL al obtener estudiantes aceptados:");
            e.printStackTrace();
        }
        return lista;
    }

    public boolean cambiarEstatusPendiente(int idEstudiante) {
        boolean exito = false;
        // Asegúrate de que el nombre de tu tabla y columnas coincidan con tu base de datos (ej. tabla SOLICITUD, columna ESTATUS, ID_ESTUDIANTE)
        String query = "UPDATE SOLICITUD SET ESTATUS = 'PENDIENTE' WHERE ID_ESTUDIANTE = ?";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, idEstudiante);
            int filasAfectadas = ps.executeUpdate();
            exito = filasAfectadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exito;
    }
}