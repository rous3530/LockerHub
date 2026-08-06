package mx.edu.utez.locker.model;

public class SolicitudDto {
    private int idSolicitud;
    private String matricula;
    private String nombreCompleto;
    private String carrera;
    private String cuatrimestre;
    private String grupo;
    private String estado;

    public SolicitudDto() {}

    public SolicitudDto(int idSolicitud, String matricula, String nombreCompleto, String carrera, String cuatrimestre, String grupo, String estado) {
        this.idSolicitud = idSolicitud;
        this.matricula = matricula;
        this.nombreCompleto = nombreCompleto;
        this.carrera = carrera;
        this.cuatrimestre = cuatrimestre;
        this.grupo = grupo;
        this.estado = estado;
    }

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

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
        if (nombreCompleto == null || nombreCompleto.trim().isEmpty()) return "US";
        String[] partes = nombreCompleto.trim().split("\\s+");
        if (partes.length >= 2) {
            return (partes[0].substring(0, 1) + partes[1].substring(0, 1)).toUpperCase();
        }
        return partes[0].substring(0, Math.min(2, partes[0].length())).toUpperCase();
    }
}