package mx.edu.utez.locker.model;

public class SolicitudDto {
    private int idSolicitud;
    private String matricula;
    private String nombreCompleto;
    private String email;
    private String carrera;
    private String cuatrimestre;
    private String grupo;
    private String estado;
    private String casilleroCodigo;

    public SolicitudDto() {}

    public SolicitudDto(int idSolicitud, String matricula, String nombreCompleto, String email, String carrera, String cuatrimestre, String grupo, String estado) {
        this.idSolicitud = idSolicitud;
        this.matricula = matricula;
        this.nombreCompleto = nombreCompleto;
        this.email = email;
        this.carrera = carrera;
        this.cuatrimestre = cuatrimestre;
        this.grupo = grupo;
        this.estado = estado;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCasilleroCodigo() { return casilleroCodigo; }
    public void setCasilleroCodigo(String casilleroCodigo) { this.casilleroCodigo = casilleroCodigo; }

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    // Método puente añadido para compatibilidad con setId(...)
    public void setId(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getCarrera() { return carrera; }
    public void setCarrera(String carrera) { this.carrera = carrera; }

    public String getCuatrimestre() { return cuatrimestre; }
    public void setCuatrimestre(String cuatrimestre) { this.cuatrimestre = cuatrimestre; }

    public String getGrupo() { return grupo; }
    public void setGrupo(String grupo) { this.grupo = grupo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getIniciales() {
        if (nombreCompleto == null || nombreCompleto.trim().isEmpty()) {
            return "ST";
        }
        String[] partes = nombreCompleto.trim().split("\\s+");
        if (partes.length >= 2) {
            return (partes[0].substring(0, 1) + partes[1].substring(0, 1)).toUpperCase();
        }
        return partes[0].substring(0, Math.min(2, partes[0].length())).toUpperCase();
    }

    public void setIniciales(String iniciales) {
    }

    public static SolicitudDto mapearDesdeResultSet(java.sql.ResultSet rs) throws java.sql.SQLException {
        SolicitudDto sol = new SolicitudDto();
        sol.setIdSolicitud(rs.getInt("ID_SOLICITUD"));
        sol.setMatricula(rs.getString("MATRICULA"));

        String nombres = rs.getString("NOMBRES");
        String apellidoPaterno = rs.getString("APELLIDO_PATERNO");
        String apellidoMaterno = rs.getString("APELLIDO_MATERNO");

        String nombreCompleto = (nombres != null ? nombres : "") + " " +
                (apellidoPaterno != null ? apellidoPaterno : "") + " " +
                (apellidoMaterno != null ? apellidoMaterno : "");

        sol.setNombreCompleto(nombreCompleto.trim());
        sol.setEmail(rs.getString("CORREO"));
        sol.setCuatrimestre(rs.getInt("CUATRI_ACTUAL") + "to");
        sol.setGrupo(rs.getString("GRUPO_ACTUAL"));
        return sol;
    }
}