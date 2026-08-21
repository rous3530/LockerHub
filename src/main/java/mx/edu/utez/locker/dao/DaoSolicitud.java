package mx.edu.utez.locker.dao;

import mx.edu.utez.locker.model.EdificioDto;
import mx.edu.utez.locker.model.SolicitudDto;
import mx.edu.utez.locker.model.CasilleroDto;
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
                "WHERE ID_ALUMNO = (SELECT ID_ALUMNO FROM ALUMNO WHERE MATRICULA = ?)";

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
    public boolean registrarSolicitud(int idAlumno, String idEdificioParam, String idLocker, int idPeriodoCuatri, String grupo, String cuatrimestre) {
        System.out.println("=== INICIANDO REGISTRO DE SOLICITUD ===");
        System.out.println("Parámetros recibidos -> idAlumno: " + idAlumno +
                ", idEdificioParam: " + idEdificioParam +
                ", idLocker: " + idLocker +
                ", idPeriodoCuatri: " + idPeriodoCuatri +
                ", grupo: " + grupo +
                ", cuatrimestre: " + cuatrimestre);

        // 1. Obtener el ID numérico del edificio si viene como texto (ej. "Docencia 1" o similar)
        int idEdificioNum = 0;
        try {
            // Intentamos parsearlo directamente por si acaso ya era un número
            idEdificioNum = Integer.parseInt(idEdificioParam);
        } catch (NumberFormatException e) {
            // Si es texto (ej. "Docencia 1"), buscamos su ID correspondiente en la tabla EDIFICIO
            String queryEdificio = "SELECT ID_EDIFICIO FROM EDIFICIO WHERE NOMBRE = ?";
            try (Connection con = ConnectionOracle.getConnection();
                 PreparedStatement psEdificio = con.prepareStatement(queryEdificio)) {

                psEdificio.setString(1, idEdificioParam);
                try (ResultSet rs = psEdificio.executeQuery()) {
                    if (rs.next()) {
                        idEdificioNum = rs.getInt("ID_EDIFICIO");
                    }
                }
            } catch (SQLException ex) {
                System.err.println("Error al buscar el ID del edificio por nombre: " + ex.getMessage());
                ex.printStackTrace();
            }
        }

        if (idEdificioNum == 0) {
            System.err.println("ERROR: No se pudo determinar un ID de edificio válido para: " + idEdificioParam);
            return false;
        }

        // 2. Consulta de inserción final usando los IDs numéricos correctos
        String query = "INSERT INTO SOLICITUD (" +
                "FECHA_SOLICITUD, ESTATUS_SOLICITUD, ID_ALUMNO, ID_EDIFICIO, " +
                "ID_LOCKER, ID_PERIODO_CUATRI, GRUPO_ACTUAL, CUATRI_ACTUAL" +
                ") VALUES (SYSDATE, 'PENDIENTE', ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            if (con == null) {
                System.err.println("ERROR CRÍTICO: La conexión a Oracle es NULL.");
                return false;
            }

            ps.setInt(1, idAlumno);
            ps.setInt(2, idEdificioNum); // Usamos el ID numérico ya resuelto
            ps.setString(3, idLocker);    // ID_LOCKER (como D1-02, etc.)
            ps.setInt(4, idPeriodoCuatri);
            ps.setString(5, grupo);
            ps.setString(6, cuatrimestre);

            System.out.println("Ejecutando sentencia SQL de inserción con ID_EDIFICIO: " + idEdificioNum);
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                System.out.println("¡Solicitud registrada con éxito en la base de datos!");
                return true;
            }

        } catch (SQLException e) {
            System.err.println("ERROR SQL al registrar solicitud: " + e.getMessage());
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

    public List<SolicitudDto> obtenerEstudiantesAceptados() {
        List<SolicitudDto> lista = new ArrayList<>();
        String query = "SELECT s.ID_SOLICITUD, a.MATRICULA, " +
                "a.NOMBRES || ' ' || a.APELLIDO_PATERNO || ' ' || NVL(a.APELLIDO_MATERNO, '') AS nombre_completo, " +
                "a.CORREO, s.CUATRI_ACTUAL, s.GRUPO_ACTUAL " +
                "FROM SOLICITUD s " +
                "JOIN ALUMNO a ON s.ID_ALUMNO = a.ID_ALUMNO " +
                "WHERE UPPER(s.ESTATUS_SOLICITUD) = 'ACEPTADA'";

        System.out.println("=== EJECUTANDO CONSULTA DE ESTUDIANTES ACEPTADOS ===");

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudDto sol = new SolicitudDto();
                sol.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
                sol.setMatricula(rs.getString("MATRICULA"));
                sol.setNombreCompleto(rs.getString("nombre_completo"));
                sol.setEmail(rs.getString("CORREO"));
                sol.setCuatrimestre(rs.getString("CUATRI_ACTUAL"));
                sol.setGrupo(rs.getString("GRUPO_ACTUAL"));

                // Generación de iniciales automáticas para el avatar en la vista
                String nombreCompleto = sol.getNombreCompleto();
                if (nombreCompleto != null && !nombreCompleto.isEmpty()) {
                    String[] partes = nombreCompleto.trim().split("\\s+");
                    String iniciales = partes[0].substring(0, 1).toUpperCase();
                    if (partes.length > 1) {
                        iniciales += partes[1].substring(0, 1).toUpperCase();
                    }
                    sol.setIniciales(iniciales);
                }

                lista.add(sol);
            }

            System.out.println("Total de estudiantes aceptados cargados desde la BD: " + lista.size());

        } catch (SQLException e) {
            System.out.println("ERROR SQL al obtener estudiantes aceptados:");
            e.printStackTrace();
        }
        return lista;
    }

    public boolean regresarAStatusPendiente(int idSolicitud) {
        // Ajusta la columna 'ESTATUS' y el valor según cómo los nombres en tu tabla SOLICITUD
        String sql = "UPDATE SOLICITUD SET ESTATUS_SOLICITUD = 'PENDIENTE', ID_LOCKER = NULL WHERE ID_SOLICITUD = ?";

        try (Connection conn = ConnectionOracle.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false); // Desactivar autocommit para control transaccional en Oracle

            ps.setInt(1, idSolicitud);
            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas > 0) {
                conn.commit(); // Guardar cambios de forma permanente
                System.out.println("Solicitud " + idSolicitud + " regresada a estatus pendiente exitosamente.");
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

    public List<LockerDto> obtenerLockersPorEdificio(String idEdificio) {
        List<LockerDto> lista = new ArrayList<>();
        // Consultamos TODOS los lockers del edificio, sin importar su estatus
        String query = "SELECT ID_LOCKER, NUMERO, PLANTA, ESTATUS " +
                "FROM LOCKER " +
                "WHERE ID_EDIFICIO = ? " +
                "ORDER BY NUMERO ASC";

        try (Connection con = ConnectionOracle.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, idEdificio);
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

    public boolean asignarLockersAutomaticamente() {
        // 1. Consultar solicitudes pre-aceptadas sin casillero
        String sqlSolicitudes = "SELECT ID_SOLICITUD FROM SOLICITUD WHERE ESTATUS_SOLICITUD = 'PRE_ACEPTADA' AND ID_LOCKER IS NULL";
        // 2. Buscar lockers disponibles
        String sqlLockersDisp = "SELECT ID_LOCKER FROM LOCKER WHERE ESTATUS = 'DISPONIBLE' AND ROWNUM = 1";
        // 3. Actualizar la solicitud con el locker
        String sqlAsignar = "UPDATE SOLICITUD SET ID_LOCKER = ? WHERE ID_SOLICITUD = ?";


        try (Connection conn = ConnectionOracle.getConnection()) {
            conn.setAutoCommit(false); // Transacción segura

            System.out.println("[DaoSolicitud] Buscando solicitudes 'PRE_ACEPTADA' sin locker...");

            // Obtenemos los estudiantes sin casillero
            try (PreparedStatement psSol = conn.prepareStatement(sqlSolicitudes);
                 ResultSet rsSol = psSol.executeQuery()) {

                int totalAsignados = 0;
                while (rsSol.next()) {
                    int idSolicitud = rsSol.getInt("ID_SOLICITUD");
                    System.out.println("[DaoSolicitud] Procesando ID_SOLICITUD: " + idSolicitud);

                    // Buscamos un locker disponible para este estudiante
                    String idLockerAsignado = null;
                    try (PreparedStatement psLock = conn.prepareStatement(sqlLockersDisp);
                         ResultSet rsLock = psLock.executeQuery()) {
                        if (rsLock.next()) {
                            idLockerAsignado = rsLock.getString("ID_LOCKER");
                        }
                    }

                    // Si ya no hay lockers disponibles, rompemos el ciclo
                    if (idLockerAsignado == null) {
                        System.out.println("[DaoSolicitud] ⚠️ Ya no hay lockers disponibles en la BD para más estudiantes.");
                        break;
                    }

                    System.out.println("[DaoSolicitud] -> Locker disponible encontrado: " + idLockerAsignado);

                    // Asignamos el locker a la solicitud
                    try (PreparedStatement psAsig = conn.prepareStatement(sqlAsignar)) {
                        psAsig.setString(1, idLockerAsignado);
                        psAsig.setInt(2, idSolicitud);
                        psAsig.executeUpdate();
                    }


                    totalAsignados++;
                    System.out.println("[DaoSolicitud] ✓ Locker " + idLockerAsignado + " asignado exitosamente a la solicitud " + idSolicitud);
                }

                System.out.println("[DaoSolicitud] Total de casilleros asignados en este proceso: " + totalAsignados);
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.err.println("[DaoSolicitud] Error crítico en asignación masiva:");
            e.printStackTrace();
            return false;
        }
    }

    public List<CasilleroDto> obtenerTodosLosCasilleros() {
        List<CasilleroDto> lista = new ArrayList<>();
        // Ajustado a los nombres reales de tus tablas: LOCKER y EDIFICIO
        String sql = "SELECT l.ID_LOCKER, l.NUMERO, l.PLANTA, l.ESTATUS, e.NOMBRE AS NOMBRE_EDIFICIO " +
                "FROM LOCKER l JOIN EDIFICIO e ON l.ID_EDIFICIO = e.ID_EDIFICIO";

        // Usamos ConnectionOracle.getConnection() al igual que en tus otros métodos
        try (Connection conn = ConnectionOracle.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CasilleroDto casillero = new CasilleroDto();
                casillero.setCodigo(rs.getString("ID_LOCKER"));         // Ej: PBG10-02
                casillero.setPiso(rs.getString("PLANTA"));             // Ej: PLANTA BAJA
                casillero.setEstado(rs.getString("ESTATUS"));          // Ej: DISPONIBLE
                casillero.setEdificio(rs.getString("NOMBRE_EDIFICIO")); // Nombre del edificio
                lista.add(casillero);
            }
        } catch (Exception e) {
            System.err.println("Error en obtenerTodosLosCasilleros: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }
}